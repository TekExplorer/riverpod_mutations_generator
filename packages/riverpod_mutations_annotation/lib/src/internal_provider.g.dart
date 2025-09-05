// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(_Mutations)
const _mutationsProvider = _MutationsFamily._();

final class _MutationsProvider<R, F>
    extends $NotifierProvider<_Mutations<R, F>, (MutationState<R>, F)> {
  const _MutationsProvider._(
      {required _MutationsFamily super.from,
      required (
        Mutation<R>,
        Ignore<F Function(MutationTarget target)>,
      )
          super.argument})
      : super(
          retry: null,
          name: r'_mutationsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_mutationsHash();

  @override
  String toString() {
    return r'_mutationsProvider'
        '<${R}, ${F}>'
        '$argument';
  }

  @$internal
  @override
  _Mutations<R, F> create() => _Mutations<R, F>();

  $R _captureGenerics<$R>($R Function<R, F>() cb) {
    return cb<R, F>();
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((MutationState<R>, F) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(MutationState<R>, F)>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _MutationsProvider &&
        other.runtimeType == runtimeType &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, argument);
  }
}

String _$_mutationsHash() => r'519e47d01b508b4e37d6ba8db50ef2a5ddbb4900';

final class _MutationsFamily extends $Family {
  const _MutationsFamily._()
      : super(
          retry: null,
          name: r'_mutationsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  _MutationsProvider<R, F> call<R, F>(
    Mutation<R> mutation,
    Ignore<F Function(MutationTarget target)> fn,
  ) =>
      _MutationsProvider<R, F>._(argument: (
        mutation,
        fn,
      ), from: this);

  @override
  String toString() => r'_mutationsProvider';

  /// {@macro riverpod.override_with}
  Override overrideWith(_Mutations<R, F> Function<R, F>() create) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as _MutationsProvider;
            return provider._captureGenerics(<R, F>() {
              provider as _MutationsProvider<R, F>;
              return provider
                  .$view(create: create<R, F>)
                  .$createElement(pointer);
            });
          });

  /// {@macro riverpod.override_with_build}
  Override overrideWithBuild(
          (MutationState<R>, F) Function<R, F>(
                  Ref ref, _Mutations<R, F> notifier)
              build) =>
      $FamilyOverride(
          from: this,
          createElement: (pointer) {
            final provider = pointer.origin as _MutationsProvider;
            return provider._captureGenerics(<R, F>() {
              provider as _MutationsProvider<R, F>;
              return provider
                  .$view(runNotifierBuildOverride: build<R, F>)
                  .$createElement(pointer);
            });
          });
}

abstract class _$Mutations<R, F> extends $Notifier<(MutationState<R>, F)> {
  late final _$args = ref.$arg as (
    Mutation<R>,
    Ignore<F Function(MutationTarget target)>,
  );
  Mutation<R> get mutation => _$args.$1;
  Ignore<F Function(MutationTarget target)> get fn => _$args.$2;

  (MutationState<R>, F) build(
    Mutation<R> mutation,
    Ignore<F Function(MutationTarget target)> fn,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      _$args.$1,
      _$args.$2,
    );
    final ref = this.ref as $Ref<(MutationState<R>, F), (MutationState<R>, F)>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<(MutationState<R>, F), (MutationState<R>, F)>,
        (MutationState<R>, F),
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
