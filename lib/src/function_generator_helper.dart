import 'package:analyzer/dart/element/element.dart';
import 'package:recase/recase.dart';
import 'package:riverpod_mutations_generator/src/class_generator_helper.dart';
import 'package:riverpod_mutations_generator/src/util.dart';

class FunctionGeneratorHelper {
  static String mutationsForFunction(FunctionElement function) {
    // return '/* Hi $function */';
    // return providerForFunction(function); // null error
    // return mutationClassesFromFunction(function);
    return '''
${providerForFunction(function)}
${mutationClassesFromFunction(function)}
''';
  }

  static String mutationClassesFromFunction(FunctionElement function) {
    return ClassGeneratorHelper.mutationClasses(function);
  }

  static String providerForFunction(FunctionElement function) {
    final String accessName = function.name;
    final bool mutationKeepAlive = mutationTypeChecker
        .firstAnnotationOf(function)!
        .getField('keepAlive')!
        .toBoolValue()!;

    final String maybeAutoDispose = mutationKeepAlive ? '' : '.autoDispose';

    // switch (function) {
    //   // TODO: test if this works right
    //   FunctionElement(isStatic: true) =>
    //     '${function.enclosingElement.name!}.${function.name}',
    //   FunctionElement(isStatic: false) => function.name,
    // };
    if (!function.parameters.any(mutationKeyTypeChecker.hasAnnotationOf)) {
      return '''
final ${function.name}Provider = Provider${maybeAutoDispose}((ref) {
  return ${function.name.pascalCase}Mutation(
    (newState) => ref.state = newState,
    ${accessName},
  );
});
''';
    }
    final familyParameters = Util.parameterListToString(
      function.parameters.where(mutationKeyTypeChecker.hasAnnotationOf),
      removeDefaults: true,
      removeRequired: true,
    );

    return '''
typedef ${function.name.pascalCase}FamilyParameters = (${familyParameters});
final ${function.name}Provider = Provider${maybeAutoDispose}.family((ref, ${function.name.pascalCase}FamilyParameters params) {
  return ${function.name.pascalCase}Mutation(
    (newState) => ref.state = newState..params = params,
    ${accessName},
  )..params = params;
});
''';
  }
}
