// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_test.dart';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

MutationPairListenable<
  String,
  Future<String> Function(MutationTarget _$target, String id),
  Future<String> Function(String id)
>
getSomething(String key) {
  final _$mutation = $Mutations.ofFunction<String>(
    _getSomething,
    '_getSomething',
    (key),
  );
  Future<String> _$run(MutationTarget _$target, String id) {
    return _$mutation.run(_$target, (_$tsx) {
      return _getSomething(id, key);
    });
  }

  return MutationListenable(_$mutation, _$run).$withPair(
    (MutationTarget _$target) =>
        (String id) => _$run(_$target, id),
  );
}

MutationPairListenable<
  bool,
  Future<bool> Function(MutationTarget _$target),
  Future<bool> Function()
>
get usesRef {
  final _$mutation = $Mutations.ofFunction<bool>(_usesRef, '_usesRef');
  Future<bool> _$run(MutationTarget _$target) {
    return _$mutation.run(_$target, (_$tsx) {
      return _usesRef(_$tsx);
    });
  }

  return MutationListenable(_$mutation, _$run).$withPair(
    (MutationTarget _$target) =>
        () => _$run(_$target),
  );
}
