part of 'templates.dart';

class NotifierTemplate {
  NotifierTemplate(this.notifier);
  final NotifierClass notifier;

  String get notifierName => notifier.name;

  late final mutations = notifier.mutations;
  late final templates = mutations.map((m) => MutationTemplate(m));

  void defineInLibrary(AnalyzerBuffer buffer) {
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
            template.invokeInExtension(buffer);
          }
        },
        'mutation_classes': () {
          // for (final template in templates) {
          //   template.defineInLibrary(buffer);
          // }
        },
      },
      '''
extension ${notifierName}Mutations#{{NotifierGenerics}} on ${notifierName}Provider#{{NotifierGenericsApplication}} {
  Mutation<T> _\$mutation<T>(String mutationName, [Object? key]) => \$Mutations.getForProvider<T>(this, mutationName, key);
  #{{mutation_getters}}
}
#{{mutation_classes}}
''',
    );
  }
}

class MutationTemplate {
  MutationTemplate(this.method);
  final MutationMethod method;
  NotifierClass get notifier => method.notifier;

  // TODO: underscore or no?
  String get mutationClassName =>
      '${notifier.name}_${method.name.public.properNoun}';

  bool get isGetter => method.keyedParameters.isEmpty && methodGenerics.isEmpty;

  List<TypeParameterElement2> get methodGenerics => method.type.typeParameters;
  List<TypeParameterElement2> get classGenerics => notifier.typeParameters;

  List<TypeParameterElement2> get nonConflictingGenerics => [
    for (final generic in classGenerics)
      if (!methodGenerics.toNames().contains(generic.displayName)) generic,
  ];

  String get tsx {
    final refInArguments = method.formalParameters
        .where((p) => p.isMutationRef)
        .firstOrNull;
    if (refInArguments != null) return refInArguments.displayName;

    return 'tsx'.makeUnique(method.formalParameters.map((e) => e.displayName));
  }

  late final String target = 'target'.makeUnique(
    method.formalParameters.map((e) => e.displayName),
  );

  late final String mutation = 'mutation'.makeUnique(
    method.formalParameters.map((e) => e.displayName),
  );

  late final String run = 'run'.makeUnique(
    method.formalParameters.map((e) => e.displayName),
  );

  Map<String, void Function()> sharedArgs(AnalyzerBuffer buffer) =>
      <String, void Function()>{
        'define_method_generics': () {
          if (methodGenerics.isEmpty) return;
          buffer.write('<${methodGenerics.toCodes().join(', ')}>');
        },

        'end_user_params_in_type': () {
          buffer.write(
            method.endUserParameters.toCode(
              withParentheses: false,
              includeDefaults: false,
            ),
          );
        },
        'end_user_params': () {
          buffer.write(method.endUserParameters.toCode(withParentheses: false));
        },

        'invoke_end_user_params': () {
          buffer.write(
            method.endUserParameters.toInvocationCode(withParentheses: false),
          );
        },
        'all_params': () {
          // type parameters
          if (methodGenerics.isNotEmpty) {
            buffer.write('<${methodGenerics.toNames().join(', ')}>');
          }
          //
          buffer.write(
            method.formalParameters.toInvocationCode(
              omitIfEmpty: false,
              withParentheses: true,
            ),
          );
        },
        'ResultT': () {
          buffer.write(method.resultT.toCode());
        },
        'MutationTarget': () {
          buffer.write('#{{riverpod|$MutationTarget}}');
        },
        // 'MutationTransaction': () {
        //   buffer.write('#{{riverpod|$MutationRef}}');
        //   // in a newer version
        //   // buffer.write('#{{riverpod|MutationTransaction}}');
        // },
      };

  void invokeInExtension(AnalyzerBuffer buffer) {
    final String get = isGetter ? 'get ' : '';
    buffer.write(
      args: {
        'keys_list': () {
          buffer.write(
            method.keyedParameters.toInvocationCode(omitIfEmpty: true),
          );
        },
        'keyed_args': () {
          if (isGetter) return;
          buffer.write(method.keyedParameters.toCode());
        },
        ...sharedArgs(buffer),
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
      },
      '''
  #{{TypedMutationListenable}} $get${method.name}#{{define_method_generics}}#{{keyed_args}} {
    final $mutation = _\$mutation<#{{ResultT}}>(
        '${method.name}',
        #{{keys_list}}
      );
    Future<#{{ResultT}}> $run(#{{MutationTarget}} $target, #{{end_user_params}}) {
      return $mutation.run($target, ($tsx) {
        return $tsx.get(this.notifier).${method.name}#{{all_params}};
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
