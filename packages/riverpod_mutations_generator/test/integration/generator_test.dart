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
    provider.change
        .check<
          void,
          Future<void> Function(MutationTarget target, int i),
          Future<void> Function(int i)
        >();
  }

  @mutation
  Future<String?> nullable() async {
    provider.nullable
        .check<
          String?,
          Future<String?> Function(MutationTarget target),
          Future<String?> Function()
        >();
    throw UnimplementedError();
  }

  @mutation
  Future<void> normal() async {
    provider.normal
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  @mutation
  Future<void> withRef(MutationTransaction ref) async {
    provider.withRef
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  @mutation
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

  @mutation
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

  @mutation
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
