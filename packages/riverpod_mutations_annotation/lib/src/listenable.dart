import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';

import 'internal_provider.dart';

sealed class MutationListenable<ResultT, RunT, PairRunT>
    implements ProviderListenable<MutationState<ResultT>> {
  factory MutationListenable(
    Mutation<ResultT> mutation,
    RunT run,
    PairRunT Function(MutationTarget target) pair,
  ) = _MutationListenable;

  void reset(MutationTarget target);

  ProviderListenable<(MutationState<ResultT>, PairRunT)> get pair;
  RunT get run;
}

final class _MutationListenable<ResultT, RunT, PairRunT>
    with
        SyncProviderTransformerMixin<MutationState<ResultT>,
            MutationState<ResultT>>
    implements
        MutationListenable<ResultT, RunT, PairRunT> {
  _MutationListenable(
    this.mutation,
    this.run,
    this._pair,
  );

  final Mutation<ResultT> mutation;

  @override
  void reset(MutationTarget target) => mutation.reset(target);

  @internal
  @override
  ProviderListenable<MutationState<ResultT>> get source => mutation;

  @override
  transform(context) {
    return ProviderTransformer(
      initState: (self) => context.sourceState.requireValue,
      listener: (self, prev, next) => self.state = next,
    );
  }

//
  @override
  final RunT run;

//
  final PairRunT Function(MutationTarget target) _pair;

  @override
  ProviderListenable<(MutationState<ResultT>, PairRunT)> get pair =>
      $proxyMutationPair<ResultT, PairRunT>(mutation, _pair);

  //

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _MutationListenable<ResultT, RunT, PairRunT> &&
        other.mutation == mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}
