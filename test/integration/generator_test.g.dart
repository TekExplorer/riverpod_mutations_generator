// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoHash() => r'28cf41092719540180c6163951fb1508be9b605e';

/// See also [Demo].
@ProviderFor(Demo)
final demoProvider = AutoDisposeAsyncNotifierProvider<Demo, int>.internal(
  Demo.new,
  name: r'demoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$demoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Demo = AutoDisposeAsyncNotifier<int>;
String _$demoFamilyHash() => r'03aa4b6e590c92199ae7c18c85792d9c5a9ffadd';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DemoFamily extends BuildlessAutoDisposeAsyncNotifier<int> {
  late final Object key;

  FutureOr<int> build(
    Object key,
  );
}

/// See also [DemoFamily].
@ProviderFor(DemoFamily)
const demoFamilyProvider = DemoFamilyFamily();

/// See also [DemoFamily].
class DemoFamilyFamily extends Family<AsyncValue<int>> {
  /// See also [DemoFamily].
  const DemoFamilyFamily();

  /// See also [DemoFamily].
  DemoFamilyProvider call(
    Object key,
  ) {
    return DemoFamilyProvider(
      key,
    );
  }

  @override
  DemoFamilyProvider getProviderOverride(
    covariant DemoFamilyProvider provider,
  ) {
    return call(
      provider.key,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'demoFamilyProvider';
}

/// See also [DemoFamily].
class DemoFamilyProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DemoFamily, int> {
  /// See also [DemoFamily].
  DemoFamilyProvider(
    Object key,
  ) : this._internal(
          () => DemoFamily()..key = key,
          from: demoFamilyProvider,
          name: r'demoFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$demoFamilyHash,
          dependencies: DemoFamilyFamily._dependencies,
          allTransitiveDependencies:
              DemoFamilyFamily._allTransitiveDependencies,
          key: key,
        );

  DemoFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final Object key;

  @override
  FutureOr<int> runNotifierBuild(
    covariant DemoFamily notifier,
  ) {
    return notifier.build(
      key,
    );
  }

  @override
  Override overrideWith(DemoFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: DemoFamilyProvider._internal(
        () => create()..key = key,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DemoFamily, int> createElement() {
    return _DemoFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DemoFamilyProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DemoFamilyRef on AutoDisposeAsyncNotifierProviderRef<int> {
  /// The parameter `key` of this provider.
  Object get key;
}

class _DemoFamilyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DemoFamily, int>
    with DemoFamilyRef {
  _DemoFamilyProviderElement(super.provider);

  @override
  Object get key => (origin as DemoFamilyProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// Generator: Gen
// **************************************************************************

final _changeDemo = MutFamily<void, void Function(int), (), ()>((
  ref,
  args,
) =>
    (int i) {
      ref.mutate(() => ref.read(demoProvider.notifier).change(i));
    });
final _nullableDemo = MutFamily<String?, void Function(), (), ()>((
  ref,
  args,
) =>
    () {
      ref.mutate(() => ref.read(demoProvider.notifier).nullable());
    });
final _futureOrDemo = MutFamily<String, void Function(), (), ()>((
  ref,
  args,
) =>
    () {
      ref.mutate(() => ref.read(demoProvider.notifier).futureOr());
    });
final _normalDemo = MutFamily<void, void Function(), (), ()>((
  ref,
  args,
) =>
    () {
      ref.mutate(() => ref.read(demoProvider.notifier).normal());
    });

extension DemoMutations on AutoDisposeAsyncNotifierProvider<Demo, dynamic> {
  () get args => ();
  MutProvider<void, void Function(int), (), ()> get change => _changeDemo(
        notifierKeys: args,
        mutKeys: (),
      );
  MutProvider<String?, void Function(), (), ()> get nullable => _nullableDemo(
        notifierKeys: args,
        mutKeys: (),
      );
  MutProvider<String, void Function(), (), ()> get futureOr => _futureOrDemo(
        notifierKeys: args,
        mutKeys: (),
      );
  MutProvider<void, void Function(), (), ()> get normal => _normalDemo(
        notifierKeys: args,
        mutKeys: (),
      );
}

final _changeFamilyDemoFamily = MutFamily<
    void,
    void Function(
      int,
      String?, {
      required bool b,
      num n,
    }),
    (),
    ({Object key})>((
  ref,
  args,
) =>
    (
      int i,
      String? e, {
      required bool b,
      num n = 1,
    }) {
      ref.mutate(() => ref
          .read(demoFamilyProvider(args.notifierKeys.key).notifier)
          .changeFamily(
            i,
            e,
            b: b,
            n: n,
          ));
    });

extension DemoFamilyMutations on DemoFamilyFamily {
  ({Object key}) get args => (key: Object);
  MutProvider<
      void,
      void Function(
        int,
        String?, {
        required bool b,
        num n,
      }),
      (),
      ({Object key})> get changeFamily => _changeFamilyDemoFamily(
        notifierKeys: args,
        mutKeys: (),
      );
}
