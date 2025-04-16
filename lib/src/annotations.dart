import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@Target({TargetKind.method, TargetKind.function})
final class Mutation {
  const Mutation();
}

const mutation = Mutation();
// const mut = mutation;

@experimental
@Target({TargetKind.parameter})
final class MutationKey {
  const MutationKey();
}

@experimental
const mutationKey = MutationKey();
// @experimental
// const mutKey = mutationKey;
