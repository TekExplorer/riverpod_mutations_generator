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
      MutationTarget _$target,
      int i,
      String? e, {
      required bool b,
      num n,
    }),
    Future<void> Function(int i, String? e, {required bool b, num n})
  >
  get changeFamily {
    final _$mutation = $Mutations.ofProvider<void>(this, 'changeFamily');
    Future<void> _$run(
      MutationTarget _$target,
      int i,
      String? e, {
      required bool b,
      num n = 1,
    }) {
      return _$mutation.run(_$target, (_$tsx) {
        return _$tsx.get(this.notifier).changeFamily(i, e, b: b, n: n);
      });
    }

    return MutationListenable(
      _$mutation,
      _$run,
      (MutationTarget _$target) =>
          (int i, String? e, {required bool b, num n = 1}) =>
              _$run(_$target, i, e, b: b, n: n),
    );
  }
}
