import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:analyzer/src/dart/element/type.dart';
import 'package:code_builder/code_builder.dart' as c;
import 'package:collection/collection.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

extension DartTypeX on DartType {
  static TypeSystem typeSystemOf(Element element) =>
      element.library!.typeSystem;

  bool get hasQuestionMark => nullabilitySuffix == NullabilitySuffix.question;

  bool get isNullable => isNullableType;
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
    return accept(TypeMapper(
      visitDynamicType: (type) => DynamicTypeToRef(type).toRef,
      visitFunctionType: (type) => FunctionTypeToRef(type).toRef,
      visitInterfaceType: (type) => InterfaceTypeToRef(type).toRef,
      visitInvalidType: (type) => InvalidTypeToRef(type).toRef,
      visitNeverType: (type) => NeverTypeToRef(type).toRef,
      visitRecordType: (type) => RecordTypeToRef(type).toRef,
      visitTypeParameterType: (type) => c.refer(type.element.name),
      visitVoidType: (type) => VoidTypeToRef(type).toRef,
    ));
  }

  List<DartType> get typeArguments => switch (this) {
        ParameterizedType type => type.typeArguments,
        FunctionType type => type.typeArguments,
        _ => [],
      };

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

class TypeMapper<T> extends TypeVisitor<T> {
  TypeMapper({
    required T Function(DynamicType type) visitDynamicType,
    required T Function(FunctionType type) visitFunctionType,
    required T Function(InterfaceType type) visitInterfaceType,
    required T Function(InvalidType type) visitInvalidType,
    required T Function(NeverType type) visitNeverType,
    required T Function(RecordType type) visitRecordType,
    required T Function(TypeParameterType type) visitTypeParameterType,
    required T Function(VoidType type) visitVoidType,
  })  : _visitDynamicType = visitDynamicType,
        _visitFunctionType = visitFunctionType,
        _visitInterfaceType = visitInterfaceType,
        _visitInvalidType = visitInvalidType,
        _visitNeverType = visitNeverType,
        _visitRecordType = visitRecordType,
        _visitTypeParameterType = visitTypeParameterType,
        _visitVoidType = visitVoidType;

  static TypeMapper<T?> optional<T>({
    T Function(DynamicType type)? visitDynamicType,
    T Function(FunctionType type)? visitFunctionType,
    T Function(InterfaceType type)? visitInterfaceType,
    T Function(InvalidType type)? visitInvalidType,
    T Function(NeverType type)? visitNeverType,
    T Function(RecordType type)? visitRecordType,
    T Function(TypeParameterType type)? visitTypeParameterType,
    T Function(VoidType type)? visitVoidType,
  }) {
    return TypeMapper(
      visitDynamicType: visitDynamicType ?? (_) => null,
      visitFunctionType: visitFunctionType ?? (_) => null,
      visitInterfaceType: visitInterfaceType ?? (_) => null,
      visitInvalidType: visitInvalidType ?? (_) => null,
      visitNeverType: visitNeverType ?? (_) => null,
      visitRecordType: visitRecordType ?? (_) => null,
      visitTypeParameterType: visitTypeParameterType ?? (_) => null,
      visitVoidType: visitVoidType ?? (_) => null,
    );
  }

  final T Function(DynamicType type) _visitDynamicType;
  final T Function(FunctionType type) _visitFunctionType;
  final T Function(InterfaceType type) _visitInterfaceType;
  final T Function(InvalidType type) _visitInvalidType;
  final T Function(NeverType type) _visitNeverType;
  final T Function(RecordType type) _visitRecordType;
  final T Function(TypeParameterType type) _visitTypeParameterType;
  final T Function(VoidType type) _visitVoidType;

  @override
  T visitDynamicType(DynamicType type) => _visitDynamicType(type);

  @override
  T visitFunctionType(FunctionType type) => _visitFunctionType(type);

  @override
  T visitInterfaceType(InterfaceType type) => _visitInterfaceType(type);

  @override
  T visitInvalidType(InvalidType type) => _visitInvalidType(type);

  @override
  T visitNeverType(NeverType type) => _visitNeverType(type);

  @override
  T visitRecordType(RecordType type) => _visitRecordType(type);

  @override
  T visitTypeParameterType(TypeParameterType type) =>
      _visitTypeParameterType(type);

  @override
  T visitVoidType(VoidType type) => _visitVoidType(type);
}
