import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

import 'templates/templates.dart';
import 'type_checkers.dart';
import 'types.dart';

bool classHasMutation(ClassElement notifier) =>
    notifier.methods.any(mutationTypeChecker.hasAnnotationOf);

bool classIsNotifier(ClassElement cls) =>
    riverpodTypeChecker.hasAnnotationOf(cls) ||
    cls.allSupertypes.any(anyNotifierTypeChecker.isExactlyType);

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  @override
  Future<String?> generate(library, buildStep) async {
    final notifiers = library.classes
        .where(classIsNotifier)
        .where(classHasMutation)
        .map(NotifierClass.new);

    final staticMutations = library.allElements
        .whereType<InstanceElement>()
        .expand(
          (interface) => interface.methods
              .where((m) => m.isStatic)
              .where(mutationTypeChecker.hasAnnotationOf)
              .map(StaticMutationMethod.new),
        );

    final functions = library.element.topLevelFunctions
        .where(mutationTypeChecker.hasAnnotationOf)
        .map(TopLevelFunctionMutation.new);

    if (notifiers.isEmpty && functions.isEmpty && staticMutations.isEmpty) {
      return null;
    }

    final buffer = AnalyzerBuffer.part2(
      library.element,
      header: '''
// ignore_for_file: type=lint, type=warning
''',
    );

    //
    for (final notifier in notifiers) {
      final template = NotifierTemplate(notifier);
      template.writeExtension(buffer);
    }

    for (final staticMutation in staticMutations) {
      final template = MutationTemplate(staticMutation);
      template.writeGetter(buffer);
    }

    for (final function in functions) {
      final template = MutationTemplate(function);
      template.writeGetter(buffer);
    }

    return buffer.toString();
  }
}
