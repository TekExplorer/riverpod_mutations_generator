// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
part of 'mut.dart';

// MutProvider(
//   (ref) => (int i) => ref.mutate(() => i),
//   mutKeys: (),
//   notifierKeys: (),
// );

typedef MutCreate<State, Action extends Function> = Action Function(
    MutRef<State>);

class MutNotifier<State, Action extends Function>
    extends AutoDisposeNotifier<MutAction<State, Action>> {
  MutNotifier(this.create);

  final MutCreate<State, Action> create;

  @override
  build() => (Mut.idle, create(MutRef(this)));

  Action get run => state.action;

  void mutate(FutureOr<State> Function() fn) {
    switch (Mut.guardSync(fn)) {
      case final MutError mut:
        set(mut);
      case MutSuccess(:final State result):
        set(MutSuccess(result));
      case MutSuccess(:final Future<State> result):
        bool didDispose = false;
        // ignore: invalid_use_of_protected_member
        ref.onDispose(() => didDispose = true);

        // see if there's a better way to detect sync futures
        bool didSetValue = false;
        result.then((v) {
          if (didDispose) return;
          didSetValue = true;
          set(MutSuccess(v));
        }).onError<Object>((e, s) {
          if (didDispose) return;
          didSetValue = true;
          set(MutError(e, s));
        });

        if (!didSetValue) setLoading();
    }
  }

  void set(Mut<State> newState) => state = state.withState(newState);
  void setLoading() {
    if (state.state.isLoading) return;
    set(state.state.toLoading());
  }
}

final class MutProviderImpl<State, Action extends Function>
    extends AutoDisposeNotifierProvider<MutNotifier<State, Action>,
        MutAction<State, Action>> {
  /// Creates a [Provider] that exposes a [Mut] object.
  MutProviderImpl(
    MutCreate<State, Action> create, {
    required Record keys,
    required Object method,
    ProviderBase? source,
  }) : this.internal(
          () => MutNotifier(create),
          from: null,
          name: r'mutProvider',
          debugGetCreateSourceHash: null,
          dependencies: source != null ? [source] : null,
          allTransitiveDependencies: [
            if (source != null) source,
            ...?source?.allTransitiveDependencies
          ],
          keys: keys,
          source: source,
          method: method,
        );

  MutProviderImpl.internal(
    super.createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keys,
    required this.source,
    required this.method,
  }) : super.internal(
          argument: (
            source: source,
            method: method,
            keys: keys,
          ),
        );

  final Record keys;
  final Object method;
  final ProviderBase<Object?>? source;

  @override
  Override overrideWith(create) {
    return ProviderOverride(
      origin: this,
      override: MutProviderImpl<State, Action>.internal(
        create,
        from: null,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keys: keys,
        source: source,
        method: method,
      ),
    );
  }

  @override
  runNotifierBuild(covariant MutNotifier<State, Action> notifier) =>
      notifier.build();

  late final state = select((value) => value.state);
}

extension type MutProvider<State, Action extends Function>.of(
        MutProviderImpl<State, Action> _)
    implements ProviderBase<MutAction<State, Action>> {
  //
  MutProvider(
    MutCreate<State, Action> create, {
    required Record keys,
    required Object method,
    ProviderBase? source,
  }) : this.of(MutProviderImpl(
          create,
          keys: keys,
          method: method,
        ));

  ProviderListenable<Mut<State>> get state => _.state;
}
