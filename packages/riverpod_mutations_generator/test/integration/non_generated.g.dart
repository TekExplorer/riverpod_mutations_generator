// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'non_generated.dart';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

extension DemoFamily2Mutations
    on $ClassProvider<DemoFamily2, dynamic, dynamic, dynamic> {
  MutationListenable<
    void,
    Future<void> Function(
      MutationTarget target,
      int i,
      String? e, {
      required bool b,
      num n,
    }),
    Future<void> Function(int i, String? e, {required bool b, num n})
  >
  get changeFamily {
    final mutation = $Mutations.getForProvider<void>(this, 'changeFamily');
    Future<void> run(
      MutationTarget target,
      int i,
      String? e, {
      required bool b,
      num n = 1,
    }) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).changeFamily(i, e, b: b, n: n);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target, int i, String? e, {required bool b, num n = 1}) =>
          run(target, i, e, b: b, n: n),
      (MutationTarget target) =>
          (int i, String? e, {required bool b, num n = 1}) =>
              run(target, i, e, b: b, n: n),
    );
  }
}
