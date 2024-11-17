// import 'package:analyzer/dart/element/element.dart';
// import 'package:analyzer/dart/element/nullability_suffix.dart';
// import 'package:analyzer/dart/element/type.dart';
// import 'package:analyzer/src/dart/element/type.dart';
// import 'package:collection/collection.dart';
// import 'package:recase/recase.dart';
// import 'package:riverpod_mutations_generator/src/util.dart';
// import 'package:source_gen/source_gen.dart';

// String useParameterElements(
//   Iterable<ParameterElement>? parameters, [
//   String Function(ParameterElement param)? toUsage,
// ]) {
//   if (parameters == null || parameters.isEmpty) return '';
//   toUsage ??= (param) => param.name;

//   final posParams = parameters.where((element) => element.isPositional);
//   final namedParams = parameters.where((element) => element.isNamed);

//   return useParameters(
//     positional: [for (final param in posParams) toUsage(param)],
//     named: {for (final param in namedParams) param.name: toUsage(param)},
//   );
// }

// const useRecord = useParameters;
// String useParameters({
//   List<String> positional = const [],
//   Map<String, String> named = const {},
// }) {
//   if ([...positional, ...named.entries].isEmpty) return '';
//   final buffer = StringBuffer();
//   for (final param in positional) {
//     buffer.write(param);
//     buffer.write(',');
//   }
//   for (final MapEntry(:key, :value) in named.entries) {
//     buffer.write('$key: $value');
//     buffer.write(',');
//   }
//   return buffer.toString();
// }

// String defineParameters(Iterable<ParameterElement> parameters) {
//   if (parameters.isEmpty) return '';
//   parameters = parameters.whereNot((element) => element.isMutationKey);
//   final buffer = StringBuffer();

//   final posReqParams =
//       parameters.where((element) => element.isRequiredPositional);
//   for (final param in posReqParams) {
//     buffer.write(param.name);
//     buffer.write(',');
//   }
//   final posOptParams =
//       parameters.where((element) => element.isOptionalPositional);
//   if (posOptParams.isNotEmpty) {
//     buffer.write('[');
//     for (final param in posReqParams) {
//       if (param.defaultValueCode case final def?) {
//         buffer.write('${param.name} = $def');
//       } else {
//         buffer.write(param.name);
//       }
//       buffer.write(',');
//     }
//     buffer.write(']');
//   }
//   final namedParams = parameters.where((element) => element.isNamed);
//   if (namedParams.isNotEmpty) {
//     buffer.write('{');
//     for (final param in namedParams) {
//       if (param.isRequiredNamed) {
//         buffer.write('required ${param.name}');
//       } else {
//         buffer.write(param.name);
//       }
//       buffer.write(',');
//     }
//     buffer.write('}');
//   }
//   return buffer.toString();
// }

// RecordType makeRecordType({
//   List<DartType> positional = const [],
//   Map<String, DartType> named = const {},
//   NullabilitySuffix nullabilitySuffix = NullabilitySuffix.none,
// }) =>
//     RecordType(
//       positional: positional,
//       named: named,
//       nullabilitySuffix: nullabilitySuffix,
//     );

// class MutHelper {
//   static String mutForNotifier(ClassElement notifier) {
//     final annotatedMethods =
//         notifier.methods.where(mutationTypeChecker.hasAnnotationOf);

//     final List<String> extensionGetters = [];
//     final List<String> providers = [];
//     for (final mutation in annotatedMethods) {
//       final res = mutNotifier(mutation, notifier);
//       providers.add(res.generatedProviderStr);

//       final usedParameters = switch ({
//         if (res.familyArgs?.mutationKey?.params case final params?)
//           keys.mutation: useParameterElements(params),
//         if (res.familyArgs?.notifierFamily?.params case final params?)
//           keys.notifier:
//               useParameterElements(params, (param) => 'this.${param.name}'),
//       }) {
//         final namedParams when namedParams.isNotEmpty =>
//           '(${useParameters(named: namedParams)})',
//         _ => '',
//       };

//       final name = mutation.name.replaceAll('_', '');
//       extensionGetters.add([
//         'Refreshable<${res.mutActionTypeStr}> ',
//         switch (res.familyArgs?.mutationKey?.params) {
//           null => 'get $name',
//           final params => '${name}(${defineParameters(params)})',
//         },
//         ' => ${res.providerName}$usedParameters',
//       ].join());
//     }

//     final buildMethod = notifier.getMethod('build')!;
//     final isFamily = buildMethod.parameters.isNotEmpty;
//     final isAsync = buildMethod.returnType.isAsync;
//     DartType stateType = buildMethod.returnType;
//     if (isAsync) {
//       stateType as InterfaceType;
//       stateType = stateType.typeArguments.first;
//     }
//     final String providerString = switch (isFamily) {
//       true => '${notifier.name}Provider',
//       false when isAsync =>
//         'AutoDisposeAsyncNotifierProvider<${notifier.name}, $stateType>',
//       false => 'AutoDisposeNotifierProvider<${notifier.name}, $stateType>',
//     };

//     final buffer = StringBuffer();
//     buffer
//         .writeln('extension ${notifier.name}MutationsExt on $providerString {');
//     for (final getter in extensionGetters) {
//       buffer.writeln(getter);
//     }
//     buffer.writeln('}');
//     for (final provider in providers) {
//       buffer.writeln(provider);
//     }
//     return buffer.toString();
//   }

//   static const keys = (
//     mutation: 'mutationKey',
//     notifier: 'notifierKey',
//   );

//   static ({
//     ({
//       ({RecordType argsType, List<ParameterElement> params})? mutationKey,
//       ({RecordType argsType, List<ParameterElement> params})? notifierFamily
//     })? familyArgs,
//     String generatedProviderStr,
//     String mutActionTypeStr,
//     String providerName,
//     DartType resultType
//   }) mutNotifier(ExecutableElement mutation, [ClassElement? notifier]) {
//     // // final notifier = executable.enclosingElement as ClassElement;
//     // final notifier = switch (mutation.enclosingElement) {
//     //   final ClassElement notifier => notifier,
//     //   _ => null,
//     // };
//     final buildMethod = notifier?.getMethod('build');

//     DartType resultType = mutation.returnType;
//     if (resultType.isDartAsyncFuture || resultType.isDartAsyncFutureOr) {
//       resultType as InterfaceType;
//       resultType = resultType.typeArguments.first;
//     }

//     //

//     final mutationKeyParams =
//         mutation.parameters.where((param) => param.isMutationKey).toList();
//     final mutationKeyArgs = switch (mutationKeyParams) {
//       final params when params.isNotEmpty => makeRecordType(
//           named: {
//             for (final parameter in params) parameter.name: parameter.type
//           },
//         ),
//       _ => null,
//     };

//     final notifierKeyParams = buildMethod?.parameters;
//     final notifierKeyArgs = switch (notifierKeyParams) {
//       final parameters? when parameters.isNotEmpty => makeRecordType(
//           named: {
//             for (final parameter in parameters) parameter.name: parameter.type
//           },
//         ),
//       _ => null,
//     };
//     final RecordType familyArgsType = makeRecordType(named: {
//       if (mutationKeyArgs != null) keys.mutation: mutationKeyArgs,
//       if (notifierKeyArgs != null) keys.notifier: notifierKeyArgs,
//     });
//     mutation.library.importedLibraries
//         .where((lib) => lib.name == 'riverpod_mutations_annotation.MutAction')
//         .firstOrNull;

//     // TODO: find a way to get the actual `MutAction` type
//     final actionType = FunctionTypeImpl(
//       parameters:
//           mutation.parameters.whereNot((param) => param.isMutationKey).toList(),
//       returnType: mutation.library.typeProvider.voidType,
//       typeFormals: [],
//       nullabilitySuffix: NullabilitySuffix.none,
//     );
//     final String actionTypeStr = actionType.typeToString;
//     final String returnTypeStr = resultType.typeToString;
//     final mutActionTypeStr = 'MutAction<$returnTypeStr, $actionTypeStr>';

//     final String fnStr = () {
//       if (notifier == null) return mutation.name;
//       String provider = '${notifier.name.camelCase}Provider';
//       final bool isNotifierFamily = buildMethod?.parameters.isNotEmpty ?? false;
//       if (isNotifierFamily) {
//         provider +=
//             '(${useParameterElements(buildMethod?.parameters, (param) => 'args.notifierKey.${param.name}')})';
//       }
//       final methodStr = 'ref.read($provider.notifier).${mutation.name}';
//       final parametersUsage = useParameterElements(
//         mutation.parameters,
//         (param) {
//           // TODO: make this work right
//           if (param.name == 'ref' && param.type.element?.name == 'MutRef') {
//             return 'ref.toMutRef';
//           }
//           return param.isMutationKey.str('args.mutationKey.') + param.name;
//         },
//       );
//       return '$methodStr($parametersUsage)';
//     }();
//     final isFamily = familyArgsType.namedFields.isNotEmpty;

//     String providerName = mutation.name;
//     if (notifier != null) providerName = '_$providerName${notifier.name}';
//     final familyArgs = (
//       mutationKey: switch ((mutationKeyParams, mutationKeyArgs)) {
//         (final params, final argsType?) when params.isNotEmpty => (
//             params: params,
//             argsType: argsType,
//           ),
//         _ => null,
//       },
//       notifierFamily: switch ((notifierKeyParams, notifierKeyArgs)) {
//         (final params?, final argsType?) when params.isNotEmpty => (
//             params: params,
//             argsType: argsType,
//           ),
//         _ => null,
//       },
//     );
//     return (
//       resultType: resultType, // flattened
//       familyArgs: switch (familyArgs) {
//         (mutationKey: null, notifierFamily: null) => null,
//         _ => familyArgs,
//       },
//       providerName: providerName,
//       mutActionTypeStr: mutActionTypeStr,
//       generatedProviderStr: '''
// final ${providerName}Provider = AutoDisposeProvider${isFamily.then('Family')}<$mutActionTypeStr${isFamily.str(', $familyArgsType')}>((ref${isFamily.str(', arg')}) {
//   return (
//     Mut.idle,
//     (${defineParameters(mutation.parameters.whereNot((param) => param.isMutationKey))}) => ref.runMutation(() => $fnStr),
//   );
// });
// ''',
//     );
//   }
// }

// extension on ParameterElement {
//   bool get isMutationKey => mutationKeyTypeChecker.hasAnnotationOf(this);
// }
