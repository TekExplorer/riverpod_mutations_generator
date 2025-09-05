// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(DemoGeneric)
const demoGenericProvider = DemoGenericFamily._();

final class DemoGenericProvider<T>
    extends $NotifierProvider<DemoGeneric<T>, T> {
  const DemoGenericProvider._({required DemoGenericFamily super.from})
    : super(
        argument: null,
        retry: null,
        name: r'demoGenericProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoGenericHash();

  @override
  String toString() {
    return r'demoGenericProvider'
        '<${T}>'
        '()';
  }

  @$internal
  @override
  DemoGeneric<T> create() => DemoGeneric<T>();

  $R _captureGenerics<$R>($R Function<T>() cb) {
    return cb<T>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(T value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<T>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DemoGenericProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$demoGenericHash() => r'7d2478f377ca5bbdd089e45218aeef44e1e2a6ac';

final class DemoGenericFamily extends $Family {
  const DemoGenericFamily._()
    : super(
        retry: null,
        name: r'demoGenericProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DemoGenericProvider<T> call<T>() => DemoGenericProvider<T>._(from: this);

  @override
  String toString() => r'demoGenericProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(DemoGeneric<T> Function<T>() create) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as DemoGenericProvider;
      return provider._captureGenerics(<T>() {
        provider as DemoGenericProvider<T>;
        return provider.$view(create: create<T>).$createElement(pointer);
      });
    },
  );

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
    T Function<T>(Ref ref, DemoGeneric<T> notifier) build,
  ) => $FamilyOverride(
    from: this,
    createElement: (pointer) {
      final provider = pointer.origin as DemoGenericProvider;
      return provider._captureGenerics(<T>() {
        provider as DemoGenericProvider<T>;
        return provider
            .$view(runNotifierBuildOverride: build<T>)
            .$createElement(pointer);
      });
    },
  );
}

abstract class _$DemoGeneric<T> extends $Notifier<T> {
  T build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<T, T>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<T, T>, T, Object?, Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
extension DemoGenericMutations<T> on DemoGenericProvider<T> {
  Mutation<T> _$mutation<T>(String mutationName, [Object? key]) =>
      $Mutations.getForProvider<T>(this, mutationName, key);
  DemoGeneric_ChangeGeneric<T> get changeGeneric => DemoGeneric_ChangeGeneric._(
    _$mutation<void>('changeGeneric'),
    (tsx, T value) => tsx.get(this.notifier).changeGeneric(value),
  );
  DemoGeneric_Generic<T, R> generic<R>() => DemoGeneric_Generic._(
    _$mutation<(T, R)>('generic'),
    (tsx) => tsx.get(this.notifier).generic<R>(),
  );
  DemoGeneric_GenericShadowed<T> genericShadowed<T>() =>
      DemoGeneric_GenericShadowed._(
        _$mutation<T>('genericShadowed'),
        (tsx) => tsx.get(this.notifier).genericShadowed<T>(),
      );
}

final class DemoGeneric_ChangeGeneric<T> extends MutationListenable<void> {
  DemoGeneric_ChangeGeneric._(super.mutation, this._run);
  final Future<void> Function(MutationRef, T value) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function(T value))>
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (T value) => run(target, value);
  });

  Future<void> run(MutationTarget target, T value) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx, value);
      });
}

final class DemoGeneric_Generic<T, R> extends MutationListenable<(T, R)> {
  DemoGeneric_Generic._(super.mutation, this._run);
  final Future<(T, R)> Function(MutationRef) _run;

  ProviderListenable<(MutationState<(T, R)>, Future<(T, R)> Function())>
  get pair => $proxyMutationPair(this.mutation, (target) {
    return () => run(target);
  });

  Future<(T, R)> run(MutationTarget target) => this.mutation.run(target, (tsx) {
    return _run(tsx);
  });
}

final class DemoGeneric_GenericShadowed<T> extends MutationListenable<T> {
  DemoGeneric_GenericShadowed._(super.mutation, this._run);
  final Future<T> Function(MutationRef) _run;

  ProviderListenable<(MutationState<T>, Future<T> Function())> get pair =>
      $proxyMutationPair(this.mutation, (target) {
        return () => run(target);
      });

  Future<T> run(MutationTarget target) => this.mutation.run(target, (tsx) {
    return _run(tsx);
  });
}
