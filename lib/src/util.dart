import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_system.dart';
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
      final typeName = e.type.usableTypeName;
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
      final typeName = e.type.usableTypeName;

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

extension on DartType {
  String get usableTypeName {
    // print([
    //   'this: ' + toString(),
    //   'getDisplayString: ' + (getDisplayString(withNullability: true)),
    //   'name: ' + (element!.name!),
    //   'displayName: ' + (element!.displayName),
    // ].join('\n'));
    return getDisplayString(withNullability: true);
  }

  static TypeSystem typeSystemOf(Element element) =>
      element.library!.typeSystem;

  bool get hasQuestionMark => nullabilitySuffix == NullabilitySuffix.question;

  bool get isNullable {
    if (element case final element?) {
      return typeSystemOf(element).isNullable(this);
    }
    return map(
      Void: (type) => false,
      never: (type) => false,
      dynamic: (type) => true,
      invalid: (type) => true,
      //
      record: (type) => type.hasQuestionMark,
      function: (type) => type.hasQuestionMark,
      //
      orElse: (type) => type.hasQuestionMark,
    );
  }

  T map<T>({
    T Function(DynamicType type)? dynamic,
    T Function(InvalidType type)? invalid,
    T Function(NeverType type)? never,
    T Function(InterfaceType type)? interface,
    T Function(TypeParameterType type)? typeParameter,
    T Function(FunctionType type)? function,
    T Function(VoidType type)? Void,
    T Function(RecordType type)? record,
    required T Function(DartType type) orElse,
  }) {
    final self = this;
    return switch (self) {
      DynamicType() => (dynamic ?? orElse)(self),
      InvalidType() => (invalid ?? orElse)(self),
      NeverType() => (never ?? orElse)(self),
      InterfaceType() => (interface ?? orElse)(self),
      TypeParameterType() => (typeParameter ?? orElse)(self),
      // ParameterizedType() => (parameterized ?? orElse)(self), // InterfaceType
      FunctionType() => (function ?? orElse)(self),
      VoidType() => (Void ?? orElse)(self),
      RecordType() => (record ?? orElse)(self),
      DartType() => orElse(self),
    };
  }
}
