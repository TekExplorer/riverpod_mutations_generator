import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'function_test.g.dart';

@mutation
Future<String> _getSomething(String id, @mutationKey String key) async {
  final provider = getSomething(key);
  runCheck<Future<String> Function(MutationTarget, String)>(provider.run);
  pairCheck<Future<String> Function(String)>(provider.pair);
  return 'result';
}

@mutation
Future<bool> _usesRef(MutationTransaction ref) async {
  final provider = usesRef;
  runCheck<Future<bool> Function(MutationTarget)>(provider.run);
  pairCheck<Future<bool> Function()>(provider.pair);
  return true;
}
