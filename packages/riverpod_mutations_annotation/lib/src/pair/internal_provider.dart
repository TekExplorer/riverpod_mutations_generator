import 'package:meta/meta.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

@internal
final class $MutationPairProxy<R, F>
    with
        SyncProviderTransformerMixin<(ProviderContainer, MutationState<R>),
            (MutationState<R>, F)> {
  $MutationPairProxy(this.mutation, this.fn);

  final Mutation<R> mutation;
  final F Function(MutationTarget target) fn;

  @override
  late final source = Provider.autoDispose((ref) {
    return (ref.container, ref.watch(mutation));
  });

  // TODO: there is no access to the container in the context, so this is a workaround
  @override
  transform(context) => ProviderTransformer(
        initState: (self) {
          final (container, mutationState) = context.sourceState.requireValue;
          return (mutationState, fn(container));
        },
        listener: (self, prev, next) {
          final (_, prevMutationState) = prev.requireValue;
          final (container, nextMutationState) = next.requireValue;
          if (prevMutationState != nextMutationState) {
            self.state = AsyncData((nextMutationState, fn(container)));
          }
        },
      );

  @override
  operator ==(Object other) {
    return other is $MutationPairProxy<R, F> && other.mutation == mutation;
  }

  @override
  int get hashCode => mutation.hashCode;
}
