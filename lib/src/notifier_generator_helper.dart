import 'package:analyzer/dart/element/element.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_mutations_generator/src/class_generator_helper.dart';

import 'util.dart';

String _if(bool conditional, String string, [String other = '']) =>
    conditional ? string : other;

class NotifierGeneratorHelper {
  static String mutationsForClass(ClassElement _class) {
    final annotatedMethods =
        _class.methods.where(mutationTypeChecker.hasAnnotationOf);

    if (annotatedMethods.isEmpty) return '';

    final List<String> extensionLines = [];
    final buffer = StringBuffer();

    for (final method in annotatedMethods) {
      final val = mutationClassesFromMethod(
        method: method,
        onAddToExtension: extensionLines.add,
      );
      buffer.writeln(val);
    }

    final _extension = extensionForNotifier(_class, extensionLines);

    return '${_extension}\n${buffer}';
  }

  static String mutationClassesFromMethod({
    required MethodElement method,
    required void Function(String) onAddToExtension,
  }) {
    return '${providerForMutation(method, onAddToExtension)}\n${ClassGeneratorHelper.mutationClasses(method)}';
  }
  //==========================================================================//

  static String extensionForNotifier(ClassElement _class, List<String> lines) {
    final buildMethod = _class.getMethod('build');
    if (buildMethod == null) {
      throw StateError('Build Method was null for $_class');
    }

    final returnType = Util.unwrapType(
        buildMethod.returnType.getDisplayString(withNullability: true));

    final isFamily = buildMethod.parameters.length > 0;
    final _riverpodAnnotatedClass = riverpodTypeChecker.annotationsOf(_class);

    final _firstAnnotation = _riverpodAnnotatedClass.first;

    final isRiverpodKeepAlive =
        _firstAnnotation.getField('keepAlive')!.toBoolValue()!;

    final maybeAutoDispose = isRiverpodKeepAlive ? '' : 'AutoDispose';

    final extensionClassName =
        _class.name.startsWith('_') ? _class.name.substring(1) : _class.name;

    if (!isFamily) {
      final _on =
          '${maybeAutoDispose}${returnType.isAsync ? 'Async' : ''}NotifierProvider<${_class.name}, ${returnType.unwrapped}>';
      return '''
extension ${extensionClassName}MutationExtension on ${_on} {
  ${lines.join('  \n')}
}
''';
    }

    final familyParamsUsage = Util.parametersUsage(buildMethod.parameters,
        prefix: 'this', nameOnly: true);
    final familyParamsDef = Util.parameterListToString(
      buildMethod.parameters,
      removeDefaults: true,
      removeRequired: true,
    );

    return '''
typedef ${extensionClassName}FamilyParams = (${familyParamsDef});
extension ${extensionClassName}MutationExtension on ${_class.name}Provider {
  ${extensionClassName}FamilyParams get _params => (${familyParamsUsage});

  ${lines.join('  \n')}
}
''';
  }

  static String providerForMutation(
    MethodElement method,
    void Function(String line) addToProviderExtension,
  ) {
    final bool mutationKeepAlive = mutationTypeChecker
        .firstAnnotationOf(method)!
        .getField('keepAlive')!
        .toBoolValue()!;

    final String maybeAutoDispose = mutationKeepAlive ? '' : '.autoDispose';

    final _class = method.enclosingElement as ClassElement;

    final _withoutUnderscore =
        _class.name.startsWith('_') ? _class.name.substring(0) : _class.name;
    final _maybeUnderscore = _if(_class.isPrivate, '_');

    final notifierProviderName =
        '${_maybeUnderscore}${_withoutUnderscore.camelCase}Provider';
    final dependencies = ', dependencies: [$notifierProviderName]';

    final buildMethod = _class.getMethod('build');
    if (buildMethod == null) {
      throw StateError('Build Method was null for $_class');
    }
    final pascalName = method.name.pascalCase;

    final annotatedParameters =
        method.parameters.where(mutationKeyTypeChecker.hasAnnotationOf);

    // final bool hasAnnotatedPositionalParameters =
    //     annotatedParameters.where((element) => element.isPositional).isNotEmpty;

    final familyParametersUsage = Util.parametersUsage(
      buildMethod.parameters,
      prefix: annotatedParameters.isNotEmpty ? r'_params.$2' : r'_params',
      // offsetPositionalBy: (hasAnnotatedPositionalParameters) ? 1 : 0,
    );

    final buildMethodParameters = Util.parameterListToString(
      buildMethod.parameters,
      removeDefaults: true,
      removeRequired: true,
    );

    final annotatedParametersString = Util.parameterListToString(
      annotatedParameters,
      removeDefaults: true,
      removeRequired: true,
    );

    final extensionName = method.name.replaceFirst(RegExp(r'^_'), '');

    // bland
    if (buildMethod.parameters.length == 0 && annotatedParameters.isEmpty) {
      addToProviderExtension(
          'Refreshable<${method.name.pascalCase}Mutation> get ${extensionName} => _${method.name}Provider;');
      return '''
final _${method.name}Provider = Provider${maybeAutoDispose}((ref) {
  final notifier = ref.watch(${notifierProviderName}.notifier);
  return ${pascalName}Mutation(
    (newState) => ref.state = newState,
    notifier.${method.name},
  );
}${dependencies});
''';
    }

    // normal family
    if (annotatedParameters.isEmpty) {
      addToProviderExtension(
          'Refreshable<${pascalName}Mutation> get ${extensionName} => _${method.name}Provider(_params);');
      return '''
// Could have extras in the future when @mutationKey gets added. for now identical to the class one.
typedef _${pascalName}FamilyParameters = (${buildMethodParameters});

final _${method.name}Provider = Provider${maybeAutoDispose}.family((ref, _${pascalName}FamilyParameters _params) {
  final notifier = ref.watch(${notifierProviderName}(${familyParametersUsage}).notifier);
  return ${method.name.pascalCase}Mutation(
    (newState) => ref.state = newState,
    notifier.${method.name},
  );
}${dependencies});
''';
    }
    final annotatedParametersUsage = Util.parametersUsage(
      annotatedParameters,
      nameOnly: true,
    );
    final _annotatedParametersString = Util.parameterListToString(
      annotatedParameters,
      removeDefaults: false,
      removeRequired: false,
      extraComma: false,
    );

    final buffer = StringBuffer();
    buffer.writeln(
        'typedef ${pascalName}FamilyParameters = (${annotatedParametersString});');

    if (buildMethod.parameters.isEmpty) {
      addToProviderExtension(
          'Refreshable<${method.name.pascalCase}Mutation> ${extensionName}($_annotatedParametersString) => _${method.name}Provider((${annotatedParametersUsage}));');

      buffer.writeAll([
        'final _${method.name}Provider = Provider${maybeAutoDispose}.family((ref, ${pascalName}FamilyParameters _params) {',
        '  final notifier = ref.watch(${notifierProviderName}.notifier);',
        '  return ${method.name.pascalCase}Mutation(',
        '    (newState) => ref.state = newState..params = _params,',
        '    notifier.${method.name},',
        '  )..params = _params;',
        '}${dependencies});',
      ]);
    } else {
      addToProviderExtension(
          'Refreshable<${method.name.pascalCase}Mutation> ${extensionName}($_annotatedParametersString) => _${method.name}Provider(((${annotatedParametersUsage}),_params));');

      final maybeApplyParams =
          // hasAnnotatedPositionalParameters ? r'..params = _params.$1' : '';
          annotatedParameters.isNotEmpty ? r'..params = _params.$1' : '';

      buffer.writeAll([
        'typedef ${pascalName}FamilyBuilderParameters = (${buildMethodParameters});',
        'typedef _${pascalName}FamilyProviderParameter = (${pascalName}FamilyParameters, ${pascalName}FamilyBuilderParameters);',
        '',
        'final _${method.name}Provider = Provider${maybeAutoDispose}.family((ref, _${pascalName}FamilyProviderParameter _params) {',
        '  final notifier = ref.watch(${notifierProviderName}(${familyParametersUsage}).notifier);',
        '  return ${method.name.pascalCase}Mutation(',
        '    (newState) => ref.state = newState${maybeApplyParams},',
        '    notifier.${method.name},',
        '  )${maybeApplyParams};',
        '}${dependencies});',
      ]);
    }

    return buffer.toString();
  }
}
