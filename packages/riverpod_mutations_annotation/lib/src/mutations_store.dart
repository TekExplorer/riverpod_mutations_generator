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
  static final _mutations = <(Type, Object), Mutation>{};
  static Mutation<T> _putIfAbsent<T>({
    required Object key,
    required Mutation<T> Function() ifAbsent,
  }) =>
      _mutations.putIfAbsent((T, key), ifAbsent) as Mutation<T>;

  static Mutation<T> get<T>(String label, Object key) => _putIfAbsent<T>(
        key: key,
        ifAbsent: () => Mutation<T>(label: label)(key),
      );

  @internal
  @useResult
  static Mutation<T> getForProvider<T>(
    $ClassProvider provider,
    String mutationName, [
    Object? key,
  ]) =>
      get<T>(
        '$provider.$mutationName',
        _key(provider, mutationName, key),
      );

  @internal
  @useResult
  static Mutation<T> getForFunction<T>(
    Object function,
    String functionName, [
    Object? key,
  ]) =>
      get<T>(
        functionName,
        _key(function, functionName, key),
      );

  // static Iterable<Mutation> getAll() => _mutations.values;
  // static void clear() => _mutations.clear();
}

Record _key(Object first, Object second, Object? third) =>
    third == null ? (first, second) : (first, second, third);
