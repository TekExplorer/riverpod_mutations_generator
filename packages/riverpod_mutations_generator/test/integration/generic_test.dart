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
    provider.changeGeneric
        .check<
          void,
          Future<void> Function(MutationTarget target, T value),
          Future<void> Function(T value)
        >();
  }

  @mutation
  Future<(T, R)> generic<R>() {
    provider
        .generic<R>()
        .check<
          (T, R),
          Future<(T, R)> Function(MutationTarget target),
          Future<(T, R)> Function()
        >();
    throw UnimplementedError();
  }

  @mutation
  Future<T> genericShadowed<T>() {
    provider
        .genericShadowed<T>()
        .check<
          T,
          Future<T> Function(MutationTarget target),
          Future<T> Function()
        >();
    throw UnimplementedError();
  }
}
