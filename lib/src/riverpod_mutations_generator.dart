import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_mutations_generator/src/extensions.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  bool classHasMutation(ClassElement notifier) =>
      notifier.methods.any(mutationTypeChecker.hasAnnotationOf);

  @override
  Future<String?> generate(library, buildStep) async {
    final lib = LibraryBuilder();

    final classes = library.classes
        .where(riverpodTypeChecker.hasAnnotationOf)
        .where(classHasMutation);

    final functions = library.element.topLevelElements
        .whereType<FunctionElement>()
        .where(mutationTypeChecker.hasAnnotationOf);

    final staticFunctions = library.classes
        .map((e) => e.methods)
        .expand((e) => e)
        .where((m) => m.isStatic)
        .where(mutationTypeChecker.hasAnnotationOf);

    if (classes.isEmpty && functions.isEmpty && staticFunctions.isEmpty) {
      return null;
    }

    for (final notifier in classes) {
      handleNotifier(notifier, lib);
    }

    for (final function in functions) {
      handleFunction(function, lib);
    }

    // for (final function in staticFunctions) {
    //   handleStaticMethod(function, lib);
    // }

    final emitter = DartEmitter(
      useNullSafetySyntax: true,
      orderDirectives: true,
    );

    return lib.build().accept(emitter).toString();
  }

  void handleNotifier(ClassElement notifier, LibraryBuilder lib) {
    NotifierHandler(notifier: RiverpodClass(notifier), lib: lib).process();
  }

  void handleStaticMethod(MethodElement function, LibraryBuilder lib) {
    StaticMethodHandler(function, lib).process();
  }

  void handleFunction(FunctionElement function, LibraryBuilder lib) {
    FunctionHandler(function, lib).process();
  }
}

extension type RiverpodClass(ClassElement notifierElement)
    implements ClassElement {
  MethodElement get buildMethod =>
      notifierElement.getMethod('build') ??
      (throw StateError('Missing build method'));

  bool get isFamily => buildMethod.parameters.isNotEmpty;
  bool get isAsync => buildMethod.returnType.isAsync;
}

class NotifierHandler {
  NotifierHandler({
    required this.notifier,
    LibraryBuilder? lib,
    ExtensionBuilder? extension,
  })  : this.extension = extension ?? ExtensionBuilder(),
        this.lib = lib ?? LibraryBuilder();

  final RiverpodClass notifier;

  final LibraryBuilder lib;
  final ExtensionBuilder extension;

  void process() {
    initializeExtension();

    final mutations = notifier.methods
        .whereNot((m) => m.name == 'build')
        .where(mutationTypeChecker.hasAnnotationOf);

    for (final MethodElement mutation in mutations) {
      MethodHandler.fromNotifierHandler(this, mutation).process();
    }
    lib.body.add(extension.build());
  }

  void initializeExtension() => extension
    ..name = notifier.name + 'Mutations'
    ..on = TypeReference((t) {
      if (notifier.isFamily) {
        t.symbol = notifier.name + 'Provider';
        return;
      }

      t.url = 'package:riverpod/src/internals.dart';
      t.symbol = notifier.isAsync
          ? 'AsyncNotifierProviderBase'
          : 'NotifierProviderBase';

      t.types.add(refer(notifier.name));
      t.types.add(refer('dynamic'));
    });

  // ..methods.add(Method((m) {
  //   m.type = MethodType.getter;
  //   m.name = 'args';
  //   m.returns = notifier.familyKeysType;
  //   m.body = literalRecord(const [], {
  //     for (final parameter in notifier.buildMethod.parameters)
  //       parameter.name: refer('this').property(parameter.name)
  //   }).code;
  // }));
}

extension type ParameterElements(Iterable<ParameterElement> elements)
    implements Iterable<ParameterElement> {
  ParameterElements get named => ParameterElements(where((e) => e.isNamed));
  ParameterElements get requiredPositional =>
      ParameterElements(where((e) => e.isRequiredPositional));
  ParameterElements get optionalPositional =>
      ParameterElements(where((e) => e.isOptionalPositional));

  Iterable<Parameter> get toParameters => map((e) => e.toParameter);
}

extension on String {
  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}

class MethodHandler extends ExecutableHandler<Method> {
  MethodHandler(
    this.mutationElement,
    ExtensionBuilder extension,
  ) : super(add: extension.methods.add);

  MethodHandler.fromNotifierHandler(
    NotifierHandler notifierMaker,
    MethodElement mutationElement,
  ) : this(mutationElement, notifierMaker.extension);

  final MethodElement mutationElement;

  @override
  Method buildMutation() {
    return Method((m) {
      m.name = methodName.public;

      m.returns = returnedProviderType;

      m.lambda = true;

      if (keyedParameters.isEmpty) m.type = MethodType.getter;
      m.requiredParameters
          .addAll(keyedParameters.requiredPositional.toParameters);
      m.optionalParameters
          .addAll(keyedParameters.optionalPositional.toParameters);
      m.optionalParameters.addAll(keyedParameters.named.toParameters);

      m.body = buildInstantiation().code;
    });
  }

  @override
  Expression providerSourceReference() => refer('this');

  @override
  Expression methodKeyReference() => literalString(methodName);
}

class FunctionHandler extends ExecutableHandler<Field> {
  FunctionHandler(
    this.mutationElement,
    LibraryBuilder lib,
  ) : super(add: lib.body.add);

  final FunctionElement mutationElement;

  @override
  Field buildMutation() {
    return Field((f) {
      f.name = methodName.public + 'Mut';

      // f.type = returnedProviderType;
      f.modifier = FieldModifier.final$;
      f.assignment = buildInstantiation().code;
    });
  }

  @override
  Expression methodKeyReference() => refer(methodName);
}

class StaticMethodHandler extends ExecutableHandler<Field> {
  StaticMethodHandler(
    this.mutationElement,
    LibraryBuilder lib,
  ) : super(add: lib.body.add);

  final MethodElement mutationElement;
  String get className => mutationElement.enclosingElement3.name!;

  @override
  Field buildMutation() {
    return Field((f) {
      f.name = '${className}_${methodName.public}Mut';

      // f.type = returnedProviderType;
      f.modifier = FieldModifier.final$;
      f.assignment = buildInstantiation().code;
    });
  }

  @override
  Expression methodKeyReference() => refer(className).property(methodName);
}

sealed class ExecutableHandler<S extends Spec> {
  ExecutableHandler({required this.add});
  final void Function(S) add;

  static const method = MethodHandler.new;
  static const function = FunctionHandler.new;
  static const staticMethod = StaticMethodHandler.new;

  ExecutableElement get mutationElement;

  void process() => add(buildMutation());

  ParameterElements get nonKeyedParameters =>
      ParameterElements(mutationElement.parameters
          .whereNot(mutationKeyTypeChecker.hasAnnotationOf)
          .whereNot((e) => e.name == 'ref'));

  ParameterElements get keyedParameters => ParameterElements(
      mutationElement.parameters.where(mutationKeyTypeChecker.hasAnnotationOf));

  String get methodName => mutationElement.name;

  TypeReference get providerType => TypeReference((b) {
        b.url =
            'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
        b.symbol = 'MutProvider';
        b.types.add(mutationElement.returnType.innerFutureType.toRef);
        b.types.add(mutationElement.type
            .copyWith(parameters: nonKeyedParameters)
            .asVoidedReturn
            .toRef);
      });

  TypeReference get returnedProviderType => providerType;

  S buildMutation();

  String get refName => '_ref';
  Reference get ref => refer(refName);

  Expression buildCreateClosure() {
    return Method((b) {
      b.requiredParameters.add(Parameter((p) => p.name = refName));
      b.lambda = true;
      // (_ref) {...}
      b.body = Method((m) {
        m.lambda = true;
        m.types.addAll([
          for (final typeParam in mutationElement.typeParameters)
            TypeReference(((b) {
              b.symbol = typeParam.name;
              b.bound = typeParam.bound?.toRef;
            }))
        ]);

        for (final param in nonKeyedParameters) {
          if (param.name == 'ref') continue;
          // TODO: see the difference
          if (param.isRequiredPositional) {
            m.requiredParameters.add(param.toParameter);
          } else {
            m.optionalParameters.add(param.toParameter);
          }
        }
        m.body = ref.property('mutate').call([
          Method((inner) {
            // mutating
            inner.lambda = true;

            final method = switch (mutationElement) {
              MethodElement(isStatic: false) => ref
                  .property('read')
                  .call([refer('this.notifier')]).property(methodName),
              MethodElement(
                isStatic: true,
                :final name,
                enclosingElement3: Element(name: final className?),
              ) =>
                refer(className).property(name),
              FunctionElement() => refer(mutationElement.name),
              _ => throw StateError(
                  'Unknown mutation element type for $mutationElement'),
            };

            inner.body = method.call(
              [
                for (final param in mutationElement.parameters
                    .where((param) => param.isPositional))
                  param.name == 'ref' ? ref : refer(param.name)
              ],
              {
                for (final param in mutationElement.parameters
                    .where((param) => param.isNamed))
                  param.name: param.name == 'ref' ? ref : refer(param.name),
              },
              [
                for (final param in mutationElement.typeParameters)
                  refer(param.name),
              ],
            ).code;
          }).closure
        ]).code;
      }).closure.code;
    }).closure;
  }

  Expression buildInstantiation() {
    return providerType.call([
      buildCreateClosure(),
    ], {
      'keys': keysReference(),
      'source': providerSourceReference(),
      'method': methodKeyReference(),
    });
  }

  Expression keysReference() => literalRecord([], {
        for (final param in keyedParameters) param.name: refer(param.name),
      });

  Expression providerSourceReference() => literalNull;

  Expression methodKeyReference();
}
