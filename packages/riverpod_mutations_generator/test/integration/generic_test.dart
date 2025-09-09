import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'generic_test.g.dart';

@riverpod
class DemoGeneric<T> extends _$DemoGeneric<T> {
  @override
  T build() {
    throw UnimplementedError();
  }

  DemoGenericProvider<T> get provider => demoGenericProvider<T>();

  @mutation
  Future<void> changeGeneric(T value) async {
    runCheck<Future<void> Function(MutationTarget, T value)>(
      provider.changeGeneric.run,
    );
    pairCheck<Future<void> Function(T value)>(provider.changeGeneric.pair);
  }

  @mutation
  Future<(T, R)> generic<R>() {
    runCheck<Future<(T, R)> Function(MutationTarget)>(
      provider.generic<R>().run,
    );
    pairCheck<Future<(T, R)> Function()>(provider.generic<R>().pair);
    throw UnimplementedError();
  }

  @mutation
  Future<T> genericShadowed<T>() {
    runCheck<Future<T> Function(MutationTarget)>(
      provider.genericShadowed<T>().run,
    );
    pairCheck<Future<T> Function()>(provider.genericShadowed<T>().pair);
    throw UnimplementedError();
  }
}
