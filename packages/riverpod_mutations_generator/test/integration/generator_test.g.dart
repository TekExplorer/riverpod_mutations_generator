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

String _$demoHash() => r'92944fec40d216075e69277df05e56e5e945d35f';

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
extension DemoMutations on DemoProvider {
  Mutation<T> _$mutation<T>(String mutationName, [Object? key]) =>
      $Mutations.getForProvider<T>(this, mutationName, key);
  Demo_Change get change => Demo_Change._(
    _$mutation<void>('change'),
    (tsx, int i) => tsx.get(this.notifier).change(i),
  );
  Demo_Nullable get nullable => Demo_Nullable._(
    _$mutation<String?>('nullable'),
    (tsx) => tsx.get(this.notifier).nullable(),
  );
  Demo_Normal get normal => Demo_Normal._(
    _$mutation<void>('normal'),
    (tsx) => tsx.get(this.notifier).normal(),
  );
  Demo_WithRef get withRef => Demo_WithRef._(
    _$mutation<void>('withRef'),
    (ref) => ref.get(this.notifier).withRef(ref),
  );
  Demo_Generic<T> generic<T>() => Demo_Generic._(
    _$mutation<T>('generic'),
    (tsx) => tsx.get(this.notifier).generic<T>(),
  );
  Demo_NameCollision get nameCollision => Demo_NameCollision._(
    _$mutation<void>('nameCollision'),
    (tsx, Object ref, Object mutation) =>
        tsx.get(this.notifier).nameCollision(ref, mutation),
  );
  Demo_Keyed keyed(String key, {String? namedKey}) => Demo_Keyed._(
    _$mutation<void>('keyed', (key, namedKey: namedKey)),
    (tsx, int param, {int? optionalParam}) => tsx
        .get(this.notifier)
        .keyed(key, param, namedKey: namedKey, optionalParam: optionalParam),
  );
}

final class Demo_Change extends MutationListenable<void> {
  Demo_Change._(super.mutation, this._run);
  final Future<void> Function(MutationRef, int i) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function(int i))>
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (int i) => run(target, i);
  });

  Future<void> run(MutationTarget target, int i) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx, i);
      });
}

final class Demo_Nullable extends MutationListenable<String?> {
  Demo_Nullable._(super.mutation, this._run);
  final Future<String?> Function(MutationRef) _run;

  ProviderListenable<(MutationState<String?>, Future<String?> Function())>
  get pair => $proxyMutationPair(this.mutation, (target) {
    return () => run(target);
  });

  Future<String?> run(MutationTarget target) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx);
      });
}

final class Demo_Normal extends MutationListenable<void> {
  Demo_Normal._(super.mutation, this._run);
  final Future<void> Function(MutationRef) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function())> get pair =>
      $proxyMutationPair(this.mutation, (target) {
        return () => run(target);
      });

  Future<void> run(MutationTarget target) => this.mutation.run(target, (tsx) {
    return _run(tsx);
  });
}

final class Demo_WithRef extends MutationListenable<void> {
  Demo_WithRef._(super.mutation, this._run);
  final Future<void> Function(MutationRef) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function())> get pair =>
      $proxyMutationPair(this.mutation, (target) {
        return () => run(target);
      });

  Future<void> run(MutationTarget target) => this.mutation.run(target, (ref) {
    return _run(ref);
  });
}

final class Demo_Generic<T> extends MutationListenable<T> {
  Demo_Generic._(super.mutation, this._run);
  final Future<T> Function(MutationRef) _run;

  ProviderListenable<(MutationState<T>, Future<T> Function())> get pair =>
      $proxyMutationPair(this.mutation, (target) {
        return () => run(target);
      });

  Future<T> run(MutationTarget target) => this.mutation.run(target, (tsx) {
    return _run(tsx);
  });
}

final class Demo_NameCollision extends MutationListenable<void> {
  Demo_NameCollision._(super.mutation, this._run);
  final Future<void> Function(MutationRef, Object ref, Object mutation) _run;

  ProviderListenable<
    (MutationState<void>, Future<void> Function(Object ref, Object mutation))
  >
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (Object ref, Object mutation) => run(target, ref, mutation);
  });

  Future<void> run(MutationTarget target, Object ref, Object mutation) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx, ref, mutation);
      });
}

final class Demo_Keyed extends MutationListenable<void> {
  Demo_Keyed._(super.mutation, this._run);
  final Future<void> Function(MutationRef, int param, {int? optionalParam})
  _run;

  ProviderListenable<
    (
      MutationState<void>,
      Future<void> Function(int param, {int? optionalParam}),
    )
  >
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (int param, {int? optionalParam}) =>
        run(target, param, optionalParam: optionalParam);
  });

  Future<void> run(MutationTarget target, int param, {int? optionalParam}) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx, param, optionalParam: optionalParam);
      });
}
