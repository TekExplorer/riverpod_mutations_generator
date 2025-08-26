import 'package:analyzer/dart/element/element2.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_mutations_generator/src/utils/dart_type_extensions.dart';
import 'package:riverpod_mutations_generator/src/utils/formal_parameter_element_extensions.dart';
import 'package:riverpod_mutations_generator/src/utils/type_checkers.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

part 'executable_handler.dart';

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  bool classHasMutation(ClassElement2 notifier) =>
      notifier.methods2.any(mutationTypeChecker.hasAnnotationOf);

  @override
  Future<String?> generate(library, buildStep) async {
    final lib = LibraryBuilder();

    final classes = library.classes
        .where(riverpodTypeChecker.hasAnnotationOf)
        .where(classHasMutation);

    final functions = library.element.topLevelFunctions.where(
      mutationTypeChecker.hasAnnotationOf,
    );

    final staticFunctions = library.classes
        .map((e) => e.methods2)
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

  void handleNotifier(ClassElement2 notifier, LibraryBuilder lib) {
    NotifierHandler(notifier: RiverpodClass(notifier), lib: lib).process();
  }

  void handleStaticMethod(MethodElement2 function, LibraryBuilder lib) {
    StaticMethodHandler(function, lib).process();
  }

  void handleFunction(TopLevelFunctionElement function, LibraryBuilder lib) {
    FunctionHandler(function, lib).process();
  }
}

extension type RiverpodClass(ClassElement2 notifierElement)
    implements ClassElement2 {
  MethodElement2 get buildMethod =>
      notifierElement.getMethod2('build') ??
      (throw sourceGen.InvalidGenerationSourceError(
        'Missing build method',
        element: notifierElement,
      ));

  // bool get isFamily => buildMethod.formalParameters.isNotEmpty;
  // bool get isAsync => buildMethod.returnType.isAsync;

  String get name => name3!;
}

class NotifierHandler {
  NotifierHandler({
    required this.notifier,
    LibraryBuilder? lib,
    ExtensionBuilder? extension,
  }) : this.extension = extension ?? ExtensionBuilder(),
       this.lib = lib ?? LibraryBuilder();

  final RiverpodClass notifier;

  final LibraryBuilder lib;
  final ExtensionBuilder extension;

  void process() {
    initializeExtension();

    final mutations = notifier.methods2
        .whereNot((m) => m.name3 == 'build')
        .where(mutationTypeChecker.hasAnnotationOf);

    for (final MethodElement2 mutation in mutations) {
      MethodHandler.fromNotifierHandler(this, mutation).process();
    }
    lib.body.add(extension.build());
  }

  void initializeExtension() => extension
    ..name = notifier.name + 'Mutations'
    ..on = TypeReference((t) {
      t.symbol = '${notifier.name}Provider';

      // t.url = 'package:riverpod/src/internals.dart';
      // t.symbol = r'$ClassProvider';
      // t.types.add(refer(notifier.name));
      // t.types.add(refer('dynamic'));
      // t.types.add(refer('dynamic'));
      // t.types.add(refer('dynamic'));
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

extension type ParameterElements(Iterable<FormalParameterElement> elements)
    implements Iterable<FormalParameterElement> {
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

class MethodHandler extends ExecutableHandler {
  MethodHandler(
    this.executableElement,
    this.notifier,
    ExtensionBuilder extension,
  ) : super(add: extension.methods.add);

  MethodHandler.fromNotifierHandler(
    NotifierHandler notifierMaker,
    MethodElement2 mutationElement,
  ) : this(mutationElement, notifierMaker.notifier, notifierMaker.extension);

  final MethodElement2 executableElement;
  final RiverpodClass notifier;

  @override
  Method buildProvider() {
    return Method((m) {
      m.name = methodName.public;

      m.returns = returnedProviderType;

      m.lambda = true;

      if (keyedParameters.isEmpty) m.type = MethodType.getter;
      m.requiredParameters.addAll(
        keyedParameters.requiredPositional.toParameters,
      );
      m.optionalParameters.addAll(
        keyedParameters.optionalPositional.toParameters,
      );
      m.optionalParameters.addAll(keyedParameters.named.toParameters);

      m.body = buildInstantiation().code;
    });
  }

  @override
  Expression mutationEqualityReference() =>
      literalRecord([refer('this'), literalString(methodName)], {});
}

class FunctionHandler extends ExecutableHandler {
  FunctionHandler(this.executableElement, LibraryBuilder lib)
    : super(add: lib.body.add);

  final TopLevelFunctionElement executableElement;

  @override
  Method buildProvider() {
    return Method((f) {
      f.name = methodName.public + 'Mut';
      f.returns = returnedProviderType;
      f.type = MethodType.getter;
      f.body = buildInstantiation().code;
    });
  }

  @override
  Expression mutationEqualityReference() => refer(methodName);
}

class StaticMethodHandler extends ExecutableHandler {
  StaticMethodHandler(this.executableElement, LibraryBuilder lib)
    : super(add: lib.body.add);

  final MethodElement2 executableElement;
  String get className => executableElement.enclosingElement2!.name3!;

  @override
  Method buildProvider() {
    return Method((f) {
      f.name = '${className}_${methodName.public}Mut';
      f.returns = returnedProviderType;
      f.type = MethodType.getter;
      f.body = buildInstantiation().code;
    });
  }

  @override
  Expression mutationEqualityReference() =>
      refer(className).property(methodName);
}
