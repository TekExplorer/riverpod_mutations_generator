import 'package:build/build.dart';
import 'package:build_test/build_test.dart' as b;
import 'package:riverpod_mutations_generator/src/utils/type_checker.dart';
import 'package:test/test.dart';

void main() {
  final checker = TypeChecker.typeNamed('Annotation', inPackage: 'annotation');
  final checker2 = TypeChecker.fromUrl(
    'package:annotation/annotation.dart#Annotation',
  );
  test('TypeChecker creates a checker for Annotation', () async {
    await b.resolveSources(
      {
        'a|lib/a.dart': '''
import 'package:annotation/annotation.dart';

@Annotation()
class A {}

class B {}
''',
        'annotation|lib/annotation.dart': '''
class Annotation {
  const Annotation();
}
''',
      },
      (resolver) async {
        final library = await resolver.libraryFor(AssetId('a', 'lib/a.dart'));
        expect(library.name, equals('a'));

        final hasAnnotation = checker.hasAnnotationOf(library);
        expect(hasAnnotation, isFalse);
        final hasAnnotation2 = checker2.hasAnnotationOf(library);
        expect(hasAnnotation2, isFalse);

        final classA = library.getClass('A');
        expect(classA, isNotNull);
        final classHasAnnotation = checker.hasAnnotationOf(classA!);
        expect(classHasAnnotation, isTrue);
        final classHasAnnotation2 = checker2.hasAnnotationOf(classA);
        expect(classHasAnnotation2, isTrue);

        final classB = library.getClass('B');
        expect(classB, isNotNull);
        final classBHasAnnotation = checker.hasAnnotationOf(classB!);
        expect(classBHasAnnotation, isFalse);
        final classBHasAnnotation2 = checker2.hasAnnotationOf(classB);
        expect(classBHasAnnotation2, isFalse);
      },
    );
  });
}
