import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:test/test.dart';

part 'generator_test.g.dart';

@riverpod
class Demo extends _$Demo {
  @override
  FutureOr<int> build() => 0;

  DemoProvider get provider => demoProvider;

  @mutation
  Future<void> change(int i) async {
    ref.read<Future<void> Function(int i)>(provider.change.run);
  }

  @mutation
  Future<String?> nullable() async {
    ref.read<Future<String?> Function()>(provider.nullable.run);
    throw UnimplementedError();
  }

  @mutation
  Future<void> normal() async {
    ref.read<Future<void> Function()>(provider.normal.run);
  }

  @mutation
  Future<void> withRef(MutationRef ref) async {
    ref.get<Future<void> Function()>(provider.withRef.run);
  }

  @mutation
  Future<T> generic<T>() {
    ref.read<Future<T> Function()>(provider.generic<T>().run);
    throw UnimplementedError();
  }

  @mutation
  Future<void> nameCollision(Object ref, Object mutation) async {
    this.ref.read<Future<void> Function(Object ref, Object mutation)>(
      provider.nameCollision.run,
    );
  }

  @mutation
  Future<void> keyed(
    @mutationKey String key,
    int param, {
    @mutationKey String? namedKey,
    int? optionalParam,
  }) async {
    ref.read<Future<void> Function(int param, {int? optionalParam})>(
      provider.keyed(key, namedKey: namedKey).run,
    );
  }
}

@riverpod
class DemoFamily extends _$DemoFamily {
  @override
  FutureOr<int> build(bool key) => 0;

  DemoFamilyProvider get provider => demoFamilyProvider(key);

  @mutation
  Future<void> changeFamily(
    int i,
    String? e, {
    required bool b,
    num n = 1,
  }) async {
    ref.read<Future<void> Function(int i, String? e, {required bool b, num n})>(
      provider.changeFamily.run,
    );
  }
}

@riverpod
class DemoGeneric<T> extends _$DemoGeneric<T> {
  @override
  T build() {
    throw UnimplementedError();
  }

  DemoGenericProvider<T> get provider => demoGenericProvider<T>();

  @mutation
  Future<void> changeGeneric(T value) async {
    ref.read<Future<void> Function(T value)>(provider.changeGeneric.run);
  }

  @mutation
  Future<(T, R)> generic<R>() {
    ref.read<Future<(T, R)> Function()>(provider.generic<R>().run);
    throw UnimplementedError();
  }

  @mutation
  Future<T> genericShadowed<T>() {
    ref.read<Future<T> Function()>(provider.genericShadowed<T>().run);
    throw UnimplementedError();
  }
}

void main() {
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
