import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/src/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:source_helper/source_helper.dart';

extension DartTypeX on DartType {
  static TypeSystem typeSystemOf(Element element) =>
      element.library!.typeSystem;

  bool get hasQuestionMark => nullabilitySuffix == NullabilitySuffix.question;

  bool get isNullable => isNullableType;
}

extension DartTypeHelpers on DartType {
  bool get isAsync =>
      isDartAsyncFuture || isDartAsyncFutureOr || isDartAsyncStream;

  List<DartType> get typeArguments => switch (this) {
    ParameterizedType type => type.typeArguments,
    FunctionType type => type.typeArguments,
    _ => [],
  };

  DartType get innerFutureType {
    if (!isAsync) return this;
    return typeArguments.firstOrNull ?? this;
  }

  // String get typeToString {
  //   try {
  //     return typeNameOf(this);
  //   } catch (e) {
  //     return this.getDisplayString();
  //   }
  // }
}

// extension CodeBuilderDartTypeX on DartType {
//   c.Reference get toRef => map(
//     visitDynamicType: (type) => DynamicTypeToRef(type).toRef,
//     visitFunctionType: (type) => FunctionTypeToRef(type).toRef,
//     visitInterfaceType: (type) => InterfaceTypeToRef(type).toRef,
//     visitInvalidType: (type) => InvalidTypeToRef(type).toRef,
//     visitNeverType: (type) => NeverTypeToRef(type).toRef,
//     visitRecordType: (type) => RecordTypeToRef(type).toRef,
//     visitTypeParameterType: (type) => c.refer(type.element3.displayName),
//     visitVoidType: (type) => VoidTypeToRef(type).toRef,
//   );

//   c.Reference? get aliasToRef {
//     final type = this;

//     final aliasElement = type.alias?.element2;
//     // if (aliasElement != null) return aliasElement.name;
//     if (aliasElement != null) {
//       return c.TypeReference((t) {
//         t.isNullable = type.isNullable;
//         t.symbol = aliasElement.displayName;
//       });
//     }
//     return null;
//   }

//   R map<R>({
//     required R Function(DynamicType type) visitDynamicType,
//     required R Function(FunctionType type) visitFunctionType,
//     required R Function(InterfaceType type) visitInterfaceType,
//     required R Function(InvalidType type) visitInvalidType,
//     required R Function(NeverType type) visitNeverType,
//     required R Function(RecordType type) visitRecordType,
//     required R Function(TypeParameterType type) visitTypeParameterType,
//     required R Function(VoidType type) visitVoidType,
//   }) {
//     return accept(
//       TypeMapper<R>(
//         visitDynamicType: visitDynamicType,
//         visitFunctionType: visitFunctionType,
//         visitInterfaceType: visitInterfaceType,
//         visitInvalidType: visitInvalidType,
//         visitNeverType: visitNeverType,
//         visitRecordType: visitRecordType,
//         visitTypeParameterType: visitTypeParameterType,
//         visitVoidType: visitVoidType,
//       ),
//     );
//   }

//   R? maybeMap<R>({
//     R Function(DynamicType type)? visitDynamicType,
//     R Function(FunctionType type)? visitFunctionType,
//     R Function(InterfaceType type)? visitInterfaceType,
//     R Function(InvalidType type)? visitInvalidType,
//     R Function(NeverType type)? visitNeverType,
//     R Function(RecordType type)? visitRecordType,
//     R Function(TypeParameterType type)? visitTypeParameterType,
//     R Function(VoidType type)? visitVoidType,
//   }) {
//     return accept(
//       TypeMapper.optional<R>(
//         visitDynamicType: visitDynamicType,
//         visitFunctionType: visitFunctionType,
//         visitInterfaceType: visitInterfaceType,
//         visitInvalidType: visitInvalidType,
//         visitNeverType: visitNeverType,
//         visitRecordType: visitRecordType,
//         visitTypeParameterType: visitTypeParameterType,
//         visitVoidType: visitVoidType,
//       ),
//     );
//   }

// extension DynamicTypeToRef on DynamicType {
//   c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'dynamic');
// }

// extension InvalidTypeToRef on InvalidType {
//   c.TypeReference get toRef =>
//       c.TypeReference((t) => t.symbol = 'dynamic/*invalid*/');
// }

// extension VoidTypeToRef on VoidType {
//   c.TypeReference get toRef => c.TypeReference((t) => t.symbol = 'void');
// }

// extension NeverTypeToRef on NeverType {
//   c.TypeReference get toRef => c.TypeReference((t) {
//     t.isNullable = isNullable;
//     t.symbol = 'Never';
//   });
// }

// extension InterfaceTypeToRef on InterfaceType {
//   c.TypeReference get toRef => c.TypeReference((t) {
//     t.isNullable = isNullable;
//     t.symbol = element3.displayName;
//     t.types.addAll([for (final arg in typeArguments) arg.toRef]);
//   });
// }

// extension RecordTypeToRef on RecordType {
//   c.RecordType get toRef => c.RecordType((r) {
//     for (final field in positionalFields) {
//       r.positionalFieldTypes.add(field.type.toRef);
//     }
//     for (final field in namedFields) {
//       r.namedFieldTypes[field.name] = field.type.toRef;
//     }
//   });
// }

// extension FunctionTypeToRef on FunctionType {
//   c.FunctionType get toRef => c.FunctionType((f) {
//     f.returnType = returnType.toRef;
//     for (final param in formalParameters) {
//       if (param.isRequiredPositional)
//         f.requiredParameters.add(param.type.toRef);
//       else if (param.isOptionalPositional)
//         f.optionalParameters.add(param.type.toRef);
//       else if (param.isRequiredNamed)
//         f.namedRequiredParameters[param.displayName] = param.type.toRef;
//       else if (param.isOptionalNamed)
//         f.namedParameters[param.displayName] = param.type.toRef;
//     }
//   });
// }

extension FunctionTypeX on FunctionType {
  FunctionTypeImpl Function({
    NullabilitySuffix? nullabilitySuffix,
    Iterable<FormalParameterElement>? formalParameters,
    DartType? returnType,
    Iterable<TypeParameterElement>? typeParameters,
    InstantiatedTypeAliasElement? alias,
  })
  get copyWith =>
      ({
        Iterable<TypeParameterElement>? typeParameters,
        Iterable<FormalParameterElement>? formalParameters,
        DartType? returnType,
        NullabilitySuffix? nullabilitySuffix,
        Object? alias = const Object(),
      }) => FunctionTypeImpl.v2(
        nullabilitySuffix: nullabilitySuffix ?? this.nullabilitySuffix,
        returnType: (returnType ?? this.returnType) as TypeImpl,
        alias:
            (alias == const Object() ? this.alias : alias)
                as InstantiatedTypeAliasElementImpl?,
        typeParameters: (typeParameters ?? this.typeParameters).castList(),
        formalParameters: (formalParameters ?? this.formalParameters)
            .castList(),
      );

  // FunctionType withReturnType(DartType type) => copyWith(returnType: type);

  // FunctionType get asVoidedReturn => withReturnType(VoidTypeImpl.instance);
  // FunctionType get withoutMutationKeys => copyWith(
  //   formalParameters: formalParameters.whereNot(
  //     mutationKeyTypeChecker.hasAnnotationOf,
  //   ),
  // );
  // FunctionType get withoutMutationRef => copyWith(
  //   formalParameters: formalParameters.whereNot((param) {
  //     return param.displayName == 'ref' && param.isRequiredPositional;
  //   }),
  // );
}

extension on Iterable {
  List<R> castList<R>() => cast<R>().toList();
}
