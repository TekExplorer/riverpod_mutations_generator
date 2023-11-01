import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:source_gen/source_gen.dart';

const mutationKeyTypeChecker = TypeChecker.fromRuntime(MutationKey);
const riverpodTypeChecker = TypeChecker.fromRuntime(Riverpod);
const mutationTypeChecker = TypeChecker.fromRuntime(Mutation);

class Util {
  static ({
    String unwrapped,
    String? outerType,
    bool isAsync,
  }) unwrapType(String type) {
    if (type.startsWith('Future<') ||
        type.startsWith('FutureOr<') ||
        type.startsWith('Stream<')) {
      // Remove
      final unwrappedStepOne = type.replaceFirst(RegExp(r'^[A-z]+<'), '');
      final unwrapped = unwrappedStepOne.replaceFirst('>', '');

      final _outerType = type.replaceAll(RegExp('<.*'), '');

      return (unwrapped: unwrapped, outerType: _outerType, isAsync: true);
    }

    return (unwrapped: type, outerType: null, isAsync: false);
  }

  static String parameterListToString(
    Iterable<ParameterElement> parameters, {
    bool removeDefaults = false,
    bool removeRequired = false,
    bool extraComma = true,
  }) {
    // final parameters = executable.parameters
    //     .whereNot((element) => parametersToIgnore.contains(element.name));

    final constructedPositionalRequired =
        parameters.where((element) => element.isRequiredPositional).join(', ');

    final constructedPositionalOptional =
        parameters.where((element) => element.isOptionalPositional).map((e) {
      // FIXME: InvalidType ?!?!
      final typeName = e.type.element?.displayName;
      return '${typeName} ${e.name}${removeDefaults ? '' : ' = ${e.defaultValueCode}'}';
    }).join(', ');

    final constructedNamed =
        parameters.where((element) => element.isNamed).map((e) {
      final maybeRequired =
          (e.isRequiredNamed && !removeRequired) ? 'required ' : '';

      final maybeDefault = (e.hasDefaultValue && !removeDefaults)
          ? ' = ${e.defaultValueCode}'
          : '';

      // deal with InvalidType apparently
      final typeName = e.type.getDisplayString(withNullability: true);
      return '${maybeRequired}${typeName} ${e.name}${maybeDefault}';
    }).join(', ');

    final containsNamed = parameters.any((element) => element.isNamed);
    final containsOptionalPositional =
        parameters.any((element) => element.isOptionalPositional);

    if (!containsNamed && !containsOptionalPositional) {
      return '${constructedPositionalRequired}${extraComma ? ',' : ''}';
    }

    final firstHalf = constructedPositionalRequired.isEmpty
        ? ''
        : '${constructedPositionalRequired}, ';

    final String secondHalf = containsNamed
        ? '{$constructedNamed${extraComma ? ',' : ''}}'
        : '[$constructedPositionalOptional${extraComma ? ',' : ''}]';

    return '$firstHalf$secondHalf';
  }

  static String parametersUsage(
    Iterable<ParameterElement> parameters, {
    String? prefix,
    bool nameOnly = false,
    int offsetPositionalBy = 0,
  }) {
    if (prefix != null) prefix = '${prefix}.';

    prefix ??= '';

    return parameters.mapIndexed((i, e) {
          final _name = e.name;
          if (e.isNamed) return '${_name}: ${prefix}${_name}';
          final _dollarNotation = '\$${i + 1 + offsetPositionalBy}';
          return '${prefix}${nameOnly ? _name : _dollarNotation}';
        }).join(', ') +
        ',';
  }
}
