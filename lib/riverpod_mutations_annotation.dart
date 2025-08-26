/// The annotations and interfaces for riverpod_mutations_generator
// ignore_for_file: invalid_export_of_internal_element, invalid_use_of_internal_member

library;

import 'package:riverpod/riverpod.dart';

import '' show MutationState, ProviderListenable;

export 'package:riverpod/experimental/mutation.dart';
export 'package:riverpod/riverpod.dart' show Provider;
export 'package:riverpod_annotation/riverpod_annotation.dart'
    show ProviderListenable;

export 'src/annotations.dart';

extension MutationPairX<R, F extends Function> on (MutationState<R>, F) {
  MutationState<R> get state => $1;
  F get run => $2;
}

extension MutationProviderX<R, F extends Function>
    on ProviderListenable<(MutationState<R>, F)> {
  ProviderListenable<MutationState<R>> get state =>
      select((value) => value.state);
  ProviderListenable<F> get run => select((value) => value.run);
}
