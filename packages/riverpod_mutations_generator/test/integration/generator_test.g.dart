// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$demoHash() => r'3b56e9bfa022cb257297751a48f32a061dd6cb9e';

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

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

extension DemoMutations on DemoProvider {
  MutationListenable<
    void,
    Future<void> Function(MutationTarget _$target, int i),
    Future<void> Function(int i)
  >
  get change {
    final _$mutation = $Mutations.ofProvider<void>(this, 'change');
    Future<void> _$run(MutationTarget _$target, int i) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).change(i);
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          (int i) => _$run(_$target, i),
    );
  }

  MutationListenable<
    String?,
    Future<String?> Function(MutationTarget _$target),
    Future<String?> Function()
  >
  get nullable {
    final _$mutation = $Mutations.ofProvider<String?>(this, 'nullable');
    Future<String?> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).nullable();
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(MutationTarget _$target),
    Future<void> Function()
  >
  get normal {
    final _$mutation = $Mutations.ofProvider<void>(this, 'normal');
    Future<void> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).normal();
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(MutationTarget _$target),
    Future<void> Function()
  >
  get withRef {
    final _$mutation = $Mutations.ofProvider<void>(this, 'withRef');
    Future<void> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).withRef(_$tsx);
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }

  MutationListenable<
    T,
    Future<T> Function(MutationTarget _$target),
    Future<T> Function()
  >
  generic<T>() {
    final _$mutation = $Mutations.ofProvider<T>(this, 'generic');
    Future<T> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).generic<T>();
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget _$target,
      Object ref,
      Object mutation,
      Object run,
    ),
    Future<void> Function(Object ref, Object mutation, Object run)
  >
  get nameCollision {
    final _$mutation = $Mutations.ofProvider<void>(this, 'nameCollision');
    Future<void> _$run(
      MutationTarget _$target,
      Object ref,
      Object mutation,
      Object run,
    ) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).nameCollision(ref, mutation, run);
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          (Object ref, Object mutation, Object run) =>
              _$run(_$target, ref, mutation, run),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget _$target,
      int param, {
      int? optionalParam,
    }),
    Future<void> Function(int param, {int? optionalParam})
  >
  keyed(String key, {String? namedKey}) {
    final _$mutation = $Mutations.ofProvider<void>(this, 'keyed', (
      key,
      namedKey: namedKey,
    ));
    Future<void> _$run(
      MutationTarget _$target,
      int param, {
      int? optionalParam,
    }) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx
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
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          (int param, {int? optionalParam}) =>
              _$run(_$target, param, optionalParam: optionalParam),
    );
  }
}
