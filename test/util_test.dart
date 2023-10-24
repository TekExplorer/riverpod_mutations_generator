import 'package:build_test/build_test.dart';
import 'package:riverpod_mutations_generator/src/util.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('Simple Util.unwrapType', () {
    test('Test Util.unwrapType for Test', () {
      var val = Util.unwrapType('Test');
      expect(
          val,
          (
            isAsync: false,
            outerType: null,
            unwrapped: 'Test',
          ),
          reason: 'was ${val}');
    });
    test('tTest Util.unwrapType for Future<Test>', () {
      var val = Util.unwrapType('Future<Test>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'Future',
            unwrapped: 'Test',
          ),
          reason: 'was ${val}');
    });
    test('Test Util.unwrapType for FutureOr<Test>', () {
      var val = Util.unwrapType('FutureOr<Test>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'FutureOr',
            unwrapped: 'Test',
          ),
          reason: 'was ${val}');
    });
    test('Test Util.unwrapType for Stream<Test>', () {
      var val = Util.unwrapType('Stream<Test>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'Stream',
            unwrapped: 'Test',
          ),
          reason: 'was ${val}');
    });
  });

  //

  group('Nested Util.unwrapType', () {
    test('Test Util.unwrapType for List<Test>', () {
      var val = Util.unwrapType('List<Test>');
      expect(
          val,
          (
            isAsync: false,
            outerType: null,
            unwrapped: 'List<Test>',
          ),
          reason: 'was ${val}');
    });
    test('tTest Util.unwrapType for Future<List<Test>>', () {
      var val = Util.unwrapType('Future<List<Test>>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'Future',
            unwrapped: 'List<Test>',
          ),
          reason: 'was ${val}');
    });
    test('Test Util.unwrapType for FutureOr<List<Test>>', () {
      var val = Util.unwrapType('FutureOr<List<Test>>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'FutureOr',
            unwrapped: 'List<Test>',
          ),
          reason: 'was ${val}');
    });
    test('Test Util.unwrapType for Stream<List<Test>>', () {
      var val = Util.unwrapType('Stream<List<Test>>');
      expect(
          val,
          (
            isAsync: true,
            outerType: 'Stream',
            unwrapped: 'List<Test>',
          ),
          reason: 'was ${val}');
    });
  });

  group('Util.typedParametersOfMethod(method)', () {
    test('With optional positional', () async {
      final libraryElement = await resolveSource('''
library demo;
abstract class Demo {
  void method(String name, [int? id = 0]);
}
''', (resolver) => resolver.findLibraryByName('demo'));

      LibraryReader libraryReader = LibraryReader(libraryElement!);

      final _class = libraryReader.findType('Demo');
      final res = Util.parameterListToString(_class!.methods.first.parameters);
      expect(res, 'String name, [int? id = 0]');

      final res2 = Util.parameterListToString(_class.methods.first.parameters,
          removeDefaults: true);
      expect(res2, 'String name, [int? id]');

      final res3 = Util.parameterListToString(_class.methods.first.parameters,
          removeRequired: true);

      expect(res3, 'String name, [int? id = 0]');

      final res4 = Util.parameterListToString(_class.methods.first.parameters,
          removeRequired: true, removeDefaults: true);

      expect(res4, 'String name, [int? id]');
    });
    test('With named', () async {
      final libraryElement = await resolveSource('''
library demo;
abstract class Demo {
  void method(String name, {int? id = 0, required bool isTrue});
}
''', (resolver) => resolver.findLibraryByName('demo'));

      LibraryReader libraryReader = LibraryReader(libraryElement!);

      final _class = libraryReader.findType('Demo');
      final res = Util.parameterListToString(_class!.methods.first.parameters);
      expect(res, 'String name, {int? id = 0, required bool isTrue}');

      final res2 = Util.parameterListToString(_class.methods.first.parameters,
          removeDefaults: true);
      expect(res2, 'String name, {int? id, required bool isTrue}');

      final res3 = Util.parameterListToString(_class.methods.first.parameters,
          removeRequired: true);

      expect(res3, 'String name, {int? id = 0, bool isTrue}');

      final res4 = Util.parameterListToString(_class.methods.first.parameters,
          removeRequired: true, removeDefaults: true);

      expect(res4, 'String name, {int? id, bool isTrue}');
    });
    //
  });
}

// abstract class Demo {
//   void method(String name, [int? id]);
//   // void method2(String name, {int? id});
// }
