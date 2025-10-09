// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$demoGenericHash() => r'3415f8f5d91aba993d68554a7b21b896d687c484';

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

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

extension DemoGenericMutations<T> on DemoGenericProvider<T> {
  MutationPairListenable<
    void,
    Future<void> Function(MutationTarget _$target, T value),
    Future<void> Function(T value)
  >
  get changeGeneric {
    final _$mutation = $Mutations.ofProvider<void>(this, 'changeGeneric');
    Future<void> _$run(MutationTarget _$target, T value) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).changeGeneric(value);
      });
    }

    return MutationListenable(_$mutation, _$run).$withPair(
      (MutationTarget _$target) =>
          (T value) => _$run(_$target, value),
    );
  }

  MutationPairListenable<
    (T, R),
    Future<(T, R)> Function(MutationTarget _$target),
    Future<(T, R)> Function()
  >
  generic<R>() {
    final _$mutation = $Mutations.ofProvider<(T, R)>(this, 'generic');
    Future<(T, R)> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).generic<R>();
      });
    }

    return MutationListenable(_$mutation, _$run).$withPair(
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }

  MutationPairListenable<
    T,
    Future<T> Function(MutationTarget _$target),
    Future<T> Function()
  >
  genericShadowed<T>() {
    final _$mutation = $Mutations.ofProvider<T>(this, 'genericShadowed');
    Future<T> _$run(MutationTarget _$target) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).genericShadowed<T>();
      });
    }

    return MutationListenable(_$mutation, _$run).$withPair(
      (MutationTarget _$target) =>
          () => _$run(_$target),
    );
  }
}
