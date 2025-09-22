/// The annotations and interfaces for riverpod_mutations_generator
// ignore_for_file: invalid_export_of_internal_element, invalid_use_of_internal_member

library;

export 'package:riverpod/experimental/mutation.dart';
export 'package:riverpod/riverpod.dart' show Provider;
export 'package:riverpod_annotation/riverpod_annotation.dart'
    show $ClassProvider;

// export 'package:riverpod_annotation/riverpod_annotation.dart';

export 'src/annotations.dart';
// export 'src/internal_provider.dart' show $proxyMutationPair;
export 'src/listenable.dart';
export 'src/mutations_store.dart';
