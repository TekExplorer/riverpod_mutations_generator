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

String _$demoHash() => r'bd3ee7affcd5e1cfcacc8697dce59cbc74887c60';

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

String _$demoFamilyHash() => r'e479991a6aab77284092ad566ca45c3a530b7890';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
extension DemoMutations on DemoProvider {
  MutationListenable<void, Future<void> Function(int i)> get change =>
      MutationListenable(
        (ref, mutation) => (
          ref.watch(mutation),
          (int i) => mutation.run(ref, (ref) {
            return ref.get(this.notifier).change(i);
          }),
        ),
        (this, 'change'),
        label: '${this.name}.change',
      );
  MutationListenable<String?, Future<String?> Function()> get nullable =>
      MutationListenable(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).nullable();
          }),
        ),
        (this, 'nullable'),
        label: '${this.name}.nullable',
      );
  MutationListenable<void, Future<void> Function()> get normal =>
      MutationListenable(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).normal();
          }),
        ),
        (this, 'normal'),
        label: '${this.name}.normal',
      );
  MutationListenable<void, Future<void> Function()> get withRef =>
      MutationListenable(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).withRef(ref);
          }),
        ),
        (this, 'withRef'),
        label: '${this.name}.withRef',
      );
  MutationListenable<T, Future<T> Function()> generic<T>() =>
      MutationListenable(
        (ref, mutation) => (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) {
            return ref.get(this.notifier).generic();
          }),
        ),
        (this, 'generic'),
        label: '${this.name}.generic',
      );
  MutationListenable<void, Future<void> Function(Object ref, Object mutation)>
  get nameCollision => MutationListenable(
    (ref_0, mutation_0) => (
      ref_0.watch(mutation_0),
      (Object ref, Object mutation) => mutation_0.run(ref_0, (ref_0) {
        return ref_0.get(this.notifier).nameCollision(ref, mutation);
      }),
    ),
    (this, 'nameCollision'),
    label: '${this.name}.nameCollision',
  );
}

extension DemoFamilyMutations on DemoFamilyProvider {
  MutationListenable<
    void,
    Future<void> Function(int i, String? e, {required bool b, num n})
  >
  get changeFamily => MutationListenable(
    (ref, mutation) => (
      ref.watch(mutation),
      (int i, String? e, {required bool b, num n = 1}) =>
          mutation.run(ref, (ref) {
            return ref.get(this.notifier).changeFamily(i, e, b: b, n: n);
          }),
    ),
    (this, 'changeFamily'),
    label: '${this.name}.changeFamily',
  );
}
