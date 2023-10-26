import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_mutations_generator/src/util.dart';

class ClassGeneratorHelper {
  static String mutationClasses(ExecutableElement executable) {
    final name = executable.name.pascalCase;

    final isAsync = executable.isAsync;

    final callReturnType = isAsync ? 'Future<void>' : 'void';
    // if (unwrappedReturnType != 'void') {
    //   // has a return type:
    // }

    final typedParameters = Util.parameterListToString(
      executable.parameters,
      removeDefaults: true,
      removeRequired: false,
      extraComma: false,
    );

    final annotatedParameters =
        executable.parameters.where(mutationKeyTypeChecker.hasAnnotationOf);

    final unAnnotatedParameters =
        executable.parameters.whereNot(annotatedParameters.contains);

    final rawTypedParameters = Util.parameterListToString(
      unAnnotatedParameters,
      extraComma: false,
    );

// full methodSignature as a type. cannot have default values
    final methodSignature =
        '${executable.returnType} Function(${typedParameters})';

    // support value returns
    final _methodReturnType = Util.unwrapType(executable.returnType.toString());
    final returnValueType = _methodReturnType.unwrapped;
    final returnsValue = returnValueType != 'void';

    final _caller = executable.parameters.map((element) {
      final name = element.name;
      final shouldUseFamilyParams =
          mutationKeyTypeChecker.hasAnnotationOf(element);

      if (!shouldUseFamilyParams) {
        return element.isNamed ? '${name}: ${name}' : '${name}';
      }
      if (element.isNamed) {
        return '$name: params.$name';
      }

      final int index = annotatedParameters.toList().indexOf(element) + 1;
      return 'params.\$$index';
    });

    final callSignature = 'call(${rawTypedParameters})';
    final methodCaller = '_fn(${_caller.join(', ')})';

    final mutationBase = isAsync ? 'AsyncMutation' : 'SyncMutation';

    return '''
typedef ${name}Signature = ${methodSignature};
typedef ${name}StateSetter = void Function(${name}Mutation newState);
  
sealed class ${name}Mutation with ${mutationBase} {
  factory ${name}Mutation(
    ${name}StateSetter updateState,
    ${name}Signature fn,
    ${returnsValue ? '${returnValueType} result,' : ''}
  ) = ${name}MutationIdle._;
  
  ${name}Mutation._(this._updateState, this._fn, ${returnsValue ? 'this.result' : ''});
  
  final ${name}StateSetter _updateState;
  final ${name}Signature _fn;
  
  Object? get error;
  StackTrace? get stackTrace;
  
  ${annotatedParameters.isNotEmpty ? '/// This stores the @mutationKey parameters for this method. This may change.' : ''}
  ${annotatedParameters.isNotEmpty ? 'late final ${executable.name.pascalCase}FamilyParameters params;' : ''}

  ${returnsValue ? '${returnValueType}? get result;' : ''}

  ${callReturnType} $callSignature ${isAsync ? 'async' : ''}{
    ${isAsync ? '_updateState(${name}MutationLoading.from(this));' : ''}
    try {
      ${returnsValue ? 'final res = ' : ''}${isAsync ? 'await' : ''} ${methodCaller};
      _updateState(${name}MutationSuccess.from(this${returnsValue ? ', res' : ''}));
    } catch (e, s) {
      _updateState(${name}MutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

${_class(name: name, kind: 'Idle', returnValueType: returnsValue ? returnValueType : null)}

${isAsync ? _class(name: name, kind: 'Loading', returnValueType: returnsValue ? returnValueType : null) : ''}

${_successClass(name: name, returnValueType: returnsValue ? returnValueType : null)}

${_failureClass(name: name, returnValueType: returnsValue ? returnValueType : null)}
''';
  }

  static String _class({
    required String name,
    required String kind,
    required String? returnValueType,
  }) =>
      '''
  final class ${name}Mutation${kind} extends ${name}Mutation with Mutation${kind} {
  ${name}Mutation${kind}._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
    ${returnValueType != null ? 'this.result,' : ''}
  }) : super._();
  
  factory ${name}Mutation${kind}.from(${name}Mutation other) =>
      ${name}Mutation${kind}._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
        ${returnValueType != null ? 'result: other.result,' : ''}
      );
  
  @override
  final Object? error;
  
  @override
  final StackTrace? stackTrace;
  
  ${returnValueType != null ? 'final ${'${returnValueType}?'.replaceAll('??', '?')} result;' : ''}
}
''';

  static String _successClass({
    required String name,
    required String? returnValueType,
  }) =>
      '''
  final class ${name}MutationSuccess extends ${name}Mutation with MutationSuccess {
  ${name}MutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
    ${returnValueType != null ? 'required this.result,' : ''}
  }) : super._();
  
  factory ${name}MutationSuccess.from(${name}Mutation other${returnValueType != null ? ', ${returnValueType} result' : ''}) =>
      ${name}MutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
        ${returnValueType != null ? 'result: result,' : ''}
      );
  
  @override
  final Object? error;
  
  @override
  final StackTrace? stackTrace;
  
  ${returnValueType != null ? 'final ${returnValueType} result;' : ''}
}
''';

  static String _failureClass({
    required String name,
    String? returnValueType,
  }) =>
      '''
final class ${name}MutationFailure extends ${name}Mutation with MutationFailure {
  ${name}MutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
    ${returnValueType != null ? 'this.result,' : ''}
  }) : super._();

  factory ${name}MutationFailure.from(
    ${name}Mutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      ${name}MutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
        ${returnValueType != null ? 'result: other.result,' : ''}
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  ${returnValueType != null ? 'final ${'${returnValueType}?'.replaceAll('??', '?')} result;' : ''}
}
''';
}

// extension<T> on List<T> {
//   T get second => this.elementAt(1);
// }

extension on ExecutableElement {
  bool get isAsync => returnType.isAsync;
}

extension on DartType {
  bool get isAsync =>
      isDartAsyncFuture || isDartAsyncFutureOr || isDartAsyncStream;
}
