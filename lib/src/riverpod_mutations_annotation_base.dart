// DO NOT MOVE/RENAME

import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

@Target({TargetKind.method})
@sealed
final class Mutation {
  const Mutation({
    this.keepAlive = false,
    this.dependencies,
  });

  final bool keepAlive;

  final List<Object>? dependencies;
}

@Target({TargetKind.method})
const mutation = Mutation();
