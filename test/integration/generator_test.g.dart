// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoHash() => r'd73b926efe1b906f92bc67a2bb0361b389dd082a';

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
String _$demoFamilyHash() => r'e479991a6aab77284092ad566ca45c3a530b7890';

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
  late final bool key;

  FutureOr<int> build(
    bool key,
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
    bool key,
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
    bool key,
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

  final bool key;

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
  bool get key;
}

class _DemoFamilyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DemoFamily, int>
    with DemoFamilyRef {
  _DemoFamilyProviderElement(super.provider);

  @override
  bool get key => (origin as DemoFamilyProvider).key;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

extension DemoMutations on AsyncNotifierProviderBase<Demo, dynamic> {
  MutProvider<void, void Function(int)> get change =>
      MutProvider<void, void Function(int)>(
        (_ref) =>
            (int i) => _ref.mutate(() => _ref.read(this.notifier).change(i)),
        keys: (),
        source: this,
        method: 'change',
      );
  MutProvider<String?, void Function()> get nullable =>
      MutProvider<String?, void Function()>(
        (_ref) => () => _ref.mutate(() => _ref.read(this.notifier).nullable()),
        keys: (),
        source: this,
        method: 'nullable',
      );
  MutProvider<String, void Function()> get futureOr =>
      MutProvider<String, void Function()>(
        (_ref) => () => _ref.mutate(() => _ref.read(this.notifier).futureOr()),
        keys: (),
        source: this,
        method: 'futureOr',
      );
  MutProvider<void, void Function()> get normal =>
      MutProvider<void, void Function()>(
        (_ref) => () => _ref.mutate(() => _ref.read(this.notifier).normal()),
        keys: (),
        source: this,
        method: 'normal',
      );
  MutProvider<void, void Function()> get withRef =>
      MutProvider<void, void Function()>(
        (_ref) =>
            () => _ref.mutate(() => _ref.read(this.notifier).withRef(_ref)),
        keys: (),
        source: this,
        method: 'withRef',
      );
}

extension DemoFamilyMutations on DemoFamilyProvider {
  MutProvider<
      void,
      void Function(
        int,
        String?, {
        required bool b,
        num n,
      })> get changeFamily => MutProvider<
          void,
          void Function(
            int,
            String?, {
            required bool b,
            num n,
          })>(
        (_ref) => (
          int i,
          String? e, {
          required bool b,
          num n = 1,
        }) =>
            _ref.mutate(() => _ref.read(this.notifier).changeFamily(
                  i,
                  e,
                  b: b,
                  n: n,
                )),
        keys: (),
        source: this,
        method: 'changeFamily',
      );
}

MutProvider<
    String,
    void Function(
      String,
      String,
    )> get loginMut => MutProvider<
        String,
        void Function(
          String,
          String,
        )>(
      (_ref) => (
        String username,
        String password,
      ) =>
          _ref.mutate(() => login(
                username,
                password,
              )),
      keys: (),
      source: null,
      method: login,
    );
