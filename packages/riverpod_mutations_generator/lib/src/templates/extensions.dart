part of 'templates.dart';

extension ParameterList on Iterable<FormalParameterElement> {
  @useResult
  Iterable<String> get names => map((p) => p.displayName);

  @useResult
  Iterable<FormalParameterElement> get named {
    return where((p) => p.isNamed);
  }

  @useResult
  Iterable<FormalParameterElement> get positional {
    return where((p) => p.isPositional);
  }

  @useResult
  Iterable<FormalParameterElement> get requiredPositional {
    return where((p) => p.isRequiredPositional);
  }

  @useResult
  Iterable<FormalParameterElement> get optionalPositional {
    return where((p) => p.isOptionalPositional);
  }

  @useResult
  bool get hasAnyMutationKeys => any(mutationKeyTypeChecker.hasAnnotationOf);

  /// Converts the parameter list to a partial code representation.
  ///
  /// For a parameter list of the shape `(int a, String b, {bool c = false, required double d})`
  /// This method will generate `int a, String b, bool c = false, required double d`
  @useResult
  String toPartialCode({bool includeDefaults = true}) {
    return map(
      (p) => p.toPartialCode(includeDefaults: includeDefaults),
    ).join(', ');
    // final buffer = StringBuffer();
    // for (final (i, p) in this.indexed) {
    //   if (i > 0) buffer.write(', ');
    //   buffer.write(p.toPartialCode());
    // }
    // return buffer.toString();
  }

  /// Converts the parameter list to a code representation.
  ///
  /// For a parameter list of the shape `(int a, String b, {bool c = false, required double d})`
  /// This method will generate `(int a, String b, {bool c = false, required double d})`
  @useResult
  String toCode({bool withParentheses = true, bool includeDefaults = true}) {
    final buffer = StringBuffer();
    if (withParentheses) buffer.write('(');
    buffer.write(requiredPositional.toPartialCode());

    if (optionalPositional.isNotEmpty) {
      if (requiredPositional.isNotEmpty) buffer.write(', ');
      buffer.write('[');
      buffer.write(
        optionalPositional.toPartialCode(includeDefaults: includeDefaults),
      );
      buffer.write(']');
    }
    if (named.isNotEmpty) {
      if (requiredPositional.isNotEmpty) buffer.write(', ');
      buffer.write('{');
      buffer.write(named.toPartialCode(includeDefaults: includeDefaults));
      buffer.write('}');
    }
    if (withParentheses) buffer.write(')');
    return buffer.toString();
  }

  @useResult
  String toInvocationCode({
    bool omitIfEmpty = false,
    bool withParentheses = true,
    String? overrideName(FormalParameterElement param)?,
  }) {
    if (omitIfEmpty && isEmpty) return '';
    String nameFor(FormalParameterElement param) =>
        overrideName?.call(param) ?? param.displayName;

    return (
      [for (final param in this.positional) nameFor(param)],
      {for (final param in this.named) param.displayName: nameFor(param)},
    ).toCode(withParentheses: withParentheses);
  }
}

typedef RecordLiteral = (
  Iterable<String> positional,
  Map<String, String> named,
);

extension RecordLiteralToCode on RecordLiteral {
  String toCode({bool withParentheses = true}) {
    final (positional, named) = this;
    final buffer = StringBuffer();
    if (withParentheses) buffer.write('(');
    buffer.write(positional.join(', '));
    // for (final (i, param) in positional.indexed) {
    //   if (i > 0) buffer.write(', ');
    //   buffer.write(param);
    // }
    if (named.isNotEmpty) {
      if (positional.isNotEmpty) buffer.write(', ');
      buffer.write(named.entries.map((e) => '${e.key}: ${e.value}').join(', '));
      // for (final (i, entry) in named.entries.indexed) {
      //   if (i > 0) buffer.write(', ');
      //   buffer.write('${entry.key}: ${entry.value}');
      // }
    }
    if (withParentheses) buffer.write(')');
    return buffer.toString();
  }
}

extension on FormalParameterElement {
  /// Converts the parameter to a partial code representation.
  ///
  /// Examples:
  /// `int a`
  /// `required bool b`
  /// `String c = "default"`
  /// `double? d`
  @useResult
  String toPartialCode({bool includeDefaults = true}) {
    final buffer = StringBuffer();
    if (isRequiredNamed) buffer.write('required ');
    buffer.write('${type.toCode()} $displayName');

    if (!includeDefaults || !hasDefaultValue) return buffer.toString();
    if (computeConstantValue() case final constant?) {
      buffer.write(' = ${constant.toCode()}');
    }
    return buffer.toString();
  }

  @useResult
  bool get isMutationTsx => mutationTransactionTypeChecker.isExactlyType(type);
}

extension on String {
  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }

  // String makeUnique(Iterable<String> existingNames) {
  //   String newName = this;
  //   int counter = 0;
  //   while (existingNames.contains(newName)) {
  //     newName = '${this}_$counter';
  //     counter++;
  //   }
  //   return newName;
  // }
}

extension on TypeParameterElement {
  String toCode() {
    final buffer = StringBuffer();
    buffer.write(displayName);
    if (bound case final bound?) {
      buffer.write(' extends ${bound.toCode()}');
    }
    return buffer.toString();
  }
}

extension on Iterable<TypeParameterElement> {
  Iterable<String> toNames() => map((e) => e.displayName);
  Iterable<String> toCodes() => map((e) => e.toCode());

  String toGenericsCode() {
    if (isEmpty) return '';
    return '<${toCodes().join(', ')}>';
  }
}
