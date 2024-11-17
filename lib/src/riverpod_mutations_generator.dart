// ignore_for_file: unused_import

import 'dart:async';

import 'package:analyzer/dart/element/element.dart' as e;
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart' as e;
import 'package:analyzer/src/dart/element/type.dart' as e;
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart' as c;
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_mutations_generator/src/class_gen.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

class RiverpodMutationsGenerator extends Generator {
  @override
  Future<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final lib = c.LibraryBuilder();

    final classes = library.classes
        .where(riverpodTypeChecker.hasAnnotationOf)
        .where(classHasMutation);

    if (classes.isEmpty) return null;

    for (final notifier in classes) {
      makeMutationsForClass(notifier, lib);
    }

    final emitter = c.DartEmitter(
      useNullSafetySyntax: true,
      orderDirectives: true,
    );
    final res = lib.build().accept(emitter);
    return res.toString();
  }

  bool classHasMutation(e.ClassElement clazz) =>
      clazz.methods.any(mutationTypeChecker.hasAnnotationOf);
}

void makeMutationsForClass(e.ClassElement notifier, c.LibraryBuilder lib) {
  // final s =
  //     notifier.library.libraryImports.first.uri as e.DirectiveUriWithSource;
  // s.source.uri;
  // notifier.library.libraryImports.first.prefix?.element.imports;
  // notifier.library.definingCompilationUnit.scope.lookup('thing');
  //
  final buildMethod = notifier.getMethod('build');
  if (buildMethod == null) {
    print('${notifier.name} should have a build method');
    return;
    // throw Exception('${notifier.name} should have a build method');
  }
  final isNotifierFamily = buildMethod.parameters.isNotEmpty;
  final isAsyncNotifier = buildMethod.returnType.isAsync;

  final mutations = notifier.methods
      .whereNot((m) => m.name == 'build')
      .where(mutationTypeChecker.hasAnnotationOf);

  final notifierKeysType = c.RecordType((n) {
    for (final parameter in buildMethod.parameters) {
      n.namedFieldTypes[parameter.name] = parameter.type.toRef;
    }
  });
  c.ExtensionBuilder extension = c.ExtensionBuilder()
    ..name = notifier.name + 'Mutations'
    ..on = c.TypeReference((t) {
      if (isNotifierFamily) {
        t.symbol = notifier.name + 'Family';
        return;
      }

      t.url = 'package:riverpod/riverpod.dart';
      t.symbol = isAsyncNotifier ? 'AsyncNotifierProvider' : 'NotifierProvider';

      t.symbol = 'AutoDispose' + t.symbol!;

      // if (notifier.supertype == null) {
      //   final riverpodAnnotation =
      //       riverpodTypeChecker.firstAnnotationOf(notifier);
      //   final keepAlive = riverpodAnnotation!.getField('keepAlive');
      //   if (keepAlive == null || keepAlive.toBoolValue() != true) {
      //     t.symbol = 'AutoDispose' + t.symbol!;
      //   }
      // } else if (notifier.supertype?.element.name case final String name
      //     when name.contains('AutoDispose')) {
      //   t.symbol = 'AutoDispose' + t.symbol!;
      // }
      t.types.add(c.refer(notifier.name));
      t.types.add(c.refer('dynamic'));
    })
    ..methods.add(c.Method((m) {
      m.type = c.MethodType.getter;
      m.name = 'args';
      m.returns = notifierKeysType;
      m.body = c.literalRecord(const [], {
        for (final parameter in buildMethod.parameters)
          parameter.name: parameter.type.toRef
      }).code;
    }));

  void addMutationToExtension({
    required String name,
    required c.TypeReference returns,
    required c.Reference providerRef,
    required Iterable<e.ParameterElement> mutationKeyParameters,
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
    extension.methods.add(c.Method((m) {
      if (mutationKeyParameters.isEmpty) m.type = c.MethodType.getter;
      m.name = name;
      m.returns = returns;
      m.requiredParameters.addAll(requiredPosParameters);
      m.optionalParameters.addAll(optionalPosParameters);
      m.optionalParameters.addAll(namedParameters);
      m.body = providerRef.call([], {
        'notifierKeys': c.refer('args'),
        'mutKeys': c.literalRecord([], {
          for (final param in mutationKeyParameters)
            param.name: c.refer(param.name),
        }),
      }).code;
    }));
  }

  for (final e.MethodElement mutation in mutations) {
    final variableName = '_${mutation.name}${notifier.name}';

    final mutationKeyParameters =
        mutation.parameters.where(mutationKeyTypeChecker.hasAnnotationOf);
    final providerType = c.TypeReference((t) {
      t.symbol = 'MutProvider';
      t.url =
          'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
      t.types.add(mutation.returnType.innerFutureType.toRef);
      t.types.add(mutation.type.asVoidedReturn.withoutMutationKeys.toRef);

      t.types.add(c.RecordType((m) {
        for (final parameter in mutationKeyParameters) {
          m.namedFieldTypes[parameter.name] = parameter.type.toRef;
        }
      }));
      t.types.add(notifierKeysType);
    });
    final providerFamilyType =
        providerType.rebuild((f) => f.symbol = 'MutFamily');

    final c.Expression notifierVar =
        c.refer('${notifier.name}Provider'.camelCase);

    addMutationToExtension(
      name: mutation.name.public,
      returns: providerType,
      providerRef: c.refer(variableName),
      mutationKeyParameters: mutationKeyParameters,
    );
    final createClosure = c.Method((m) {
      m.lambda = true;
      m.requiredParameters.add(c.Parameter((p) => p.name = 'ref'));
      m.requiredParameters.add(c.Parameter((p) => p.name = 'args'));

      m.body = c.Method((m) {
        final mutationParameters = mutation.parameters
            .whereNot(mutationKeyTypeChecker.hasAnnotationOf);

        for (final param
            in mutationParameters.where((p) => p.isRequiredPositional)) {
          m.requiredParameters.add(param.toParameter);
        }
        for (final param
            in mutationParameters.where((p) => !p.isRequiredPositional)) {
          m.optionalParameters.add(param.toParameter);
        }
        final ref = c.refer('ref');
        final mutate = ref.property('mutate');

        final args = c.refer('args');
        final notifierKeys = args.property('notifierKeys');
        final mutKeys = args.property('mutKeys');

        m.body = mutate.call([
          c.Method((m) {
            c.Expression madeNotifier = notifierVar;

            if (isNotifierFamily) {
              madeNotifier = notifierVar.call([
                for (final param in buildMethod.parameters
                    .where((param) => param.isPositional))
                  notifierKeys.property(param.name)
              ], {
                for (final param
                    in buildMethod.parameters.where((param) => param.isNamed))
                  param.name: notifierKeys.property(param.name)
              });
            }

            final readNotifier =
                ref.property('read').call([madeNotifier.property('notifier')]);

            m.body = readNotifier.property(mutation.name).call([
              for (final param
                  in mutation.parameters.where((param) => param.isPositional))
                if (mutationKeyTypeChecker.hasAnnotationOf(param))
                  mutKeys.property(param.name)
                else
                  c.refer(param.name)
            ], {
              for (final param
                  in mutation.parameters.where((param) => param.isNamed))
                if (mutationKeyTypeChecker.hasAnnotationOf(param))
                  param.name: mutKeys.property(param.name)
                else
                  param.name: c.refer(param.name)
            }).code;
          }).closure
        ]).statement;
      }).closure.code;
    }).closure;
    final providerVar = c
        .declareFinal(variableName)
        .assign((providerFamilyType).call([createClosure]));
    lib.body.add(providerVar.statement);
  }
  lib.body.add(extension.build());
}

extension on e.DartType {
  c.Reference get toRef {
    return map(
      Void: (type) => type.toRef,
      dynamic: (type) => type.toRef,
      invalid: (type) => type.toRef,
      never: (type) => type.toRef,
      interface: (type) => type.toRef,
      record: (type) => type.toRef,
      function: (type) => type.toRef,
      orElse: (type) => c.refer(type.typeToString),
    );
  }

  List<e.DartType> get typeArguments => map(
        orElse: (type) => [],
        interface: (type) => type.typeArguments,
      );

  e.DartType get innerFutureType {
    if (!isAsync) return this;
    return typeArguments.firstOrNull ?? this;
  }
}

extension on e.DynamicType {
  c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'dynamic');
}

extension on e.InvalidType {
  c.TypeReference get toRef =>
      c.TypeReference((t) => t.symbol = 'dynamic/*invalid*/');
}

extension on e.VoidType {
  c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'void');
}

extension on e.NeverType {
  c.TypeReference get toRef => c.TypeReference((t) {
        t.isNullable = isNullable;
        t.symbol = 'Never';
      });
}

extension on e.InterfaceType {
  c.TypeReference get toRef => c.TypeReference((t) {
        t.isNullable = isNullable;
        t.symbol = element.name;
        t.types.addAll([for (final arg in typeArguments) arg.toRef]);
      });
}

extension on e.FunctionType {
  e.FunctionTypeImpl Function({
    NullabilitySuffix? nullabilitySuffix,
    Iterable<e.ParameterElement>? parameters,
    e.DartType? returnType,
    Iterable<e.TypeParameterElement>? typeFormals,
    e.InstantiatedTypeAliasElement? alias,
  }) get copyWith => ({
        Iterable<e.TypeParameterElement>? typeFormals,
        Iterable<e.ParameterElement>? parameters,
        e.DartType? returnType,
        NullabilitySuffix? nullabilitySuffix,
        Object? alias = const Object(),
      }) =>
          e.FunctionTypeImpl(
            nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
            parameters: parameters?.toList() ?? this.parameters,
            returnType: returnType ?? this.returnType,
            typeFormals: typeFormals?.toList() ?? this.typeFormals,
            alias: alias == const Object()
                ? this.alias
                : alias as e.InstantiatedTypeAliasElement?,
          );

  e.FunctionType withReturnType(e.DartType type) => copyWith(returnType: type);

  e.FunctionType get asVoidedReturn => withReturnType(e.VoidTypeImpl.instance);
  e.FunctionType get withoutMutationKeys => copyWith(
        parameters: parameters.whereNot(mutationKeyTypeChecker.hasAnnotationOf),
      );

  c.FunctionType get toRef => c.FunctionType((f) {
        f.returnType = returnType.toRef;
        for (final param in parameters) {
          if (param.isRequiredPositional)
            f.requiredParameters.add(param.type.toRef);
          else if (param.isOptionalPositional)
            f.optionalParameters.add(param.type.toRef);
          else if (param.isRequiredNamed)
            f.namedRequiredParameters[param.name] = param.type.toRef;
          else if (param.isOptionalNamed)
            f.namedParameters[param.name] = param.type.toRef;
        }
      });
}

extension on e.RecordType {
  c.RecordType get toRef => c.RecordType((r) {
        for (final field in positionalFields) {
          r.positionalFieldTypes.add(field.type.toRef);
        }
        for (final field in namedFields) {
          r.namedFieldTypes[field.name] = field.type.toRef;
        }
      });
}

extension on e.ParameterElement {
  c.Parameter get toParameter => c.Parameter((p) {
        p.name = name;
        p.type = type.toRef;
        if (defaultValueCode case final code?) p.defaultTo = c.Code(code);
        p.named = isNamed;
        p.required = isRequiredNamed;
      });
}

extension on String {
  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}
