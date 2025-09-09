part of 'templates.dart';

class NotifierTemplate {
  NotifierTemplate(this.notifier);
  final NotifierClass notifier;

  String get notifierName => notifier.name;

  late final mutations = notifier.mutations;
  late final templates = mutations.map(MutationTemplate.new);

  void writeExtension(AnalyzerBuffer buffer) {
    if (mutations.isEmpty) return;

    buffer.write(
      args: {
        'NotifierGenerics': () {
          if (notifier.typeParameters.isEmpty) return;
          buffer.write('<');
          for (final (i, param) in notifier.typeParameters.indexed) {
            if (i > 0) buffer.write(', ');
            buffer.write(param.displayName);
            if (param.bound != null) {
              buffer.write(' extends ${param.bound!.toCode()}');
            }
          }
          buffer.write('>');
        },
        'NotifierGenericsApplication': () {
          if (notifier.typeParameters.isEmpty) return;
          buffer.write('<');
          for (final (i, param) in notifier.typeParameters.indexed) {
            if (i > 0) buffer.write(', ');
            buffer.write(param.displayName);
          }
          buffer.write('>');
        },
        'mutation_getters': () {
          for (final template in templates) {
            template.writeGetter(buffer);
          }
        },
      },
      '''
extension ${notifierName}Mutations#{{NotifierGenerics}} on ${notifierName}Provider#{{NotifierGenericsApplication}} {
  #{{mutation_getters}}
}
''',
    );
  }
}

class MutationTemplate {
  MutationTemplate(this.executable);
  final MutationExecutable executable;

  bool get isGetter =>
      executable.keyedParameters.isEmpty && methodGenerics.isEmpty;

  List<TypeParameterElement2> get methodGenerics =>
      executable.type.typeParameters;

  String get tsx {
    final refInArguments = executable.formalParameters
        .where((p) => p.isMutationRef)
        .firstOrNull;
    if (refInArguments != null) return refInArguments.displayName;

    return 'tsx'.makeUnique(
      executable.formalParameters.map((e) => e.displayName),
    );
  }

  late final String target = 'target'.makeUnique(
    executable.formalParameters.map((e) => e.displayName),
  );

  late final String mutation = 'mutation'.makeUnique(
    executable.formalParameters.map((e) => e.displayName),
  );

  late final String run = 'run'.makeUnique(
    executable.formalParameters.map((e) => e.displayName),
  );

  Map<String, void Function()> sharedArgs(
    AnalyzerBuffer buffer,
  ) => <String, void Function()>{
    'define_method_generics': () {
      if (methodGenerics.isEmpty) return;
      buffer.write('<${methodGenerics.toCodes().join(', ')}>');
    },

    'end_user_params_in_type': () {
      buffer.write(
        executable.endUserParameters.toCode(
          withParentheses: false,
          includeDefaults: false,
        ),
      );
    },
    'end_user_params': () {
      buffer.write(executable.endUserParameters.toCode(withParentheses: false));
    },

    'invoke_end_user_params': () {
      buffer.write(
        executable.endUserParameters.toInvocationCode(withParentheses: false),
      );
    },
    'all_params': () {
      // type parameters
      if (methodGenerics.isNotEmpty) {
        buffer.write('<${methodGenerics.toNames().join(', ')}>');
      }
      //
      buffer.write(
        executable.formalParameters.toInvocationCode(
          omitIfEmpty: false,
          withParentheses: true,
        ),
      );
    },
    'ResultT': () {
      buffer.write(executable.resultT.toCode());
    },
    'MutationTarget': () {
      buffer.write('#{{riverpod|$MutationTarget}}');
    },

    'keyed_args': () {
      if (isGetter) return;
      buffer.write(executable.keyedParameters.toCode());
    },
    'MutationListenable': () {
      buffer.write('#{{riverpod_mutations_annotation|MutationListenable}}');
    },
    'TypedMutationListenable': () {
      buffer.write('''
  #{{MutationListenable}}<
    #{{ResultT}},
    Future<#{{ResultT}}> Function(#{{MutationTarget}} $target, #{{end_user_params_in_type}}),
    Future<#{{ResultT}}> Function(#{{end_user_params_in_type}})
  >
''');
    },
  };

  void writeGetter(AnalyzerBuffer buffer) {
    final String get = isGetter ? 'get ' : '';
    buffer.write(
      args: {
        ...sharedArgs(buffer),
        'CALL': () {
          buffer.write(switch (executable) {
            MutationMethod() =>
              '$tsx.get(this.notifier).${executable.name}#{{all_params}}',
            MutationFunction() => '${executable.name}#{{all_params}}',
          });
        },
        'Mutations': () {
          buffer.write(r'#{{riverpod_mutations_annotation|$Mutations}}');
        },
        'keys_list': () {
          if (executable.keyedParameters.isEmpty) return;
          buffer.write(
            executable.keyedParameters.toInvocationCode(withParentheses: true),
          );
        },
        'CONSTRUCT_MUTATION': () {
          buffer.write(switch (executable) {
            MutationMethod() =>
              "#{{Mutations}}.getForProvider<#{{ResultT}}>(this, '${executable.name}', #{{keys_list}})",
            MutationFunction() =>
              "#{{Mutations}}.getForFunction<#{{ResultT}}>(${executable.name}, '${executable.name}', #{{keys_list}})",
          });
        },
        'getter_name': () {
          buffer.write(switch (executable) {
            MutationMethod() => executable.name.public,
            MutationFunction(isPublic: false) => executable.name.public,
            MutationFunction(isPublic: true) => throw InvalidGenerationSource(
              'Public functions cannot be used as mutations.',
              todo:
                  'Make the function private by prefixing its name with an underscore (_).',
              element: executable.element,
            ),
          });
        },
      },
      '''
  #{{TypedMutationListenable}} $get#{{getter_name}}#{{define_method_generics}}#{{keyed_args}} {
    final $mutation = #{{CONSTRUCT_MUTATION}};
    Future<#{{ResultT}}> $run(#{{MutationTarget}} $target, #{{end_user_params}}) {
      return $mutation.run($target, ($tsx) {
        return #{{CALL}};
      });
    }
    return #{{MutationListenable}}(
      $mutation,
      (#{{MutationTarget}} $target, #{{end_user_params}}) => $run($target, #{{invoke_end_user_params}}),
      (#{{MutationTarget}} $target) => (#{{end_user_params}}) => $run($target, #{{invoke_end_user_params}}),
    );
  }
''',
    );
  }
}
