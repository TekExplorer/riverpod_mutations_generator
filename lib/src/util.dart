import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:source_gen/source_gen.dart';

const mutationKeyTypeChecker = TypeChecker.fromRuntime(MutationKey);
const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);
const mutationTypeChecker = TypeChecker.fromRuntime(Mutation);
