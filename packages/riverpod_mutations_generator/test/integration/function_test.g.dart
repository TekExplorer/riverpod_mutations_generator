// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_test.dart';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

MutationListenable<
  String,
  Future<String> Function(MutationTarget target, String id),
  Future<String> Function(String id)
>
getSomething(String key) {
  final mutation = $Mutations.getForFunction<String>(
    _getSomething,
    '_getSomething',
    (key),
  );
  Future<String> run(MutationTarget target, String id) {
    return mutation.run(target, (tsx) {
      return _getSomething(id, key);
    });
  }

  return MutationListenable(
    mutation,
    (MutationTarget target, String id) => run(target, id),
    (MutationTarget target) =>
        (String id) => run(target, id),
  );
}

MutationListenable<
  bool,
  Future<bool> Function(MutationTarget target),
  Future<bool> Function()
>
get usesRef {
  final mutation = $Mutations.getForFunction<bool>(_usesRef, '_usesRef');
  Future<bool> run(MutationTarget target) {
    return mutation.run(target, (ref) {
      return _usesRef(ref);
    });
  }

  return MutationListenable(
    mutation,
    (MutationTarget target) => run(target),
    (MutationTarget target) =>
        () => run(target),
  );
}
