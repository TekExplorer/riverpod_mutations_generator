import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

extension TypeChecker on AnyNotifier {
  void c<F>(F fn) {}
  void c2<F>(ProviderListenable<(MutationState, F)> listenable) {}
}
