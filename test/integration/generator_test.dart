import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:test/test.dart';

part 'generator_test.g.dart';

@riverpod
class Demo extends _$Demo {
  @override
  FutureOr<int> build() => 0;

  @mutation
  Future<void> change(int i) async {
    state = AsyncData(i);
  }

  @mutation
  Future<String?> nullable() async {
    return null;
  }

  // @mutation
  // FutureOr<String> futureOr() => '';

  @mutation
  Future<void> normal() async {}

  @mutation
  Future<void> withRef(MutationRef ref) async {}

  @mutation
  Future<T> generic<T>() => throw UnimplementedError();

  @mutation
  Future<void> nameCollision(Object ref, Object mutation) async {}
}

@riverpod
class DemoFamily extends _$DemoFamily {
  @override
  FutureOr<int> build(bool key) => 0;

  @mutation
  Future<void> changeFamily(
    int i,
    String? e, {
    required bool b,
    num n = 1,
  }) async {
    state = AsyncData(i);
  }
}

void main() {
  test('check', () {
    print(demoFamilyProvider(true).changeFamily);
  });
  test('test', () async {
    final container = ProviderContainer.test();
    final demoProviderSub = container.listen(demoProvider, (previous, next) {});
    final demoProviderChangeSub = container.listen(
      demoProvider.change,
      (previous, next) {},
    );

    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(0));

    expect(demoProviderChangeSub.read().state, isA<MutationIdle<void>>());

    demoProviderChangeSub.read().run(3);
    expect(demoProviderChangeSub.read().state, isA<MutationPending<void>>());
    // await container.pump();

    await container.pump();

    expect(demoProviderChangeSub.read().state, isA<MutationSuccess<void>>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(3));

    demoProviderChangeSub.close();
    await container.pump();

    final demoProviderChangeSub2 = container.listen(
      demoProvider.change,
      (previous, next) {},
    );

    expect(demoProviderChangeSub2.read().state, isA<MutationIdle<void>>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>(), reason: 'unchanged');
    expect(demoProviderSub.read(), AsyncData<int>(3), reason: 'unchanged');
  });
}
