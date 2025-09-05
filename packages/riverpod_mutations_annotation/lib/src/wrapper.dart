import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/misc.dart';

// ignore: must_be_immutable
abstract base class MutationListenable<R>
    with SyncProviderTransformerMixin<MutationState<R>, MutationState<R>> {
  MutationListenable(this.mutation);

  void reset(MutationTarget target) => mutation.reset(target);

  @protected
  final Mutation<R> mutation;

  @internal
  @override
  ProviderListenable<MutationState<R>> get source => mutation;

  @internal
  @override
  ProviderTransformer<MutationState<R>, MutationState<R>> transform(
      ProviderTransformerContext<MutationState<R>, MutationState<R>> context) {
    return ProviderTransformer(
      initState: (self) => context.sourceState.requireValue,
      listener: (self, prev, next) => self.state = next,
    );
  }

  @override
  String toString() {
    return '''MutationListenable<$R>(
  $mutation
)''';
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MutationListenable<R> && other.mutation == mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}
