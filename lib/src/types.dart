import 'package:analyzer/dart/element/element2.dart'
    show ClassElement2, FormalParameterElement, MethodElement2;
import 'package:analyzer/dart/element/type.dart' show FunctionType, DartType;
import 'package:riverpod_mutations_generator/src/type_checkers.dart';
import 'package:riverpod_mutations_generator/src/utils/dart_type_extensions.dart';

extension type NotifierClass(ClassElement2 element) {
  String get name => element.name3!;

  MethodElement2 get buildMethod => element.getMethod2('build')!;
  bool get isAsync => buildMethod.returnType.isAsync;

  Iterable<MutationMethod> get mutations => element.methods2
      .where((m) => m.isStatic == false)
      .where(mutationTypeChecker.hasAnnotationOf)
      .map(MutationMethod.new);
}

extension type MutationMethod(MethodElement2 element) {
  String get name => element.name3!;

  FunctionType get type => element.type;
  DartType get returnType => type.returnType;

  /// The T of a FutureOr<T>
  DartType get resultT => returnType.innerFutureType;

  NotifierClass get notifier =>
      NotifierClass(element.enclosingElement2 as ClassElement2);

  bool get isPublic => element.isPublic;
  bool get isPrivate => element.isPrivate;

  bool get wantsMutationRef =>
      element.formalParameters.any((m) => m.isMutationRef);

  List<FormalParameterElement> get formalParameters => element.formalParameters;

  Iterable<FormalParameterElement> get keyedParameters =>
      formalParameters.where(mutationKeyTypeChecker.hasAnnotationOf);

  /// Parameters that are neither keyed, nor a MutationRef
  Iterable<FormalParameterElement> get endUserParameters =>
      formalParameters.where(
        (p) => !mutationKeyTypeChecker.hasAnnotationOf(p) && !p.isMutationRef,
      );
}

extension on FormalParameterElement {
  bool get isMutationRef => mutationRefTypeChecker.isExactlyType(type);
}
