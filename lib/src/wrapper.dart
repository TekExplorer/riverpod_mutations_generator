import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../riverpod_mutations_annotation.dart' show $Mutations;

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
    Mutation<R> mutation,
  ) = _MutationListenable;

  factory MutationListenable.create(
    MutationWrapper<R, F> Function(Ref, Mutation<R>) create,
    // ignore: invalid_use_of_internal_member
    ($ClassProvider provider, String mutationName, Object parameters) keys,
  ) {
    final (provider, mutationName, parameters) = keys;
    var mutation = $Mutations.getForProvider<R>(provider, mutationName);
    if (parameters != ()) mutation = mutation(parameters);
    return MutationListenable(create, mutation);
  }

  Mutation<R> get mutation;
}

final class _MutationListenable<R, F extends Function>
    with
        SyncProviderTransformerMixin<MutationWrapper<R, F>,
            MutationWrapper<R, F>>
    implements
        MutationListenable<R, F> {
  _MutationListenable(this.create, this.mutation);

  @override
  final Mutation<R> mutation;
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
