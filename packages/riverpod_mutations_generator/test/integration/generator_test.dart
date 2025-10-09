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

  @mutationPair
  Future<void> change(int i) async {
    provider.change
        .check<
          void,
          Future<void> Function(MutationTarget target, int i),
          Future<void> Function(int i)
        >();
    await null;
    state = AsyncData(i);
  }

  @mutationPair
  Future<String?> nullable() async {
    provider.nullable
        .check<
          String?,
          Future<String?> Function(MutationTarget target),
          Future<String?> Function()
        >();
    throw UnimplementedError();
  }

  @mutationPair
  Future<void> normal() async {
    provider.normal
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  @mutationPair
  Future<void> withRef(MutationTransaction ref) async {
    provider.withRef
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  @mutationPair
  Future<T> generic<T>() {
    provider
        .generic<T>()
        .check<
          T,
          Future<T> Function(MutationTarget target),
          Future<T> Function()
        >();

    throw UnimplementedError();
  }

  @mutationPair
  Future<void> nameCollision(Object ref, Object mutation, Object run) async {
    provider.nameCollision
        .check<
          void,
          Future<void> Function(
            MutationTarget,
            Object ref,
            Object mutation,
            Object run,
          ),
          Future<void> Function(Object ref, Object mutation, Object run)
        >();
  }

  @mutationPair
  Future<void> keyed(
    @mutationKey String key,
    int param, {
    @mutationKey String? namedKey,
    int? optionalParam,
  }) async {
    provider
        .keyed(key, namedKey: namedKey)
        .check<
          void,
          Future<void> Function(
            MutationTarget target,
            int param, {
            int? optionalParam,
          }),
          Future<void> Function(int param, {int? optionalParam})
        >();
  }

  @mutation
  Future<String> notAPair(
    MutationTransaction tsx,
    @mutationKey String key, {
    int? optionalParam,
  }) async {
    return 'result';
  }
}

void main() {
  test('basic functionality test', () async {
    final container = ProviderContainer.test();
    final demoProviderSub = container.listen(demoProvider, (previous, next) {});
    final demoProviderChangeSub = container.listen(
      demoProvider.change,
      (previous, next) {},
    );

    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(0));

    expect(demoProviderChangeSub.read(), isA<MutationIdle<void>>());

    final future = demoProvider.change.run(container, 3);
    expect(demoProviderChangeSub.read(), isA<MutationPending<void>>());
    // await container.pump();

    await future;
    await container.pump();

    expect(demoProviderChangeSub.read(), isA<MutationSuccess<void>>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(3));

    expect(
      demoProviderChangeSub.read(),
      container.read(demoProvider.change),
      reason: 'same instance',
    );

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
