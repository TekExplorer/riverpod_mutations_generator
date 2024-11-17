// ignore_for_file: unused_import

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/src/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart' as c;
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_mutations_generator/src/class_gen.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

extension DartTypeXX on DartType {
  static TypeSystem typeSystemOf(Element element) =>
      element.library!.typeSystem;

  bool get hasQuestionMark => nullabilitySuffix == NullabilitySuffix.question;

  bool get isNullable {
    if (element case final element?) {
      return typeSystemOf(element).isNullable(this);
    }
    return map(
      Void: (type) => false,
      never: (type) => false,
      dynamic: (type) => true,
      invalid: (type) => true,
      //
      record: (type) => type.hasQuestionMark,
      function: (type) => type.hasQuestionMark,
      //
      orElse: (type) => type.hasQuestionMark,
    );
  }

  T map<T>({
    T Function(DynamicType type)? dynamic,
    T Function(InvalidType type)? invalid,
    T Function(NeverType type)? never,
    T Function(InterfaceType type)? interface,
    T Function(TypeParameterType type)? typeParameter,
    T Function(FunctionType type)? function,
    T Function(VoidType type)? Void,
    T Function(RecordType type)? record,
    required T Function(DartType type) orElse,
  }) {
    final self = this;
    return switch (self) {
      DynamicType() => (dynamic ?? orElse)(self),
      InvalidType() => (invalid ?? orElse)(self),
      NeverType() => (never ?? orElse)(self),
      InterfaceType() => (interface ?? orElse)(self),
      TypeParameterType() => (typeParameter ?? orElse)(self),
      // ParameterizedType() => (parameterized ?? orElse)(self), // InterfaceType
      FunctionType() => (function ?? orElse)(self),
      VoidType() => (Void ?? orElse)(self),
      RecordType() => (record ?? orElse)(self),
      DartType() => orElse(self),
    };
  }
}

extension DartTypeToString on DartType {
  bool get isAsync =>
      isDartAsyncFuture || isDartAsyncFutureOr || isDartAsyncStream;

  String get typeToString {
    try {
      return typeNameOf(this);
    } catch (e) {
      return this.getDisplayString();
    }
  }
}

extension CodeBuilderDartTypeX on DartType {
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

  List<DartType> get typeArguments => map(
        orElse: (type) => [],
        interface: (type) => type.typeArguments,
      );

  DartType get innerFutureType {
    if (!isAsync) return this;
    return typeArguments.firstOrNull ?? this;
  }
}

extension DynamicTypeToRef on DynamicType {
  c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'dynamic');
}

extension InvalidTypeToRef on InvalidType {
  c.TypeReference get toRef =>
      c.TypeReference((t) => t.symbol = 'dynamic/*invalid*/');
}

extension VoidTypeToRef on VoidType {
  c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'void');
}

extension NeverTypeToRef on NeverType {
  c.TypeReference get toRef => c.TypeReference((t) {
        t.isNullable = isNullable;
        t.symbol = 'Never';
      });
}

extension InterfaceTypeToRef on InterfaceType {
  c.TypeReference get toRef => c.TypeReference((t) {
        t.isNullable = isNullable;
        t.symbol = element.name;
        t.types.addAll([for (final arg in typeArguments) arg.toRef]);
      });
}

extension RecordTypeToRef on RecordType {
  c.RecordType get toRef => c.RecordType((r) {
        for (final field in positionalFields) {
          r.positionalFieldTypes.add(field.type.toRef);
        }
        for (final field in namedFields) {
          r.namedFieldTypes[field.name] = field.type.toRef;
        }
      });
}

extension FunctionTypeToRef on FunctionType {
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

extension FunctionTypeX on FunctionType {
  FunctionTypeImpl Function({
    NullabilitySuffix? nullabilitySuffix,
    Iterable<ParameterElement>? parameters,
    DartType? returnType,
    Iterable<TypeParameterElement>? typeFormals,
    InstantiatedTypeAliasElement? alias,
  }) get copyWith => ({
        Iterable<TypeParameterElement>? typeFormals,
        Iterable<ParameterElement>? parameters,
        DartType? returnType,
        NullabilitySuffix? nullabilitySuffix,
        Object? alias = const Object(),
      }) =>
          FunctionTypeImpl(
            nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
            parameters: parameters?.toList() ?? this.parameters,
            returnType: returnType ?? this.returnType,
            typeFormals: typeFormals?.toList() ?? this.typeFormals,
            alias: alias == const Object()
                ? this.alias
                : alias as InstantiatedTypeAliasElement?,
          );

  FunctionType withReturnType(DartType type) => copyWith(returnType: type);

  FunctionType get asVoidedReturn => withReturnType(VoidTypeImpl.instance);
  FunctionType get withoutMutationKeys => copyWith(
        parameters: parameters.whereNot(mutationKeyTypeChecker.hasAnnotationOf),
      );
  FunctionType get withoutMutRef =>
      copyWith(parameters: parameters.whereNot((param) {
        return param.name == 'ref' && param.isRequiredPositional;
      }));
}

extension ParameterElementToParameter on ParameterElement {
  c.Parameter get toParameter => c.Parameter((p) {
        p.name = name;
        p.type = type.toRef;
        if (defaultValueCode case final code?) p.defaultTo = c.Code(code);
        p.named = isNamed;
        p.required = isRequiredNamed;
      });
}
