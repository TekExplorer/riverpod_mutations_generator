import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart'
    show FunctionType, DartType, InterfaceType;
import 'package:riverpod_mutations_generator/src/type_checkers.dart';
import 'package:riverpod_mutations_generator/src/utils/dart_type_extensions.dart';

final class NotifierClass {
  NotifierClass(this.element);
  final ClassElement element;

  String get name => element.displayName;

  DartType get valueType => buildMethod.returnType.innerFutureType;

  InterfaceType get thisType => element.thisType;

  List<TypeParameterElement> get typeParameters => element.typeParameters;

  MethodElement get buildMethod => element.getMethod('build')!;
  bool get isAsync => buildMethod.returnType.isAsync;

  Iterable<MutationMethod> get mutations => element.methods
      .where((m) => m.isStatic == false)
      .where(mutationTypeChecker.hasAnnotationOf)
      .map(MutationMethod.new);
}

final class MutationMethod extends MutationExecutable {
  MutationMethod(this.element);
  final MethodElement element;

  NotifierClass get notifier =>
      NotifierClass(element.enclosingElement as ClassElement);
}

final class MutationFunction extends MutationExecutable {
  MutationFunction(this.element);
  final TopLevelFunctionElement element;
}

final class TopLevelFunctionMutation extends MutationFunction {
  TopLevelFunctionMutation(TopLevelFunctionElement element) : super(element);
}

sealed class MutationExecutable {
  ExecutableElement get element;

  String get name => element.displayName;

  FunctionType get type => element.type;
  DartType get returnType => type.returnType;

  /// The T of a FutureOr<T>
  DartType get resultT => returnType.innerFutureType;

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
  bool get isMutationRef => mutationTransactionTypeChecker.isExactlyType(type);
}
