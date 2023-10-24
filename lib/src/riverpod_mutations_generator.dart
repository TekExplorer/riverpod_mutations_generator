import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_generator/src/function_generator_helper.dart';
import 'package:riverpod_mutations_generator/src/notifier_generator_helper.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';

// const providerSuffix = 'Provider';

class RiverpodMutationsGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final riverpodAnnotatedItems = library.annotatedWith(riverpodTypeChecker);

    final classOnlyAnnotatedItems = riverpodAnnotatedItems.where((element) {
      return element.element.kind == ElementKind.CLASS;
    });
    final buffer = StringBuffer();

    final notifierElements =
        classOnlyAnnotatedItems.map((e) => e.element).cast<ClassElement>();

    for (final element in notifierElements) {
      // final res = generateForNotifier(notifier.element as ClassElement);
      final res = NotifierGeneratorHelper.mutationsForClass(element);
      buffer.writeln(res);
    }

    // experimental top-level function support
    final topLevelAnnotatedMutationItems =
        library.annotatedWith(mutationTypeChecker);

    final topLevelFunctionAnnotatedFunctions = topLevelAnnotatedMutationItems
        .map((e) => e.element)
        .where((element) => element.kind == ElementKind.FUNCTION)
        .cast<FunctionElement>();

    for (final function in topLevelFunctionAnnotatedFunctions) {
      buffer.write(FunctionGeneratorHelper.mutationsForFunction(function));
    }
    // end experimental top-level function support

    return buffer.toString();
  }
}
