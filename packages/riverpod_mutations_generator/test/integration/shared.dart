import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

extension MutationListenableCheck<ResultT, RunT, PairRunT>
    on MutationListenable<ResultT, RunT, PairRunT> {
  // void checkResult<T extends ResultT>() {}
  // void checkRun<T extends RunT>() {}
  // void checkPair<T extends PairRunT>() {}
  void check<
    ResultC extends ResultT,
    RunC extends RunT,
    PairRunC extends PairRunT
  >() {}
}
