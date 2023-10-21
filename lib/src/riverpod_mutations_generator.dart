// YES, I REALIZE A LOT OF THIS SUCKS

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:collection/collection.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:source_gen/source_gen.dart';

const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);
const providerForTypeChecker = TypeChecker.fromRuntime(ProviderFor);

const mutationTypeChecker = TypeChecker.fromRuntime(Mutation);
const providerSuffix = 'Provider';

typedef SourceAndProvider = ({
  AnnotatedElement source,
  AnnotatedElement provider
});

class RiverpodMutationsGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final riverpodAnnotatedItems = library.annotatedWith(riverpodTypeChecker);

    final classOnlyNotifiers = riverpodAnnotatedItems.where((element) {
      return element.element.kind == ElementKind.CLASS;
    });
    final buffer = StringBuffer();

    for (var notifier in classOnlyNotifiers) {
      final res = generateForNotifier(notifier.element as ClassElement);
      buffer.writeln(res);
    }

    return buffer.toString();
  }

  String generateForNotifier(ClassElement notifier) {
    // if (buildMethodParameters.isNotEmpty) {
    //   print('Families are not yet supported (${notifierElement.name})');
    //   return '';
    // }

    final annotatedMethods = notifier.children
        .where(mutationTypeChecker.hasAnnotationOf)
        .cast<MethodElement>();
    if (annotatedMethods.isEmpty) {
      // we aren't needed here
      return '';
    }

    // final buildMethod = notifierElement.children
    //         .firstWhere((element) => element.displayName == 'build')
    //     as MethodElement;

    // final buildMethodParameters = buildMethod.parameters;
    final buffer = StringBuffer();
    final buildMethod = notifier.children
            .firstWhere((element) => element.displayName == 'build')
        as MethodElement;
    // int i, {String named}
    String familyParameters = buildMethod.toString().split('build').last;
    familyParameters = familyParameters.replaceAll('(', '').replaceAll(')', '');

    final buildReturn = buildMethod.returnType;
    final String unwrappedBuildReturn;
    final bool isAsync;
    if (buildReturn.isDartAsyncFuture ||
        buildReturn.isDartAsyncFutureOr ||
        buildReturn.isDartAsyncStream) {
      isAsync = true;
      unwrappedBuildReturn = buildReturn
          .toString()
          .replaceAll(RegExp('.*<'), '')
          .replaceAll(RegExp('>.*'), '');
    } else {
      isAsync = false;
      unwrappedBuildReturn = buildReturn.toString();
    }

    final extensionBuffer = StringBuffer();
    final extensionOn = switch (buildMethod.parameters) {
      [] =>
        'AutoDispose${isAsync ? 'Async' : ''}NotifierProvider<${notifier.name}, ${unwrappedBuildReturn}>',
      [...] => '${notifier.name}Provider',
    };
    extensionBuffer.writeln(
        'extension ${notifier.name}MutationExtension on $extensionOn {');
    if (buildMethod.parameters.isNotEmpty) {
      String familyParameters = buildMethod.toString().split('build').last;
      familyParameters =
          familyParameters.replaceAll('(', '').replaceAll(')', '');

      var _paramsUsage = parameterUsage(buildMethod, useThis: true);
      if (buildMethod.parameters.length == 1) {
        _paramsUsage = _paramsUsage.replaceAll(')', ',)');
      }
      extensionBuffer
          .writeln('_${notifier.name}Params get _params => ${_paramsUsage};');

      buffer.writeln(
          'typedef _${notifier.name}Params = (${removeDefaultValues(familyParameters).replaceAll('required ', '')}${buildMethod.parameters.length == 1 ? ',' : ''});');
    }
    for (final method in annotatedMethods) {
      buffer.writeln();
      buffer.writeln(generateMutationClass(
        notifier: notifier,
        method: method,
        extensionBuffer: extensionBuffer,
      ));
    }
    extensionBuffer.writeln('}');

    return '${extensionBuffer}\n${buffer}';

    // return '/*\nnotifier: $notifier\nprovider: $assumedProviderName\nmethod: ${annotatedMethods.first}\nmethod parameters: ${parameterUsage(annotatedMethods.first)}\n*/';
  }

  String parameterUsage(MethodElement element, {bool useThis = false}) {
    var parameters = element.parameters;
    var p = parameters.map((e) {
      if (e.isNamed) {
        return '${e.name}: ${useThis ? 'this.' : ''}${e.name}';
      } else {
        return '${useThis ? 'this.' : ''}${e.name}';
      }
    });
    return '(${p.join(', ')})';
  }

  String removeDefaultValues(String value) {
    return value
        .replaceAll(RegExp(' = ${1},'), ',')
        .replaceAll(RegExp(' = ${1}}'), '}');
  }

  String generateMutationClass({
    required ClassElement notifier,
    required MethodElement method,
    required StringBuffer extensionBuffer,
  }) {
    final methodName = method.name;

    // addTodo => AddTodo
    final name = methodName.pascalCase;
    final String notifierMethodSignature = method.toString();

    //
    final String methodCaller = '${methodName}${parameterUsage(method)};';

    final notifierProviderName = '${notifier.name.camelCase}$providerSuffix';

    final buildMethod = notifier.children
            .firstWhere((element) => element.displayName == 'build')
        as MethodElement;

    final buildMethodParameters = buildMethod.parameters;
    final familyParametersUsage = buildMethodParameters.mapIndexed((i, e) {
      final _name = e.name;
      if (e.isNamed) return '${_name}: params.${_name}';
      return 'params.\$${i + 1}';
    }).join(', ');
    // int i, {String named}
    String familyParameters = buildMethod.toString().split('build').last;
    familyParameters = familyParameters.replaceAll('(', '').replaceAll(')', '');

    String methodParameters = method.toString().split('${method.name}').last;

    final String callSignature = 'Future<void> call${methodParameters} async';

    final localBuffer = StringBuffer();

    if (buildMethodParameters.isNotEmpty) {
      extensionBuffer.writeln(
          'AutoDisposeProvider<${name}Mutation> get ${methodName} => _${methodName}Provider(_params);');
      localBuffer.writeln('''
final _${methodName}Provider =
    Provider.family.autoDispose((ref, _${notifier.name}Params params) {
  final notifier = ref.watch(${notifierProviderName}(${familyParametersUsage}).notifier);
  return ${name}Mutation(
    (newState) => ref.state = newState,
    notifier.${methodName},
  );
});
''');
    } else {
      extensionBuffer.writeln(
          'AutoDisposeProvider<${name}Mutation> get ${methodName} => _${methodName}Provider;');
      localBuffer.writeln('''
final _${methodName}Provider =
    Provider.autoDispose((ref) {
  final notifier = ref.watch(${notifierProviderName}.notifier);
  return ${name}Mutation(
    (newState) => ref.state = newState,
    notifier.${methodName},
  );
});
''');
    }
    return '''
${localBuffer}

typedef ${name}StateSetter = void Function(${name}Mutation newState);
typedef ${name}Signature = ${removeDefaultValues(notifierMethodSignature.replaceAll('${method.name}', 'Function'))};

sealed class ${name}Mutation {
  const factory ${name}Mutation(
    ${name}StateSetter updateState,
    ${name}Signature ${methodName},
  ) = ${name}MutationIdle._;

  const ${name}Mutation._(this._updateState, this._${methodName});

  final ${name}StateSetter _updateState;
  final ${name}Signature _${methodName};

  Object? get error;
  StackTrace? get stackTrace;

  $callSignature {
    _updateState(${name}MutationLoading.from(this));
    try {
      await _${methodCaller}
      _updateState(${name}MutationSuccess.from(this));
    } catch (e, s) {
      _updateState(${name}MutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class ${name}MutationIdle extends ${name}Mutation {
  const ${name}MutationIdle._(
    super.updateState,
    super.${methodName}, {
    this.error,
    this.stackTrace,
  }) : super._();
  factory ${name}MutationIdle.from(${name}Mutation other) =>
      ${name}MutationIdle._(
        other._updateState,
        other._${methodName},
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;
}

final class ${name}MutationLoading extends ${name}Mutation {
  const ${name}MutationLoading._(
    super.updateState,
    super.${methodName}, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ${name}MutationLoading.from(${name}Mutation other) =>
      ${name}MutationLoading._(
        other._updateState,
        other._${methodName},
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;
}

final class ${name}MutationSuccess extends ${name}Mutation {
  const ${name}MutationSuccess._(
    super.updateState,
    super.${methodName}, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ${name}MutationSuccess.from(${name}Mutation other) =>
      ${name}MutationSuccess._(
        other._updateState,
        other._${methodName},
        error: other.error,
        stackTrace: other.stackTrace,
      );
  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;
}

final class ${name}MutationFailure extends ${name}Mutation {
  const ${name}MutationFailure._(
    super.updateState,
    super.${methodName}, {
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
        other._${methodName},
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
}
