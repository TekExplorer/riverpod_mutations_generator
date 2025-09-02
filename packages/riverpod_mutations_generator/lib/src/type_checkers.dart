import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:source_gen/source_gen.dart';

// ignore: deprecated_member_use
const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);
// ignore: deprecated_member_use
const mutationRefTypeChecker = TypeChecker.fromRuntime(MutationRef);

const mutationTypeChecker = TypeChecker.fromUrl('$_annotation#_Mutation');
const mutationKeyTypeChecker = TypeChecker.fromUrl('$_annotation#_MutationKey');
const _annotation =
    'package:riverpod_mutations_annotation/src/annotations.dart';
