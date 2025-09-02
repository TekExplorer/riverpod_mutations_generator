import 'package:analyzer/dart/element/element2.dart';
import 'package:source_gen/source_gen.dart' as sourceGen;

import 'templates.dart';
import 'type_checkers.dart';
import 'types.dart';

class RiverpodMutationsGenerator extends sourceGen.Generator {
  const RiverpodMutationsGenerator();

  bool classHasMutation(ClassElement2 notifier) =>
      notifier.methods2.any(mutationTypeChecker.hasAnnotationOf);

  @override
  Future<String?> generate(library, buildStep) async {
    final classes = library.classes
        .where(riverpodTypeChecker.hasAnnotationOf)
        .where(classHasMutation)
        .map(NotifierClass.new);

    // TODO: consider allowing extensions

    if (classes.isEmpty) return null;

    final buffer = MutationsGeneratorBuffer.part2(library.element);
    for (final notifier in classes) buffer.writeClassElement(notifier);

    return buffer.toString();
  }
}
