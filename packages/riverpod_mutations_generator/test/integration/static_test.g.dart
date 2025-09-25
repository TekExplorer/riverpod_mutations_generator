// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'static_test.dart';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

MutationListenable<
  void,
  Future<void> Function(MutationTarget target),
  Future<void> Function()
>
get _$Static_test {
  final mutation = $Mutations.ofFunction<void>(Static._test, 'Static._test');
  Future<void> run(MutationTarget target) {
    return mutation.run(target, (tsx) {
      return Static._test();
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        () => run(target),
  );
}

MutationListenable<
  String,
  Future<String> Function(MutationTarget target, String id),
  Future<String> Function(String id)
>
_$Static_test2(String key) {
  final mutation = $Mutations.ofFunction<String>(
    Static._test2,
    'Static._test2',
    (key),
  );
  Future<String> run(MutationTarget target, String id) {
    return mutation.run(target, (tsx) {
      return Static._test2(id, key);
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        (String id) => run(target, id),
  );
}

MutationListenable<
  void,
  Future<void> Function(MutationTarget target),
  Future<void> Function()
>
get _$Extension_test {
  final mutation = $Mutations.ofFunction<void>(
    Extension._test,
    'Extension._test',
  );
  Future<void> run(MutationTarget target) {
    return mutation.run(target, (tsx) {
      return Extension._test();
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        () => run(target),
  );
}

MutationListenable<
  String,
  Future<String> Function(MutationTarget target, String id),
  Future<String> Function(String id)
>
_$Extension_test2(String key) {
  final mutation = $Mutations.ofFunction<String>(
    Extension._test2,
    'Extension._test2',
    (key),
  );
  Future<String> run(MutationTarget target, String id) {
    return mutation.run(target, (tsx) {
      return Extension._test2(id, key);
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        (String id) => run(target, id),
  );
}

MutationListenable<
  void,
  Future<void> Function(MutationTarget target),
  Future<void> Function()
>
get _$ExtensionType_test {
  final mutation = $Mutations.ofFunction<void>(
    ExtensionType._test,
    'ExtensionType._test',
  );
  Future<void> run(MutationTarget target) {
    return mutation.run(target, (tsx) {
      return ExtensionType._test();
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        () => run(target),
  );
}

MutationListenable<
  String,
  Future<String> Function(MutationTarget target, String id),
  Future<String> Function(String id)
>
_$ExtensionType_test2(String key) {
  final mutation = $Mutations.ofFunction<String>(
    ExtensionType._test2,
    'ExtensionType._test2',
    (key),
  );
  Future<String> run(MutationTarget target, String id) {
    return mutation.run(target, (tsx) {
      return ExtensionType._test2(id, key);
    });
  }

  return MutationListenable(
    mutation,
    run,
    (MutationTarget target) =>
        (String id) => run(target, id),
  );
}
