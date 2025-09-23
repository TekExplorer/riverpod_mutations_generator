// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$demoFamilyHash() => r'c6dd19d746bf9ec20bce3df1c2e6cb8cf5ff2633';

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

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

extension DemoFamilyMutations on DemoFamilyProvider {
  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget target,
      int i,
      String? e, {
      required bool b,
      num n,
    }),
    Future<void> Function(int i, String? e, {required bool b, num n})
  >
  get changeFamily {
    final mutation = $Mutations.getForProvider<void>(this, 'changeFamily');
    Future<void> run(
      MutationTarget target,
      int i,
      String? e, {
      required bool b,
      num n = 1,
    }) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).changeFamily(i, e, b: b, n: n);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target, int i, String? e, {required bool b, num n = 1}) =>
          run(target, i, e, b: b, n: n),
      (MutationTarget target) =>
          (int i, String? e, {required bool b, num n = 1}) =>
              run(target, i, e, b: b, n: n),
    );
  }
}
