part of 'templates.dart';

class MutationTemplate {
  MutationTemplate(this.executable);
  final MutationExecutable executable;
  MutationAnnotation get annotation {
    return MutationAnnotation.from(
      annotation: mutationTypeChecker.firstAnnotationOfExact(
        executable.element,
      ),
      config: Config.current,
    );
  }

  bool get isGetter =>
      executable.keyedParameters.isEmpty && methodGenerics.isEmpty;

  List<TypeParameterElement> get methodGenerics =>
      executable.type.typeParameters;

  Iterable<String> get $parameterNames => executable.formalParameters.names;

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

  static const tsx = r'_$tsx';
  static const target = r'_$target';
  static const mutation = r'_$mutation';
  static const run = r'_$run';

  static const template =
      '''
  #{{TypedMutationListenable}} #{{getterDefinition}} {
    final $mutation = #{{constructMutation}};
    Future<#{{ResultT}}> $run(#{{MutationTarget}} $target, #{{PublicParameters}}) {
      return $mutation.run($target, ($tsx) {
        return #{{CallOriginal}};
      });
    }
    return #{{MutationListenable}}($mutation, $run);
  }
''';
  static const templatePair =
      '''
  #{{TypedMutationPairListenable}} #{{getterDefinition}} {
    final $mutation = #{{constructMutation}};
    Future<#{{ResultT}}> $run(#{{MutationTarget}} $target, #{{PublicParameters}}) {
      return $mutation.run($target, ($tsx) {
        return #{{CallOriginal}};
      });
    }
    return #{{MutationListenable}}($mutation, $run).\$withPair(
      (#{{MutationTarget}} $target) => (#{{PublicParameters}}) => $run($target, #{{InvokePublicParameters}}),
    );
  }
''';
  void writeGetter(AnalyzerBuffer buffer) {
    print(
      'Generating mutation for ${executable.name} with options: $annotation',
    );

    buffer.write(
      (annotation.withPair ?? false) ? templatePair : template,
      args: <String, void Function()>{
        'PublicParameters': () => buffer.write(
          executable.endUserParameters.toCode(withParentheses: false),
        ),

        'InvokePublicParameters': () => buffer.write(
          executable.endUserParameters.toInvocationCode(withParentheses: false),
        ),

        'ResultT': () => buffer.write(executable.resultT.toCode()),
        'MutationTarget': () => buffer.write('#{{riverpod|$MutationTarget}}'),

        'MutationListenable': () => buffer.write(
          '#{{riverpod_mutations_annotation|MutationListenable}}',
        ),

        'TypedMutationListenable': () {
          final String endUserParamsInType = executable.endUserParameters
              .toCode(withParentheses: false, includeDefaults: false);
          buffer.write('''
  #{{MutationListenable}}<
    #{{ResultT}},
    Future<#{{ResultT}}> Function(#{{MutationTarget}} $target, $endUserParamsInType)
  >
''');
        },
        'MutationPairListenable': () => buffer.write(
          '#{{riverpod_mutations_annotation|MutationPairListenable}}',
        ),
        'TypedMutationPairListenable': () {
          final String endUserParamsInType = executable.endUserParameters
              .toCode(withParentheses: false, includeDefaults: false);
          buffer.write('''
  #{{MutationPairListenable}}<
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
              overrideName: (param) => param.isMutationTsx ? tsx : null,
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
        'getterDefinition': () {
          final String get = isGetter ? 'get ' : '';

          final String getterName = switch (executable) {
            MutationMethod() => executable.name.public,
            // _$ClassName_methodName
            StaticMutationMethod executable =>
              '_\$${executable.interface.name}_${executable.name.public}',
            TopLevelFunctionMutation(isPublic: false) => executable.name.public,
            TopLevelFunctionMutation(isPublic: true) =>
              throw InvalidGenerationSource(
                'Public functions cannot be used as mutations.',
                todo:
                    'Make the function private by prefixing its name with an underscore (_).',
                element: executable.element,
              ),
          };

          final String generics = methodGenerics.toGenericsCode();

          final String keyedArgs = !isGetter
              ? executable.keyedParameters.toCode()
              : '';

          buffer.write('$get$getterName$generics$keyedArgs');
        },
        'constructMutation': () => buffer.write(constructMutation),
      },
    );
  }
}
