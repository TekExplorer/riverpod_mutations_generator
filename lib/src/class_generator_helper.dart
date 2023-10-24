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

    final shouldConst = annotatedParameters.isEmpty;

    return '''
typedef ${name}Signature = ${methodSignature};
typedef ${name}StateSetter = void Function(${name}Mutation newState);
  
sealed class ${name}Mutation {
  ${shouldConst ? 'const ' : ''}factory ${name}Mutation(
    ${name}StateSetter updateState,
    ${name}Signature fn,
  ) = ${name}MutationIdle._;
  
  ${shouldConst ? 'const ' : ''}${name}Mutation._(this._updateState, this._fn);
  
  final ${name}StateSetter _updateState;
  final ${name}Signature _fn;
  
  Object? get error;
  StackTrace? get stackTrace;
  
  ${annotatedParameters.isNotEmpty ? '/// This stores the @mutationKey parameters for this method. This may change.' : ''}
  ${annotatedParameters.isNotEmpty ? 'late final ${executable.name.pascalCase}FamilyParameters params;' : ''}

  ${callReturnType} $callSignature ${isAsync ? 'async' : ''}{
    ${isAsync ? '_updateState(${name}MutationLoading.from(this));' : ''}
    try {
      ${isAsync ? 'await' : ''} ${methodCaller};
      _updateState(${name}MutationSuccess.from(this));
    } catch (e, s) {
      _updateState(${name}MutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

${_class(name: name, kind: 'Idle', const_: shouldConst)}

${isAsync ? _class(name: name, kind: 'Loading', const_: shouldConst) : ''}

${_class(name: name, kind: 'Success', const_: shouldConst)}

${_failureClass(name: name, const_: shouldConst)}
''';
  }

  static String _class(
          {required String name, required String kind, bool const_ = true}) =>
      '''
final class ${name}Mutation${kind} extends ${name}Mutation {
  ${const_ ? 'const ' : ''} ${name}Mutation${kind}._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ${name}Mutation${kind}.from(${name}Mutation other) =>
      ${name}Mutation${kind}._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}
''';

  static String _failureClass({required String name, bool const_ = true}) => '''
final class ${name}MutationFailure extends ${name}Mutation {
  ${const_ ? 'const ' : ''}${name}MutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
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
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}
''';
}

extension<T> on List<T> {
  T get second => this.elementAt(1);
}

extension on ExecutableElement {
  bool get isAsync => returnType.isAsync;
}

extension on DartType {
  bool get isAsync =>
      isDartAsyncFuture || isDartAsyncFutureOr || isDartAsyncStream;
}
