import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void runCheck<F>(F fn) {}
void pairCheck<F>(ProviderListenable<(MutationState, F)> listenable) {}
