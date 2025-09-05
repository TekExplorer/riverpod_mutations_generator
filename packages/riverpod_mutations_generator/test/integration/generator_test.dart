import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:test/test.dart';

import 'shared.dart';

part 'generator_test.g.dart';

@riverpod
class Demo extends _$Demo {
  @override
  FutureOr<int> build() => 0;

  DemoProvider get provider => demoProvider;

  @mutation
  Future<void> change(int i) async {
    c<Future<void> Function(MutationTarget, int i)>(provider.change.run);
    c2<Future<void> Function(int i)>(provider.change.pair);
  }

  @mutation
  Future<String?> nullable() async {
    c<Future<String?> Function(MutationTarget)>(provider.nullable.run);
    c2<Future<String?> Function()>(provider.nullable.pair);
    throw UnimplementedError();
  }

  @mutation
  Future<void> normal() async {
    c<Future<void> Function(MutationTarget)>(provider.normal.run);
    c2<Future<void> Function()>(provider.normal.pair);
  }

  @mutation
  Future<void> withRef(MutationRef ref) async {
    c<Future<void> Function(MutationTarget)>(provider.withRef.run);
    c2<Future<void> Function()>(provider.withRef.pair);
  }

  @mutation
  Future<T> generic<T>() {
    c<Future<T> Function(MutationTarget)>(provider.generic<T>().run);
    c2<Future<T> Function()>(provider.generic<T>().pair);
    throw UnimplementedError();
  }

  @mutation
  Future<void> nameCollision(Object ref, Object mutation) async {
    c<Future<void> Function(MutationTarget, Object ref, Object mutation)>(
      provider.nameCollision.run,
    );
    c2<Future<void> Function(Object ref, Object mutation)>(
      provider.nameCollision.pair,
    );
  }

  @mutation
  Future<void> keyed(
    @mutationKey String key,
    int param, {
    @mutationKey String? namedKey,
    int? optionalParam,
  }) async {
    c<Future<void> Function(MutationTarget, int param, {int? optionalParam})>(
      provider.keyed(key, namedKey: namedKey).run,
    );
    c2<Future<void> Function(int param, {int? optionalParam})>(
      provider.keyed(key, namedKey: namedKey).pair,
    );
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

    expect(demoProviderChangeSub.read(), isA<MutationIdle<void>>());

    demoProvider.change.run(container, 3);
    expect(demoProviderChangeSub.read(), isA<MutationPending<void>>());
    // await container.pump();

    await container.pump();

    expect(demoProviderChangeSub.read(), isA<MutationSuccess<void>>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(3));

    demoProviderChangeSub.close();
    await container.pump();

    final demoProviderChangeSub2 = container.listen(
      demoProvider.change,
      (previous, next) {},
    );

    expect(demoProviderChangeSub2.read(), isA<MutationIdle<void>>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>(), reason: 'unchanged');
    expect(demoProviderSub.read(), AsyncData<int>(3), reason: 'unchanged');
  });
}
