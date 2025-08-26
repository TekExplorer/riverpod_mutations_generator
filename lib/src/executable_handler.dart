part of 'riverpod_mutations_generator.dart';

sealed class ExecutableHandler {
  ExecutableHandler({required this.add});
  final void Function(Method method) add;

  static const method = MethodHandler.new;
  static const function = FunctionHandler.new;
  static const staticMethod = StaticMethodHandler.new;

  ExecutableElement2 get executableElement;

  void process() => add(buildProvider());

  ParameterElements get nonKeyedParameters => ParameterElements(
    executableElement.formalParameters
        .whereNot(mutationKeyTypeChecker.hasAnnotationOf)
        .whereNot((e) => e.name3 == 'ref'),
  );

  ParameterElements get keyedParameters => ParameterElements(
    executableElement.formalParameters.where(
      mutationKeyTypeChecker.hasAnnotationOf,
    ),
  );

  String get methodName => executableElement.name3!;

  TypeReference get providerType => TypeReference((b) {
    b.url = 'package:riverpod/riverpod.dart';
    b.symbol = 'Provider';
    b.types.add(
      RecordType((r) {
        r.positionalFieldTypes.add(
          TypeReference((m) {
            m.url = 'package:riverpod/experimental/mutation.dart';
            m.symbol = 'MutationState';
            m.types.add(executableElement.returnType.innerFutureType.toRef);
          }),
        );
        r.positionalFieldTypes.add(
          executableElement.type
              .copyWith(formalParameters: nonKeyedParameters)
              .toRef,
        );
      }),
    );
  });

  TypeReference get returnedProviderType => providerType;

  Method buildProvider();

  String get refName => 'ref';
  Reference get ref => refer(refName);

  R when<R>({
    required R Function(FunctionHandler handler) function,
    required R Function(MethodHandler handler) method,
    required R Function(StaticMethodHandler handler) staticMethod,
  }) {
    return switch (this) {
      MethodHandler handler => method(handler),
      FunctionHandler handler => function(handler),
      StaticMethodHandler handler => staticMethod(handler),
    };
  }

  Expression buildCreateClosure() {
    return Method((b) {
      b.requiredParameters.add(Parameter((p) => p.name = refName));
      b.lambda = false;
      b.body = Block.of([
        declareFinal('mutation').assign(mutationInstantiation).statement,
        literalRecord([
          ref.property('watch').call([refer('mutation')]),
          buildRunClosure(refer('mutation')).closure,
        ], {}).returned.statement,
      ]);
    }).closure;
  }

  Method buildRunClosure(Expression mutation) {
    return Method((m) {
      m.lambda = true;
      m.types.addAll([
        for (final typeParam in executableElement.typeParameters2)
          TypeReference(((b) {
            b.symbol = typeParam.name3;
            b.bound = typeParam.bound?.toRef;
          })),
      ]);

      for (final param in nonKeyedParameters) {
        if (param.name3 == 'ref') continue;
        // TODO: see the difference
        if (param.isRequiredPositional) {
          m.requiredParameters.add(param.toParameter);
        } else {
          m.optionalParameters.add(param.toParameter);
        }
      }

      //
      m.body = mutation.property('run').call([
        ref,
        Method((inner) {
          // mutating
          inner.lambda = true;
          inner.requiredParameters.add(Parameter((p) => p.name = 'ref'));

          final method = when(
            function: (handler) => refer(handler.methodName),
            staticMethod: (handler) =>
                refer(handler.className).property(handler.methodName),
            method: (handler) => ref
                .property('get')
                .call([refer('this.notifier')])
                .property(handler.methodName),
          );

          inner.body = method.call(
            [
              for (final param in executableElement.formalParameters.where(
                (param) => param.isPositional,
              ))
                param.name3 == 'ref' ? ref : refer(param.name3!),
            ],
            {
              for (final param in executableElement.formalParameters.where(
                (param) => param.isNamed,
              ))
                param.name3!: param.name3 == 'ref' ? ref : refer(param.name3!),
            },
            [
              for (final param in executableElement.typeParameters2)
                refer(param.name3!),
            ],
          ).code;
        }).closure,
      ]).code;
    });
  }

  Expression buildInstantiation() {
    return providerType.call([buildCreateClosure()]);
  }

  Expression? keysReference() {
    if (keyedParameters.isEmpty) return null;
    return literalRecord([], {
      for (final param in keyedParameters) param.name3!: refer(param.name3!),
    });
  }

  Expression mutationEqualityReference();

  TypeReference get mutationType => TypeReference((b) {
    b.symbol = 'Mutation';
    b.types.add(executableElement.returnType.innerFutureType.toRef);
  });

  Expression get mutationInstantiation {
    Expression mutation = mutationType.call([]);
    mutation = mutation.call([mutationEqualityReference()]);
    if (keysReference() case final keys?) mutation = mutation.call([keys]);
    return mutation;
  }
}
