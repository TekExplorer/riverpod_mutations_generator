import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

import 'templates/templates.dart';
import 'type_checkers.dart';
import 'types.dart';

bool classHasMutation(ClassElement notifier) =>
    notifier.methods.any(mutationTypeChecker.hasAnnotationOf);

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  @override
  Future<String?> generate(library, buildStep) async {
    final functions = library.element.topLevelFunctions
        .where(mutationTypeChecker.hasAnnotationOf)
        .map(TopLevelFunctionMutation.new);

    final classes = library.classes
        .where(
          (e) =>
              riverpodTypeChecker.hasAnnotationOf(e) ||
              e.allSupertypes.any(anyNotifierTypeChecker.isExactlyType),
        )
        .where(classHasMutation)
        .map(NotifierClass.new);
    //
    // TODO: consider allowing extensions
    if (classes.isEmpty && functions.isEmpty) return null;
    final buffer = AnalyzerBuffer.part2(
      library.element,
      header: '''
// ignore_for_file: type=lint, type=warning
''',
    );

    //
    for (final notifier in classes) {
      final template = NotifierTemplate(notifier);
      template.writeExtension(buffer);
    }

    for (final function in functions) {
      final template = MutationTemplate(function);
      template.writeGetter(buffer);
    }

    return buffer.toString();
  }
}
