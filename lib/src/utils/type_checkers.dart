import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:source_gen/source_gen.dart';

const riverpodTypeChecker = TypeChecker.typeNamed(
  Riverpod,
  inPackage: 'riverpod_annotation',
);

const mutationTypeChecker = TypeChecker.fromUrl('$_annotation#_Mutation');
const mutationKeyTypeChecker = TypeChecker.fromUrl('$_annotation#_MutationKey');
const _annotation =
    'package:riverpod_mutations_annotation/src/annotations.dart';
