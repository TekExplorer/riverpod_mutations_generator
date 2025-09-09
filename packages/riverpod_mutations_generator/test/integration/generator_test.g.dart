// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(Demo)
const demoProvider = DemoProvider._();

final class DemoProvider extends $AsyncNotifierProvider<Demo, int> {
  const DemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoHash();

  @$internal
  @override
  Demo create() => Demo();
}

String _$demoHash() => r'779327e2e3b649d075a5f7d6593bcc1a9ee929ce';

abstract class _$Demo extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
extension DemoMutations on DemoProvider {
  MutationListenable<
    void,
    Future<void> Function(MutationTarget target, int i),
    Future<void> Function(int i)
  >
  get change {
    final mutation = $Mutations.getForProvider<void>(this, 'change');
    Future<void> run(MutationTarget target, int i) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).change(i);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target, int i) => run(target, i),
      (MutationTarget target) =>
          (int i) => run(target, i),
    );
  }

  MutationListenable<
    String?,
    Future<String?> Function(MutationTarget target),
    Future<String?> Function()
  >
  get nullable {
    final mutation = $Mutations.getForProvider<String?>(this, 'nullable');
    Future<String?> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).nullable();
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target) => run(target),
      (MutationTarget target) =>
          () => run(target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(MutationTarget target),
    Future<void> Function()
  >
  get normal {
    final mutation = $Mutations.getForProvider<void>(this, 'normal');
    Future<void> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).normal();
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target) => run(target),
      (MutationTarget target) =>
          () => run(target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(MutationTarget target),
    Future<void> Function()
  >
  get withRef {
    final mutation = $Mutations.getForProvider<void>(this, 'withRef');
    Future<void> run(MutationTarget target) {
      return mutation.run(target, (ref) {
        return ref.get(this.notifier).withRef(ref);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target) => run(target),
      (MutationTarget target) =>
          () => run(target),
    );
  }

  MutationListenable<
    T,
    Future<T> Function(MutationTarget target),
    Future<T> Function()
  >
  generic<T>() {
    final mutation = $Mutations.getForProvider<T>(this, 'generic');
    Future<T> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).generic<T>();
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target) => run(target),
      (MutationTarget target) =>
          () => run(target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget target,
      Object ref,
      Object mutation,
      Object run,
    ),
    Future<void> Function(Object ref, Object mutation, Object run)
  >
  get nameCollision {
    final mutation_0 = $Mutations.getForProvider<void>(this, 'nameCollision');
    Future<void> run_0(
      MutationTarget target,
      Object ref,
      Object mutation,
      Object run,
    ) {
      return mutation_0.run(target, (tsx) {
        return tsx.get(this.notifier).nameCollision(ref, mutation, run);
      });
    }

    return MutationListenable(
      mutation_0,
      (MutationTarget target, Object ref, Object mutation, Object run) =>
          run_0(target, ref, mutation, run),
      (MutationTarget target) =>
          (Object ref, Object mutation, Object run) =>
              run_0(target, ref, mutation, run),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget target,
      int param, {
      int? optionalParam,
    }),
    Future<void> Function(int param, {int? optionalParam})
  >
  keyed(String key, {String? namedKey}) {
    final mutation = $Mutations.getForProvider<void>(this, 'keyed', (
      key,
      namedKey: namedKey,
    ));
    Future<void> run(MutationTarget target, int param, {int? optionalParam}) {
      return mutation.run(target, (tsx) {
        return tsx
            .get(this.notifier)
            .keyed(
              key,
              param,
              namedKey: namedKey,
              optionalParam: optionalParam,
            );
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target, int param, {int? optionalParam}) =>
          run(target, param, optionalParam: optionalParam),
      (MutationTarget target) =>
          (int param, {int? optionalParam}) =>
              run(target, param, optionalParam: optionalParam),
    );
  }
}
