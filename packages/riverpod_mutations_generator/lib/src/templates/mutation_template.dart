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
        'on_type': () {
          if (riverpodTypeChecker.hasAnnotationOf(notifier.element)) {
            buffer.write(
              '${notifierName}Provider#{{NotifierGenericsApplication}}',
            );
          } else {
            buffer.write(
              '\$ClassProvider<${notifierName}#{{NotifierGenericsApplication}}, dynamic, dynamic, dynamic>',
            );
          }
        },
      },
      '''
extension ${notifierName}Mutations#{{NotifierGenerics}} on #{{on_type}} {
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

  List<TypeParameterElement> get methodGenerics =>
      executable.type.typeParameters;

  Iterable<String> get $parameterNames => executable.formalParameters.names;

  String get tsx {
    final refInArguments = executable.formalParameters
        .where((p) => p.isMutationTsx)
        .firstOrNull;
    if (refInArguments != null) return refInArguments.displayName;

    return 'tsx'.makeUnique($parameterNames);
  }

  late final String target = 'target'.makeUnique($parameterNames);
  late final String mutation = 'mutation'.makeUnique($parameterNames);
  late final String run = 'run'.makeUnique($parameterNames);

  Map<String, void Function()> args(
    AnalyzerBuffer buffer,
  ) => <String, void Function()>{
    'PublicParameters': () {
      buffer.write(executable.endUserParameters.toCode(withParentheses: false));
    },

    'InvokePublicParameters': () {
      buffer.write(
        executable.endUserParameters.toInvocationCode(withParentheses: false),
      );
    },

    'ResultT': () {
      buffer.write(executable.resultT.toCode());
    },
    'MutationTarget': () {
      buffer.write('#{{riverpod|$MutationTarget}}');
    },

    'MutationListenable': () {
      buffer.write('#{{riverpod_mutations_annotation|MutationListenable}}');
    },

    'TypedMutationListenable': () {
      final String endUserParamsInType = executable.endUserParameters.toCode(
        withParentheses: false,
        includeDefaults: false,
      );
      buffer.write('''
  #{{MutationListenable}}<
    #{{ResultT}},
    Future<#{{ResultT}}> Function(#{{MutationTarget}} $target, $endUserParamsInType),
    Future<#{{ResultT}}> Function($endUserParamsInType)
  >
''');
    },

    'CallOriginal': () {
      final String allParams = [
        // type parameters
        if (methodGenerics.isNotEmpty)
          '<${methodGenerics.toNames().join(', ')}>',
        executable.formalParameters.toInvocationCode(
          omitIfEmpty: false,
          withParentheses: true,
        ),
      ].join();

      buffer.write(switch (executable) {
        MutationMethod() =>
          '$tsx.get(this.notifier).${executable.name}$allParams',
        TopLevelFunctionMutation() => '${executable.name}$allParams',
        StaticMutationMethod executable =>
          '${executable.interface.name}.${executable.name}$allParams',
      });
    },
  };

  /// [$Mutations.ofProvider]
  /// [$Mutations.ofFunction]
  String get constructMutation {
    final String keysList = executable.keyedParameters.toInvocationCode(
      withParentheses: true,
      omitIfEmpty: true,
    );

    const Mutations = r'#{{riverpod_mutations_annotation|$Mutations}}';

    return switch (executable) {
      MutationMethod() =>
        "$Mutations.ofProvider<#{{ResultT}}>(this, '${executable.name}', $keysList)",
      TopLevelFunctionMutation() =>
        "$Mutations.ofFunction<#{{ResultT}}>(${executable.name}, '${executable.name}', $keysList)",
      StaticMutationMethod executable =>
        "$Mutations.ofFunction<#{{ResultT}}>(${executable.interface.name}.${executable.name}, '${executable.interface.name}.${executable.name}', $keysList)",
    };
  }

  late String getterName = switch (executable) {
    MutationMethod() => executable.name.public,
    // _$ClassName_methodName
    StaticMutationMethod executable =>
      '_\$${executable.interface.name}_${executable.name.public}',
    TopLevelFunctionMutation(isPublic: false) => executable.name.public,
    TopLevelFunctionMutation(isPublic: true) => throw InvalidGenerationSource(
      'Public functions cannot be used as mutations.',
      todo:
          'Make the function private by prefixing its name with an underscore (_).',
      element: executable.element,
    ),
  };

  String get getterDefinition {
    final String get = isGetter ? 'get ' : '';

    final String keyedArgs = !isGetter
        ? executable.keyedParameters.toCode()
        : '';

    final String generics = methodGenerics.toGenericsCode();

    return '$get$getterName$generics$keyedArgs';
  }

  void writeGetter(AnalyzerBuffer buffer) {
    buffer.write(args: args(buffer), '''
  #{{TypedMutationListenable}} $getterDefinition {
    final $mutation = $constructMutation;
    Future<#{{ResultT}}> $run(#{{MutationTarget}} $target, #{{PublicParameters}}) {
      return $mutation.run($target, ($tsx) {
        return #{{CallOriginal}};
      });
    }
    return #{{MutationListenable}}(
      $mutation,
      $run,
      (#{{MutationTarget}} $target) => (#{{PublicParameters}}) => $run($target, #{{InvokePublicParameters}}),
    );
  }
''');
  }
}
// typedef BufferArgs = Map<String, void Function()>;

// extension on AnalyzerBuffer {
//   static final _laterCodes = Expando<List<(String, BufferArgs)>>();
//   void writeLater(String code, {BufferArgs args = const {}}) {
//     final list = _laterCodes[this] ??= [];
//     list.add((code, args));
//   }

//   void flush() {
//     final list = _laterCodes[this];
//     if (list == null) return;
//     for (final (code, args) in list) {
//       write(args: args, code);
//     }
//     _laterCodes[this] = null;
//   }
// }
