// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'function_test.dart';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
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
