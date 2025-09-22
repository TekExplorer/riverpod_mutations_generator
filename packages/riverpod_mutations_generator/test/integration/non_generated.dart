// non generated test
import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'non_generated.g.dart';

final demoFamily2Provider = AsyncNotifierProvider.family(DemoFamily2.new);

class DemoFamily2 extends AsyncNotifier<int> {
  DemoFamily2(this.key);
  final bool key;

  @override
  FutureOr<int> build() => 0;

  AsyncNotifierProvider<DemoFamily2, int> get provider =>
      demoFamily2Provider(key);

  @mutation
  Future<void> changeFamily(
    int i,
    String? e, {
    required bool b,
    num n = 1,
  }) async {
    provider.changeFamily
        .check<
          void,
          Future<void> Function(
            MutationTarget,
            int i,
            String? e, {
            required bool b,
            num n,
          }),
          Future<void> Function(int i, String? e, {required bool b, num n})
        >();
  }
}
