// import 'package:analyzer/dart/element/type.dart';
// import 'package:analyzer/dart/element/type_visitor.dart';

// class TypeMapper<T> extends TypeVisitor<T> {
//   TypeMapper({
//     required T Function(DynamicType type) visitDynamicType,
//     required T Function(FunctionType type) visitFunctionType,
//     required T Function(InterfaceType type) visitInterfaceType,
//     required T Function(InvalidType type) visitInvalidType,
//     required T Function(NeverType type) visitNeverType,
//     required T Function(RecordType type) visitRecordType,
//     required T Function(TypeParameterType type) visitTypeParameterType,
//     required T Function(VoidType type) visitVoidType,
//   }) : _visitDynamicType = visitDynamicType,
//        _visitFunctionType = visitFunctionType,
//        _visitInterfaceType = visitInterfaceType,
//        _visitInvalidType = visitInvalidType,
//        _visitNeverType = visitNeverType,
//        _visitRecordType = visitRecordType,
//        _visitTypeParameterType = visitTypeParameterType,
//        _visitVoidType = visitVoidType;

//   static TypeMapper<T?> optional<T>({
//     T Function(FunctionType type)? visitFunctionType,
//     T Function(InterfaceType type)? visitInterfaceType,
//     T Function(RecordType type)? visitRecordType,
//     T Function(TypeParameterType type)? visitTypeParameterType,
//     T Function(NeverType type)? visitNeverType,
//     T Function(VoidType type)? visitVoidType,
//     T Function(DynamicType type)? visitDynamicType,
//     T Function(InvalidType type)? visitInvalidType,
//   }) {
//     return TypeMapper(
//       visitDynamicType: visitDynamicType ?? _returnNull,
//       visitFunctionType: visitFunctionType ?? _returnNull,
//       visitInterfaceType: visitInterfaceType ?? _returnNull,
//       visitInvalidType: visitInvalidType ?? _returnNull,
//       visitNeverType: visitNeverType ?? _returnNull,
//       visitRecordType: visitRecordType ?? _returnNull,
//       visitTypeParameterType: visitTypeParameterType ?? _returnNull,
//       visitVoidType: visitVoidType ?? _returnNull,
//     );
//   }

//   static Null _returnNull([dynamic _]) => null;

//   final T Function(DynamicType type) _visitDynamicType;
//   final T Function(FunctionType type) _visitFunctionType;
//   final T Function(InterfaceType type) _visitInterfaceType;
//   final T Function(InvalidType type) _visitInvalidType;
//   final T Function(NeverType type) _visitNeverType;
//   final T Function(RecordType type) _visitRecordType;
//   final T Function(TypeParameterType type) _visitTypeParameterType;
//   final T Function(VoidType type) _visitVoidType;

//   @override
//   T visitDynamicType(DynamicType type) => _visitDynamicType(type);

//   @override
//   T visitFunctionType(FunctionType type) => _visitFunctionType(type);

//   @override
//   T visitInterfaceType(InterfaceType type) => _visitInterfaceType(type);

//   @override
//   T visitInvalidType(InvalidType type) => _visitInvalidType(type);

//   @override
//   T visitNeverType(NeverType type) => _visitNeverType(type);

//   @override
//   T visitRecordType(RecordType type) => _visitRecordType(type);

//   @override
//   T visitTypeParameterType(TypeParameterType type) =>
//       _visitTypeParameterType(type);

//   @override
//   T visitVoidType(VoidType type) => _visitVoidType(type);
// }
