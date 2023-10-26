// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator_test.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoHash() => r'a1d920d65643bd4adfe6d8ef983b81dbd6bf1da0';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

extension DemoMutationExtension on AutoDisposeAsyncNotifierProvider<Demo, int> {
  Refreshable<ChangeMutation> get change => _changeProvider;
}

final _changeProvider = Provider.autoDispose((ref) {
  final notifier = ref.watch(demoProvider.notifier);
  return ChangeMutation(
    (newState) => ref.state = newState,
    notifier.change,
  );
}, dependencies: [demoProvider]);

typedef ChangeSignature = Future<void> Function(int i);
typedef ChangeStateSetter = void Function(ChangeMutation newState);

sealed class ChangeMutation with AsyncMutation {
  factory ChangeMutation(
    ChangeStateSetter updateState,
    ChangeSignature fn,
  ) = ChangeMutationIdle._;

  ChangeMutation._(this._updateState, this._fn);

  final ChangeStateSetter _updateState;
  final ChangeSignature _fn;

  Object? get error;
  StackTrace? get stackTrace;

  Future<void> call(int i) async {
    _updateState(ChangeMutationLoading.from(this));
    try {
      await _fn(i);
      _updateState(ChangeMutationSuccess.from(this));
    } catch (e, s) {
      _updateState(ChangeMutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class ChangeMutationIdle extends ChangeMutation with MutationIdle {
  ChangeMutationIdle._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeMutationIdle.from(ChangeMutation other) => ChangeMutationIdle._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeMutationLoading extends ChangeMutation with MutationLoading {
  ChangeMutationLoading._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeMutationLoading.from(ChangeMutation other) =>
      ChangeMutationLoading._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeMutationSuccess extends ChangeMutation with MutationSuccess {
  ChangeMutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeMutationSuccess.from(ChangeMutation other) =>
      ChangeMutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeMutationFailure extends ChangeMutation with MutationFailure {
  ChangeMutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
  }) : super._();

  factory ChangeMutationFailure.from(
    ChangeMutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      ChangeMutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}

typedef DemoFamilyFamilyParams = (Object key,);

extension DemoFamilyMutationExtension on DemoFamilyProvider {
  DemoFamilyFamilyParams get _params => (this.key,);

  Refreshable<ChangeFamilyMutation> get changeFamily =>
      _changeFamilyProvider(_params);
}

// Could have extras in the future when @mutationKey gets added. for now identical to the class one.
typedef _ChangeFamilyFamilyParameters = (Object key,);

final _changeFamilyProvider =
    Provider.autoDispose.family((ref, _ChangeFamilyFamilyParameters _params) {
  final notifier = ref.watch(demoFamilyProvider(
    _params.$1,
  ).notifier);
  return ChangeFamilyMutation(
    (newState) => ref.state = newState,
    notifier.changeFamily,
  );
}, dependencies: [demoFamilyProvider]);

typedef ChangeFamilySignature = Future<void> Function(int i, String? e,
    {required bool b, num n});
typedef ChangeFamilyStateSetter = void Function(ChangeFamilyMutation newState);

sealed class ChangeFamilyMutation with AsyncMutation {
  factory ChangeFamilyMutation(
    ChangeFamilyStateSetter updateState,
    ChangeFamilySignature fn,
  ) = ChangeFamilyMutationIdle._;

  ChangeFamilyMutation._(this._updateState, this._fn);

  final ChangeFamilyStateSetter _updateState;
  final ChangeFamilySignature _fn;

  Object? get error;
  StackTrace? get stackTrace;

  Future<void> call(int i, String? e, {required bool b, num n = 1}) async {
    _updateState(ChangeFamilyMutationLoading.from(this));
    try {
      await _fn(i, e, b: b, n: n);
      _updateState(ChangeFamilyMutationSuccess.from(this));
    } catch (e, s) {
      _updateState(
          ChangeFamilyMutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class ChangeFamilyMutationIdle extends ChangeFamilyMutation
    with MutationIdle {
  ChangeFamilyMutationIdle._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeFamilyMutationIdle.from(ChangeFamilyMutation other) =>
      ChangeFamilyMutationIdle._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeFamilyMutationLoading extends ChangeFamilyMutation
    with MutationLoading {
  ChangeFamilyMutationLoading._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeFamilyMutationLoading.from(ChangeFamilyMutation other) =>
      ChangeFamilyMutationLoading._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeFamilyMutationSuccess extends ChangeFamilyMutation
    with MutationSuccess {
  ChangeFamilyMutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory ChangeFamilyMutationSuccess.from(ChangeFamilyMutation other) =>
      ChangeFamilyMutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class ChangeFamilyMutationFailure extends ChangeFamilyMutation
    with MutationFailure {
  ChangeFamilyMutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
  }) : super._();

  factory ChangeFamilyMutationFailure.from(
    ChangeFamilyMutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      ChangeFamilyMutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}

final loginProvider = Provider.autoDispose((ref) {
  return LoginMutation(
    (newState) => ref.state = newState,
    login,
  );
});

typedef LoginSignature = Future<String> Function(
    String username, String password);
typedef LoginStateSetter = void Function(LoginMutation newState);

sealed class LoginMutation with AsyncMutation {
  factory LoginMutation(
    LoginStateSetter updateState,
    LoginSignature fn,
  ) = LoginMutationIdle._;

  LoginMutation._(this._updateState, this._fn);

  final LoginStateSetter _updateState;
  final LoginSignature _fn;

  Object? get error;
  StackTrace? get stackTrace;

  String? get result;

  Future<void> call(String username, String password) async {
    _updateState(LoginMutationLoading.from(this));
    try {
      final res = await _fn(username, password);
      _updateState(LoginMutationSuccess.from(this, res));
    } catch (e, s) {
      _updateState(LoginMutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class LoginMutationIdle extends LoginMutation with MutationIdle {
  LoginMutationIdle._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
    this.result,
  }) : super._();

  factory LoginMutationIdle.from(LoginMutation other) => LoginMutationIdle._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
        result: other.result,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  final String? result;
}

final class LoginMutationLoading extends LoginMutation with MutationLoading {
  LoginMutationLoading._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
    this.result,
  }) : super._();

  factory LoginMutationLoading.from(LoginMutation other) =>
      LoginMutationLoading._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
        result: other.result,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  final String? result;
}

final class LoginMutationSuccess extends LoginMutation with MutationSuccess {
  LoginMutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
    required this.result,
  }) : super._();

  factory LoginMutationSuccess.from(LoginMutation other, String result) =>
      LoginMutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
        result: result,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;

  final String result;
}

final class LoginMutationFailure extends LoginMutation with MutationFailure {
  LoginMutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
    this.result,
  }) : super._();

  factory LoginMutationFailure.from(
    LoginMutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      LoginMutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
        result: other.result,
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;

  final String? result;
}
