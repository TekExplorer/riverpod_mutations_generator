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

String _$demoHash() => r'9c49b71c3b7076bfb689cd1030394b5d07529d4a';

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

extension DemoMutations on DemoProvider {
  Provider<(MutationState<void>, Future<void> Function(int))> get change =>
      Provider<(MutationState<void>, Future<void> Function(int))>((ref) {
        final mutation = Mutation<void>()((this, 'change'));
        return (
          ref.watch(mutation),
          (int i) =>
              mutation.run(ref, (ref) => ref.get(this.notifier).change(i)),
        );
      });
  Provider<(MutationState<String?>, Future<String?> Function())> get nullable =>
      Provider<(MutationState<String?>, Future<String?> Function())>((ref) {
        final mutation = Mutation<String?>()((this, 'nullable'));
        return (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) => ref.get(this.notifier).nullable()),
        );
      });
  Provider<(MutationState<void>, Future<void> Function())> get normal =>
      Provider<(MutationState<void>, Future<void> Function())>((ref) {
        final mutation = Mutation<void>()((this, 'normal'));
        return (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) => ref.get(this.notifier).normal()),
        );
      });
  Provider<(MutationState<void>, Future<void> Function())> get withRef =>
      Provider<(MutationState<void>, Future<void> Function())>((ref) {
        final mutation = Mutation<void>()((this, 'withRef'));
        return (
          ref.watch(mutation),
          () => mutation.run(ref, (ref) => ref.get(this.notifier).withRef(ref)),
        );
      });
}

extension DemoFamilyMutations on DemoFamilyProvider {
  Provider<
    (
      MutationState<void>,
      Future<void> Function(int, String?, {required bool b, num n}),
    )
  >
  get changeFamily =>
      Provider<
        (
          MutationState<void>,
          Future<void> Function(int, String?, {required bool b, num n}),
        )
      >((ref) {
        final mutation = Mutation<void>()((this, 'changeFamily'));
        return (
          ref.watch(mutation),
          (int i, String? e, {required bool b, num n = 1}) => mutation.run(
            ref,
            (ref) => ref.get(this.notifier).changeFamily(i, e, b: b, n: n),
          ),
        );
      });
}

Provider<(MutationState<String>, Future<String> Function(String, String))>
get loginMut =>
    Provider<(MutationState<String>, Future<String> Function(String, String))>((
      ref,
    ) {
      final mutation = Mutation<String>()(login);
      return (
        ref.watch(mutation),
        (String username, String password) =>
            mutation.run(ref, (ref) => login(username, password)),
      );
    });
