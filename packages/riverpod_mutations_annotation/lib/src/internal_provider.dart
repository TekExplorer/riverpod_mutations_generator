import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

part 'internal_provider.g.dart';

@internal
ProviderListenable<(MutationState<R>, F)> $proxyMutationPair<R, F>(
  Mutation<R> mutation,
  F Function(MutationTarget target) fn,
) =>
    _mutationsProvider<R, F>(mutation, Ignore(fn));

@riverpod
class _Mutations<R, F> extends _$Mutations<R, F> {
  @override
  (MutationState<R>, F) build(
    Mutation<R> mutation,
    Ignore<F Function(MutationTarget target)> fn,
  ) =>
      (
        ref.watch(mutation),
        fn.value(ref), //
      );

  @override
  bool updateShouldNotify(
    (MutationState<R>, F) previous,
    (MutationState<R>, F) next,
  ) =>
      previous.$1 != next.$1;
}

final class Ignore<T> {
  Ignore(this.value);
  final T value;

  @override
  int get hashCode => T.hashCode;

  @override
  operator ==(covariant Ignore other) => _eqT(other) && other._eqT(this);

  bool _eqT(Object other) => other is Ignore<T>;
}
