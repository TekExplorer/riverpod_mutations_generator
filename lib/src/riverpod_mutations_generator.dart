import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
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

    if (classes.isEmpty) return null;

    for (final notifier in classes) {
      handleNotifier(notifier, lib);
    }

    final res = lib.build().accept(DartEmitter(
          useNullSafetySyntax: true,
          orderDirectives: true,
        ));
    return res.toString();
  }

  void handleNotifier(ClassElement notifier, LibraryBuilder lib) {
    NotifierHandler(notifier: RiverpodClass(notifier), lib: lib).process();
  }
}

extension type RiverpodClass(ClassElement notifierElement)
    implements ClassElement {
  MethodElement get buildMethod =>
      notifierElement.getMethod('build') ??
      (throw StateError('Missing build method'));

  bool get isFamily => buildMethod.parameters.isNotEmpty;
  bool get isAsync => buildMethod.returnType.isAsync;

  RecordType get familyKeysType => RecordType((n) {
        for (final parameter in buildMethod.parameters) {
          n.namedFieldTypes[parameter.name] = parameter.type.toRef;
        }
      });
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
        t.symbol = notifier.name + 'Family';
        return;
      }

      t.url = 'package:riverpod/riverpod.dart';
      t.symbol =
          notifier.isAsync ? 'AsyncNotifierProvider' : 'NotifierProvider';

      t.symbol = 'AutoDispose' + t.symbol!;

      t.types.add(refer(notifier.name));
      t.types.add(refer('dynamic'));
    })
    ..methods.add(Method((m) {
      m.type = MethodType.getter;
      m.name = 'args';
      m.returns = notifier.familyKeysType;
      m.body = literalRecord(const [], {
        for (final parameter in notifier.buildMethod.parameters)
          parameter.name: parameter.type.toRef
      }).code;
    }));
}

class MethodHandler {
  MethodHandler({
    required this.lib,
    required this.extension,
    required this.mutationElement,
    required this.notifier,
  });

  factory MethodHandler.fromNotifierHandler(
    NotifierHandler notifierMaker,
    MethodElement mutationElement,
  ) {
    return MethodHandler(
      mutationElement: mutationElement,
      notifier: notifierMaker.notifier,
      extension: notifierMaker.extension,
      lib: notifierMaker.lib,
    );
  }

  final LibraryBuilder lib;
  final ExtensionBuilder extension;
  final RiverpodClass notifier;
  final MethodElement mutationElement;

  void process() {
    addMutationToExtension(
      name: mutationElement.name.public,
      returns: providerType,
      providerVariable: refer(mutationProviderName),
      mutationKeyParameters: mutKeyedParameters,
    );

    extension.fields.add(Field((f) {
      f.static = true;
      f.modifier = FieldModifier.final$;
      f.name = mutationProviderName;
      f.assignment = providerFamilyType.call([(buildClosure())]).code;
    }));
    // final providerVar = declareFinal(mutationProviderName)
    //     .assign((providerFamilyType).call([(buildClosure())]));
//
    // lib.body.add(providerVar.statement);
  }

  Expression get notifierVariable =>
      refer('${notifier.name}Provider'.camelCase);

  String get mutationProviderName => '_${mutationElement.name}${notifier.name}';

  TypeReference get providerType => TypeReference((t) {
        t.symbol = 'MutProvider';
        t.url =
            'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
        t.types.add(mutationElement.returnType.innerFutureType.toRef);
        t.types.add(mutationElement
            .type.asVoidedReturn.withoutMutationKeys.withoutMutRef.toRef);

        t.types.add(RecordType((m) {
          for (final parameter in mutKeyedParameters) {
            m.namedFieldTypes[parameter.name] = parameter.type.toRef;
          }
        }));
        t.types.add(notifier.familyKeysType);
      });

  TypeReference get providerFamilyType =>
      providerType.rebuild((f) => f.symbol = 'MutFamily');

  Expression buildClosure() {
    return Method((m) {
      m.lambda = true;
      m.requiredParameters.add(Parameter((p) => p.name = '_ref'));
      m.requiredParameters.add(Parameter((p) => p.name = '_args'));

      final ref = refer('_ref');
      final mutate = ref.property('mutate');

      final args = refer('_args');
      final notifierKeys = args.property('notifierKeys');
      final mutKeys = args.property('mutKeys');

      final Expression actualNotifier = switch (notifier.isFamily) {
        false => notifierVariable,
        true => notifierVariable.call([
            for (final param in notifier.buildMethod.parameters
                .where((param) => param.isPositional))
              notifierKeys.property(param.name)
          ], {
            for (final param in notifier.buildMethod.parameters
                .where((param) => param.isNamed))
              param.name: notifierKeys.property(param.name)
          }),
      }
          .property('notifier');

      final mutationFn = ref
          .property('read')
          .call([actualNotifier]).property(mutationElement.name);

      m.body = Method((m) {
        for (final param
            in nonKeyedParameters.where((p) => p.isRequiredPositional)) {
          if (param.name != 'ref') m.requiredParameters.add(param.toParameter);
        }
        for (final param
            in nonKeyedParameters.where((p) => !p.isRequiredPositional)) {
          m.optionalParameters.add(param.toParameter);
        }

        m.body = mutate.call([
          Method((m) {
            m.body = mutationFn.call([
              for (final param in mutationElement.parameters
                  .where((param) => param.isPositional))
                if (mutationKeyTypeChecker.hasAnnotationOf(param))
                  mutKeys.property(param.name)
                else if (param.name == 'ref')
                  ref
                else
                  refer(param.name)
            ], {
              for (final param
                  in mutationElement.parameters.where((param) => param.isNamed))
                if (mutationKeyTypeChecker.hasAnnotationOf(param))
                  param.name: mutKeys.property(param.name)
                else
                  param.name: refer(param.name)
            }).code;
          }).closure
        ]).statement;
      }).closure.code;
    }).closure;
  }

  Iterable<ParameterElement> get nonKeyedParameters {
    return mutationElement.parameters
        .whereNot(mutationKeyTypeChecker.hasAnnotationOf);
  }

  Iterable<ParameterElement> get mutKeyedParameters {
    return mutationElement.parameters
        .where(mutationKeyTypeChecker.hasAnnotationOf);
  }

  void addMutationToExtension({
    required String name,
    required TypeReference returns,
    required Reference providerVariable,
    required Iterable<ParameterElement> mutationKeyParameters,
  }) {
    final namedParameters = mutationKeyParameters
        .where((element) => element.isNamed)
        .map((e) => e.toParameter);
    final optionalPosParameters = mutationKeyParameters
        .where((element) => element.isOptionalPositional)
        .map((e) => e.toParameter);
    final requiredPosParameters = mutationKeyParameters
        .where((element) => element.isRequiredPositional)
        .map((e) => e.toParameter);

    extension.methods.add(Method((m) {
      if (mutationKeyParameters.isEmpty) m.type = MethodType.getter;
      m.name = name;
      m.returns = returns;
      m.requiredParameters.addAll(requiredPosParameters);
      m.optionalParameters.addAll(optionalPosParameters);
      m.optionalParameters.addAll(namedParameters);
      m.body = providerVariable.call([], {
        'notifierKeys': refer('args'),
        'mutKeys': literalRecord([], {
          for (final param in mutationKeyParameters)
            param.name: refer(param.name),
        }),
      }).code;
    }));
  }
}

extension on String {
  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}
