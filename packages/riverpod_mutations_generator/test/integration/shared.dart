import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

extension MutationListenableCheck<ResultT, RunT>
    on MutationListenable<ResultT, RunT> {
  // void checkResult<T extends ResultT>() {}
  // void checkRun<T extends RunT>() {}
  // void checkPair<T extends PairRunT>() {}
  void check<ResultC extends ResultT, RunC extends RunT>() {}
}

extension MutationPairListenableCheck<ResultT, RunT, PairRunT>
    on MutationPairListenable<ResultT, RunT, PairRunT> {
  // void checkResult<T extends ResultT>() {}
  // void checkRun<T extends RunT>() {}
  // void checkPair<T extends PairRunT>() {}
  void check<
    ResultC extends ResultT,
    RunC extends RunT,
    PairRunC extends PairRunT
  >() {}
}
