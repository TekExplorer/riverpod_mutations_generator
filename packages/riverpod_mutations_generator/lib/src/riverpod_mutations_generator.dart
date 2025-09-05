import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

import 'templates/templates.dart';
import 'type_checkers.dart';
import 'types.dart';

class X extends sourceGen.GeneratorForAnnotation<Riverpod> {
  @override
  generateForAnnotatedElement(
    Element2 element,
    sourceGen.ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement2) return;
    if (!classHasMutation(element)) return;

    final buffer = AnalyzerBuffer.part2(element.library2);

    NotifierTemplate(NotifierClass(element)).defineInLibrary(buffer);

    return buffer.toString();
  }
}

bool classHasMutation(ClassElement2 notifier) =>
    notifier.methods2.any(mutationTypeChecker.hasAnnotationOf);

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  @override
  Future<String?> generate(library, buildStep) async {
    final classes = library.classes
        .where(riverpodTypeChecker.hasAnnotationOf)
        .where(classHasMutation)
        .map(NotifierClass.new);
    //
    // TODO: consider allowing extensions
    if (classes.isEmpty) return null;
    final buffer = AnalyzerBuffer.part2(library.element);

    for (final notifier in classes) {
      final template = NotifierTemplate(notifier);
      template.defineInLibrary(buffer);
    }

    return buffer.toString();
  }
}
