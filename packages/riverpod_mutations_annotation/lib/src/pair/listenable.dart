import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod_mutations_annotation/src/listenable.dart';

import 'internal_provider.dart';

extension MutationListenableX<ResultT, RunT>
    on MutationListenable<ResultT, RunT> {
  @internal
  MutationPairListenable<ResultT, RunT, PairRunT> $withPair<PairRunT>(
    PairRunT Function(MutationTarget target) pair,
  ) {
    return MutationPairListenable<ResultT, RunT, PairRunT>(this, pair);
  }
}

abstract class MutationPairListenable<ResultT, RunT, PairRunT>
    implements MutationListenable<ResultT, RunT> {
  factory MutationPairListenable(
    MutationListenable<ResultT, RunT> listenable,
    PairRunT Function(MutationTarget target) pair,
  ) = _MutationPairListenable;

  @override
  void reset(MutationTarget target);

  ProviderListenable<(MutationState<ResultT>, PairRunT)> get pair;
  @override
  RunT get run;
}

final class _MutationPairListenable<ResultT, RunT, PairRunT>
    with
        SyncProviderTransformerMixin<MutationState<ResultT>,
            MutationState<ResultT>>
    implements
        MutationPairListenable<ResultT, RunT, PairRunT> {
  _MutationPairListenable(
    this.listenable,
    this._pair,
  );
  final MutationListenable<ResultT, RunT> listenable;

  @override
  Mutation<ResultT> get mutation => listenable.mutation;

  @override
  void reset(MutationTarget target) => mutation.reset(target);

  @internal
  @override
  ProviderListenable<MutationState<ResultT>> get source => mutation;

  @override
  RunT get run => listenable.run;

//
  final PairRunT Function(MutationTarget target) _pair;

  @override
  ProviderListenable<(MutationState<ResultT>, PairRunT)> get pair =>
      $proxyMutationPair<ResultT, PairRunT>(mutation, _pair);

  //
  @override
  transform(context) {
    return ProviderTransformer(
      initState: (self) => context.sourceState.requireValue,
      listener: (self, prev, next) => self.state = next,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _MutationPairListenable<ResultT, RunT, PairRunT> &&
        other.mutation == mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}
