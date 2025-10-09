import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:test/test.dart';

import 'shared.dart';

part 'static_test.g.dart';

class Static {
  static final test = _$Static_test;
  @mutationPair
  static Future<void> _test() async {
    Static.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$Static_test2;
  @mutationPair
  static Future<String> _test2(String id, @mutationKey String key) async {
    Static.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}

extension Extension on void {
  static final test = _$Extension_test;
  @mutationPair
  static Future<void> _test() async {
    Extension.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$Extension_test2;
  @mutationPair
  static Future<String> _test2(String id, @mutationKey String key) async {
    Extension.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}

extension type ExtensionType(int _) {
  static final test = _$ExtensionType_test;
  @mutationPair
  static Future<void> _test() async {
    ExtensionType.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$ExtensionType_test2;
  @mutationPair
  static Future<String> _test2(String id, @mutationKey String key) async {
    ExtensionType.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}

void main() {
  test('static method', () async {
    final container = ProviderContainer.test();
    final sub = container.listen(Static.test, (_, _) {});
    expect(sub.read(), isA<MutationIdle<void>>());
    final future = Static.test.run(container);
    expect(sub.read(), isA<MutationPending<void>>());
    await future;
    expect(sub.read(), isA<MutationSuccess<void>>());
  });
  test('static method with parameters', () async {
    final container = ProviderContainer.test();
    final sub = container.listen(Static.test2('key'), (_, _) {});
    expect(sub.read(), isA<MutationIdle<String>>());
    final future = Static.test2('key').run(container, 'id');
    expect(sub.read(), isA<MutationPending<String>>());
    final result = await future;
    expect(result, 'result');
    expect(
      sub.read(),
      isA<MutationSuccess<String>>().having((s) => s.value, 'data', 'result'),
    );
  });

  test('pair mutation', () async {
    final container = ProviderContainer.test();
    final sub = container.listen(Static.test.pair, (_, _) {});
    var (state, Future<void> Function() action) = sub.read();
    expect(state, isA<MutationIdle<void>>());

    final future = action();
    expect(sub.read().$1, isA<MutationPending<void>>());
    await future;
    expect(sub.read().$1, isA<MutationSuccess<void>>());
  });
}
