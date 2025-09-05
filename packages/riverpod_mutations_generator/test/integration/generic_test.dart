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
    c<Future<void> Function(MutationTarget, T value)>(
      provider.changeGeneric.run,
    );
    c2<Future<void> Function(T value)>(provider.changeGeneric.pair);
  }

  @mutation
  Future<(T, R)> generic<R>() {
    c<Future<(T, R)> Function(MutationTarget)>(provider.generic<R>().run);
    c2<Future<(T, R)> Function()>(provider.generic<R>().pair);
    throw UnimplementedError();
  }

  @mutation
  Future<T> genericShadowed<T>() {
    c<Future<T> Function(MutationTarget)>(provider.genericShadowed<T>().run);
    c2<Future<T> Function()>(provider.genericShadowed<T>().pair);
    throw UnimplementedError();
  }
}
