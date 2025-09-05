// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$demoFamilyHash() => r'4e5a1331c9d350780515c337af595f4292c1f925';

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
extension DemoFamilyMutations on DemoFamilyProvider {
  Mutation<T> _$mutation<T>(String mutationName, [Object? key]) =>
      $Mutations.getForProvider<T>(this, mutationName, key);
  DemoFamily_ChangeFamily get changeFamily => DemoFamily_ChangeFamily._(
    _$mutation<void>('changeFamily'),
    (tsx, int i, String? e, {required bool b, num n = 1}) =>
        tsx.get(this.notifier).changeFamily(i, e, b: b, n: n),
  );
}

final class DemoFamily_ChangeFamily extends MutationListenable<void> {
  DemoFamily_ChangeFamily._(super.mutation, this._run);
  final Future<void> Function(
    MutationRef,
    int i,
    String? e, {
    required bool b,
    num n,
  })
  _run;

  ProviderListenable<
    (
      MutationState<void>,
      Future<void> Function(int i, String? e, {required bool b, num n}),
    )
  >
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (int i, String? e, {required bool b, num n = 1}) =>
        run(target, i, e, b: b, n: n);
  });

  Future<void> run(
    MutationTarget target,
    int i,
    String? e, {
    required bool b,
    num n = 1,
  }) => this.mutation.run(target, (tsx) {
    return _run(tsx, i, e, b: b, n: n);
  });
}
