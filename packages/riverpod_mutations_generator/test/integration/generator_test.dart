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
    runCheck<Future<void> Function(MutationTarget, int i)>(provider.change.run);
    pairCheck<Future<void> Function(int i)>(provider.change.pair);
  }

  @mutation
  Future<String?> nullable() async {
    runCheck<Future<String?> Function(MutationTarget)>(provider.nullable.run);
    pairCheck<Future<String?> Function()>(provider.nullable.pair);
    throw UnimplementedError();
  }

  @mutation
  Future<void> normal() async {
    runCheck<Future<void> Function(MutationTarget)>(provider.normal.run);
    pairCheck<Future<void> Function()>(provider.normal.pair);
  }

  @mutation
  Future<void> withRef(MutationTransaction ref) async {
    runCheck<Future<void> Function(MutationTarget)>(provider.withRef.run);
    pairCheck<Future<void> Function()>(provider.withRef.pair);
  }

  @mutation
  Future<T> generic<T>() {
    runCheck<Future<T> Function(MutationTarget)>(provider.generic<T>().run);
    pairCheck<Future<T> Function()>(provider.generic<T>().pair);
    throw UnimplementedError();
  }

  @mutation
  Future<void> nameCollision(Object ref, Object mutation, Object run) async {
    runCheck<
      Future<void> Function(
        MutationTarget,
        Object ref,
        Object mutation,
        Object run,
      )
    >(provider.nameCollision.run);
    pairCheck<Future<void> Function(Object ref, Object mutation, Object run)>(
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
    runCheck<
      Future<void> Function(MutationTarget, int param, {int? optionalParam})
    >(provider.keyed(key, namedKey: namedKey).run);
    pairCheck<Future<void> Function(int param, {int? optionalParam})>(
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
