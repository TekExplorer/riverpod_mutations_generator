import 'dart:async' as async;
import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart'
    show DartFormatter, FormatterException;
import 'package:pub_semver/pub_semver.dart' show Version;
import 'package:source_gen/source_gen.dart';

import 'src/riverpod_mutations_generator.dart';

/// Builds generators for `build_runner` to run
Builder riverpodMutationsBuilder(
  BuilderOptions options, {
  String Function(String, Version) formatOutput = _formatOutput,
}) {
  return SharedPartBuilder(
    [RiverpodMutationsGenerator(GeneratorConfig.fromJson(options.config))],
    'riverpod_mutations',
    allowSyntaxErrors: true,
    formatOutput: formatOutput,
  );
}

String _formatOutput(String code, Version version) {
  try {
    return DartFormatter(languageVersion: version).format(code);
  } on FormatterException catch (e) {
    print('FormatterException: $e');
    return '''
/*
  unformatted due to $e
*/
$code
'''
        .trim();
  }
}

final class GeneratorConfig {
  GeneratorConfig.fromJson(Map<String, Object?> json)
    : this(withPair: json['with_pair'] as bool?);

  const GeneratorConfig({this.withPair});

  final bool? withPair;

  T runZoned<T>(T Function() fn) =>
      async.runZoned(fn, zoneValues: {GeneratorConfig: this});

  static GeneratorConfig get current =>
      Zone.current[GeneratorConfig] as GeneratorConfig? ??
      const GeneratorConfig();

  @override
  String toString() => 'GeneratorConfig(withPair: $withPair)';
}

class MutationAnnotation {
  factory MutationAnnotation.from({
    DartObject? annotation,
    GeneratorConfig? config,
  }) {
    return MutationAnnotation.merge([
      MutationAnnotation.fromMetadata(annotation),
      MutationAnnotation.fromConfig(config),
    ]);
  }

  MutationAnnotation.fromMetadata(DartObject? annotation)
    : withPair = annotation?.getField('withPair')?.toBoolValue();

  MutationAnnotation.fromConfig([GeneratorConfig? config])
    : withPair = (config ?? GeneratorConfig.current).withPair;

  factory MutationAnnotation.merge(Iterable<MutationAnnotation> annotations) {
    return annotations.reduce((value, element) {
      return MutationAnnotation(withPair: value.withPair ?? element.withPair);
    });
  }

  MutationAnnotation({this.withPair});

  final bool? withPair;

  @override
  String toString() {
    return 'MutationAnnotation(withPair: $withPair)';
  }
}
