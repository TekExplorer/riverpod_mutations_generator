import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@Target({TargetKind.method, TargetKind.function})
final class _Mutation {
  const _Mutation();
}

const mutation = _Mutation();

@experimental
@Target({TargetKind.parameter})
final class _MutationKey {
  const _MutationKey();
}

@experimental
const mutationKey = _MutationKey();
