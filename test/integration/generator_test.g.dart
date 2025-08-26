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

String _$demoHash() => r'0deea235dc30e82b0ee61aa4b227a356770f5e5f';

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

@ProviderFor(DemoFamily)
const demoFamilyProvider = DemoFamilyFamily._();

final class DemoFamilyProvider extends $AsyncNotifierProvider<DemoFamily, int> {
  const DemoFamilyProvider._({
    required DemoFamilyFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'demoFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$demoFamilyHash();

  @override
  String toString() {
    return r'demoFamilyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  DemoFamily create() => DemoFamily();

  @override
  bool operator ==(Object other) {
    return other is DemoFamilyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$demoFamilyHash() => r'c3b883adfbdcb9ac92b0955b738349baf148225b';

final class DemoFamilyFamily extends $Family
    with
        $ClassFamilyOverride<
          DemoFamily,
          AsyncValue<int>,
          int,
          FutureOr<int>,
          bool
        > {
  const DemoFamilyFamily._()
    : super(
        retry: null,
        name: r'demoFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DemoFamilyProvider call(bool key) =>
      DemoFamilyProvider._(argument: key, from: this);

  @override
  String toString() => r'demoFamilyProvider';
}

abstract class _$DemoFamily extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as bool;
  bool get key => _$args;

  FutureOr<int> build(bool key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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

String _$demoGenericHash() => r'a331616ebda67d119fd55613eac692f17cd391e1';

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
extension DemoMutations on DemoProvider {
  MutationListenable<void, Future<void> Function(int i)> get change =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          (int i) => mutation.run(ref, (ref) {
            return ref.get(this.notifier).change(i);
          }),
        ),
        (this, 'change', ()),
      );

  MutationListenable<String?, Future<String?> Function()> get nullable =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).nullable();
          }),
        ),
        (this, 'nullable', ()),
      );
  MutationListenable<void, Future<void> Function()> get normal =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).normal();
          }),
        ),
        (this, 'normal', ()),
      );
  MutationListenable<void, Future<void> Function()> get withRef =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).withRef(ref);
          }),
        ),
        (this, 'withRef', ()),
      );
  MutationListenable<T, Future<T> Function()> generic<T>() =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).generic();
          }),
        ),
        (this, 'generic', ()),
      );
  MutationListenable<void, Future<void> Function(Object ref, Object mutation)>
  get nameCollision => MutationListenable.create(
    (ref_0, mutation_0) => (
      ref_0.watch(mutation_0),
      (Object ref, Object mutation) => mutation_0.run(ref_0, (ref_0) {
        return ref_0.get(this.notifier).nameCollision(ref, mutation);
      }),
    ),
    (this, 'nameCollision', ()),
  );
  MutationListenable<
    void,
    Future<void> Function(int param, {int? optionalParam})
  >
  keyed(String key, {String? namedKey}) => MutationListenable.create(
    (ref, mutation) => (
      ref.watch(mutation),
      (int param, {int? optionalParam}) => mutation.run(ref, (ref) {
        return ref
            .get(this.notifier)
            .keyed(
              key,
              param,
              namedKey: namedKey,
              optionalParam: optionalParam,
            );
      }),
    ),
    (this, 'keyed', (key, namedKey: namedKey)),
  );
}

extension DemoFamilyMutations on DemoFamilyProvider {
  MutationListenable<
    void,
    Future<void> Function(int i, String? e, {required bool b, num n})
  >
  get changeFamily => MutationListenable.create(
    (ref, mutation) => (
      ref.watch(mutation),
      (int i, String? e, {required bool b, num n = 1}) =>
          mutation.run(ref, (ref) {
            return ref.get(this.notifier).changeFamily(i, e, b: b, n: n);
          }),
    ),
    (this, 'changeFamily', ()),
  );
}

extension DemoGenericMutations<T> on DemoGenericProvider<T> {
  MutationListenable<void, Future<void> Function(T value)> get changeGeneric =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          (T value) => mutation.run(ref, (ref) {
            return ref.get(this.notifier).changeGeneric(value);
          }),
        ),
        (this, 'changeGeneric', ()),
      );
  MutationListenable<(T, R), Future<(T, R)> Function()> generic<R>() =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).generic();
          }),
        ),
        (this, 'generic', ()),
      );
  MutationListenable<T, Future<T> Function()> genericShadowed<T>() =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).genericShadowed();
          }),
        ),
        (this, 'genericShadowed', ()),
      );
}
