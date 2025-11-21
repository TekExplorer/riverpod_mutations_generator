import 'utils/type_checker.dart';

const riverpodTypeChecker = TypeChecker.typeNamed(
  'Riverpod',
  inPackage: 'riverpod_annotation',
);

const mutationTransactionTypeChecker = TypeChecker.typeNamed(
  'MutationTransaction',
  inPackage: 'riverpod',
);

const anyNotifierTypeChecker = TypeChecker.typeNamed(
  'AnyNotifier',
  inPackage: 'riverpod',
);

const mutationTypeChecker = TypeChecker.typeNamed(
  r'_Mutation',
  inPackage: 'riverpod_mutations_annotation',
);

const mutationKeyTypeChecker = TypeChecker.typeNamed(
  '_MutationKey',
  inPackage: 'riverpod_mutations_annotation',
);
