import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';

abstract class MutationListenable<ResultT, RunT>
    implements ProviderListenable<MutationState<ResultT>> {
  factory MutationListenable(Mutation<ResultT> mutation, RunT run) =
      _MutationListenable;

  Mutation<ResultT> get mutation;

  void reset(MutationTarget target);

  RunT get run;
}

final class _MutationListenable<ResultT, RunT>
    with
        SyncProviderTransformerMixin<MutationState<ResultT>,
            MutationState<ResultT>>
    implements
        MutationListenable<ResultT, RunT> {
  _MutationListenable(this.mutation, this.run);

  @override
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

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _MutationListenable<ResultT, RunT> &&
        other.mutation == mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}
