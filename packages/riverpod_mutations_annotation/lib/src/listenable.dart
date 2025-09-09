import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod_mutations_annotation/src/mutations_store.dart';

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

Future<String> doSomething(MutationRef ref, String input) async {
  await Future.delayed(const Duration(seconds: 1));
  return 'Result: $input';
}

MutationListenable<String, Future<void> Function(MutationTarget target),
    Future<void> Function()> doSomethingMutation(String input) {
  final mutation =
      $Mutations.getForFunction<String>(doSomething, 'doSomething');

  Future<void> run(MutationTarget target) {
    return mutation.run(target, (tsx) {
      return doSomething(tsx, input);
    });
  }

  return MutationListenable(
    mutation,
    (MutationTarget target) => run(target),
    (MutationTarget target) => () => run(target),
  );
}
