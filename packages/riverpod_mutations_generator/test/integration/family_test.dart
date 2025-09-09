import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'family_test.g.dart';

@riverpod
class DemoFamily extends _$DemoFamily {
  @override
  FutureOr<int> build(bool key) => 0;

  DemoFamilyProvider get provider => demoFamilyProvider(key);

  @mutation
  Future<void> changeFamily(
    int i,
    String? e, {
    required bool b,
    num n = 1,
  }) async {
    runCheck<
      Future<void> Function(
        MutationTarget,
        int i,
        String? e, {
        required bool b,
        num n,
      })
    >(provider.changeFamily.run);
    pairCheck<
      Future<void> Function(int i, String? e, {required bool b, num n})
    >(provider.changeFamily.pair);
  }
}
