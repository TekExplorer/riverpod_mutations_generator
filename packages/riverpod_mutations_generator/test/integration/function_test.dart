import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'function_test.g.dart';

@mutationPair
Future<String> _getSomething(String id, @mutationKey String key) async {
  getSomething(key)
      .check<
        String,
        Future<String> Function(MutationTarget target, String id),
        Future<String> Function(String id)
      >();
  return 'result';
}

@mutationPair
Future<bool> _usesRef(MutationTransaction ref) async {
  usesRef
      .check<
        bool,
        Future<bool> Function(MutationTarget target),
        Future<bool> Function()
      >();
  return true;
}
