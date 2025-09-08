// ignore_for_file: invalid_use_of_internal_member

import 'package:meta/meta.dart';
import 'package:riverpod/experimental/mutation.dart' show Mutation;
import 'package:riverpod_annotation/riverpod_annotation.dart'
    show $ClassProvider;

/// This class serves as a store for all mutations.
///
/// There is no need to clear or reset the mutations store,
/// as its contents are just keys.
///
/// This ensures that each mutation object references the same mutation it did prior
///
/// This this primarily exists due to generics being impossible to work with
/// for families.
///
/// If not for that, each mutation would have an accompanying family provider
@internal
abstract final class $Mutations {
  static final _mutations = <Object, Mutation>{};

  @internal
  @useResult
  static Mutation<T> getForProvider<T>(
    $ClassProvider provider,
    String mutationName, [
    Object? key,
  ]) {
    key = key != null
        ? (T, provider, mutationName, key)
        : (T, provider, mutationName);

    return _mutations.putIfAbsent(
      key,
      () => Mutation<T>(label: '$provider.$mutationName')(key),
    ) as Mutation<T>;
  }

  // static Iterable<Mutation> getAll() => _mutations.values;
  // static void clear() => _mutations.clear();
}
