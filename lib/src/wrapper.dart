import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef MutationWrapper<R, F extends Function> = (
  MutationState<R> state,
  F run
);

extension MutationWrapperX<R, F extends Function> on MutationWrapper<R, F> {
  MutationState<R> get state => $1;
  F get run => $2;
}

extension MutationListenableX<R, F extends Function>
    on MutationListenable<R, F> {
  ProviderListenable<MutationState<R>> get state =>
      select((value) => value.state);
  ProviderListenable<F> get run => select((value) => value.run);
  void reset(MutationTarget target) => mutation.reset(target);
}

abstract final class MutationListenable<R, F extends Function>
    implements ProviderListenable<MutationWrapper<R, F>> {
  factory MutationListenable(
    MutationWrapper<R, F> Function(Ref, Mutation<R>) create,
    Record keys, {
    Object? label,
  }) = _MutationListenable;

  Mutation<R> get mutation;
}

final class _MutationListenable<R, F extends Function>
    with
        SyncProviderTransformerMixin<MutationWrapper<R, F>,
            MutationWrapper<R, F>>
    implements
        MutationListenable<R, F> {
  _MutationListenable(this.create, this.keys, {this.label});

  @override
  late final mutation = Mutation<R>(label: label)(keys);
  final Object keys;
  final Object? label;
  final MutationWrapper<R, F> Function(Ref, Mutation<R>) create;

  // TODO: If we can get access to a reader in [transform]
  //  then we can point this at [Mutation] directly
  @override
  ProviderListenable<MutationWrapper<R, F>> get source =>
      Provider((ref) => create(ref, mutation));

  @override
  ProviderTransformer<MutationWrapper<R, F>, MutationWrapper<R, F>> transform(
      ProviderTransformerContext<MutationWrapper<R, F>, MutationWrapper<R, F>>
          context) {
    return ProviderTransformer(
      initState: (self) => context.sourceState.requireValue,
      listener: (self, prev, next) {
        switch (next) {
          case AsyncError():
            self.state = next;
          case AsyncData(value: (final state, final run))
              when state != prev.value?.state:
            self.state = AsyncData((state, prev.value?.run ?? run));
          case AsyncData():
            break;
        }
      },
    );
  }

  @override
  String toString() {
    return '''MutationListenable<$R, $F>(
  $mutation
)''';
  }
}
