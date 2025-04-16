// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

part of 'mut.dart';

@optionalTypeArgs
class MutRef<State extends Object?> implements Ref<Mut<State>> {
  MutRef(this._notifier);

  void mutate(FutureOr<State> Function() fn) => _notifier.mutate(fn);

  final MutNotifier<State, Function> _notifier;

  Mut<State> get state => _notifier.state.state;
  set state(Mut<State> newState) => _notifier.set(newState);

  void setLoading() => _notifier.setLoading();
  void setNotLoading() => state = state.toNotLoading();

  @override
  void listenSelf(
    void Function(Mut<State>? previous, Mut<State> next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      _notifier.listenSelf(
        (previous, next) => listener(previous?.state, next.state),
        onError: onError,
      );

  @override
  ProviderContainer get container => _notifier.ref.container;
  @override
  bool exists(ProviderBase<Object?> provider) => _notifier.ref.exists(provider);
  @override
  void invalidate(ProviderOrFamily provider) =>
      _notifier.ref.invalidate(provider);
  @override
  void invalidateSelf() => _notifier.ref.invalidateSelf();
  @override
  KeepAliveLink keepAlive() => _notifier.ref.keepAlive();

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    void Function(T? previous, T next) listener, {
    bool fireImmediately = false,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) =>
      _notifier.ref.listen(
        provider,
        listener,
        fireImmediately: fireImmediately,
        onError: onError,
      );

  @override
  void notifyListeners() => _notifier.ref.notifyListeners();
  @override
  void onAddListener(void Function() cb) => _notifier.ref.onAddListener(cb);
  @override
  void onCancel(void Function() cb) => _notifier.ref.onCancel(cb);
  @override
  void onDispose(void Function() cb) => _notifier.ref.onDispose(cb);
  @override
  void onRemoveListener(void Function() cb) =>
      _notifier.ref.onRemoveListener(cb);
  @override
  void onResume(void Function() cb) => _notifier.ref.onResume(cb);
  @override
  T read<T>(ProviderListenable<T> provider) => _notifier.ref.read(provider);
  @override
  T refresh<T>(Refreshable<T> provider) => _notifier.ref.refresh(provider);
  @override
  T watch<T>(ProviderListenable<T> provider) => _notifier.ref.watch(provider);
}
