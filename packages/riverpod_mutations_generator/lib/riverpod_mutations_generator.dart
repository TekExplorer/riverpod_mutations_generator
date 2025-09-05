import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/riverpod_mutations_generator.dart';

/// Builds generators for `build_runner` to run
Builder riverpodMutationsBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    const [RiverpodMutationsGenerator()],
    'riverpod_mutations',
    allowSyntaxErrors: true,
  );
}
