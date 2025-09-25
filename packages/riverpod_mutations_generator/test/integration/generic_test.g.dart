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

String _$demoGenericHash() => r'8bd68b55cf7cf2c59dbc6f3e22379b52d0346324';

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
  MutationListenable<
    void,
    Future<void> Function(MutationTarget target, T value),
    Future<void> Function(T value)
  >
  get changeGeneric {
    final mutation = $Mutations.ofProvider<void>(this, 'changeGeneric');
    Future<void> run(MutationTarget target, T value) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).changeGeneric(value);
      });
    }

    return MutationListenable(
      mutation,
      run,
      (MutationTarget target) =>
          (T value) => run(target, value),
    );
  }

  MutationListenable<
    (T, R),
    Future<(T, R)> Function(MutationTarget target),
    Future<(T, R)> Function()
  >
  generic<R>() {
    final mutation = $Mutations.ofProvider<(T, R)>(this, 'generic');
    Future<(T, R)> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).generic<R>();
      });
    }

    return MutationListenable(
      mutation,
      run,
      (MutationTarget target) =>
          () => run(target),
    );
  }

  MutationListenable<
    T,
    Future<T> Function(MutationTarget target),
    Future<T> Function()
  >
  genericShadowed<T>() {
    final mutation = $Mutations.ofProvider<T>(this, 'genericShadowed');
    Future<T> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).genericShadowed<T>();
      });
    }

    return MutationListenable(
      mutation,
      run,
      (MutationTarget target) =>
          () => run(target),
    );
  }
}
