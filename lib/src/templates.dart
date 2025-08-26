import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer_buffer/analyzer_buffer.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_mutations_generator/src/types.dart';
import 'package:riverpod_mutations_generator/src/utils/dart_type_extensions.dart';

import 'type_checkers.dart';

extension type MutationsGeneratorBuffer(AnalyzerBuffer _)
    implements AnalyzerBuffer {
  factory MutationsGeneratorBuffer.part2(
    LibraryElement2 library, {
    String? header,
  }) => MutationsGeneratorBuffer(AnalyzerBuffer.part2(library, header: header));

  MutationsGeneratorBuffer get buffer => this;

  void writeClassElement(NotifierClass notifier) {
    final mutations = notifier.mutations;
    if (mutations.isEmpty) return;

    final notifierName = notifier.name;

    write(
      'extension ${notifierName}Mutations#{{NotifierGenerics}} on ${notifierName}Provider#{{NotifierGenericsApplication}} {',
      args: {
        'NotifierGenerics': () {
          if (notifier.typeParameters.isEmpty) return;
          buffer.write('<');
          for (final (i, param) in notifier.typeParameters.indexed) {
            if (i > 0) buffer.write(', ');
            buffer.write(param.displayName);
            if (param.bound != null) {
              buffer.write(' extends ${param.bound!.toCode()}');
            }
          }
          buffer.write('>');
        },
        'NotifierGenericsApplication': () {
          if (notifier.typeParameters.isEmpty) return;
          buffer.write('<');
          for (final (i, param) in notifier.typeParameters.indexed) {
            if (i > 0) buffer.write(', ');
            buffer.write(param.displayName);
          }
          buffer.write('>');
        },
      },
    );
    for (final mutation in mutations) {
      writeMethodElement(mutation);
    }
    write('}');
  }

  void writeMethodElement(MutationMethod method) {
    final methodName = method.name;

    buffer.write(
      args: {
        'ref': () {
          if (method.formalParameters.any(
            (p) => p.isMutationRef && p.displayName == 'ref',
          )) {
            buffer.write('ref');
            return;
          }

          final ref = 'ref'.makeUnique(
            method.formalParameters.map((p) => p.displayName),
          );

          buffer.write(ref);
        },
        'mutation': () {
          final mutation = 'mutation'.makeUnique(
            method.formalParameters.map((p) => p.displayName),
          );
          buffer.write(mutation);
        },
        'PARAMETERS_DECLARATION': () {
          buffer.write(method.endUserParameters.toCode());
        },
        'PARAMETERS_INVOCATION': () {
          // write as a record
          buffer.write(method.formalParameters.toInvocationCode());
        },
        'EXECUTABLE_TYPE': () {
          buffer.write(
            method.type
                .copyWith(formalParameters: method.endUserParameters)
                .toCode(),
          );
        },
        'GETTER_DECLARATION': () {
          buffer.writeMethodDeclaration(
            method.name.public,
            method.keyedParameters,
            method.type.typeParameters,
            preferGetter: true,
          );
        },

        'KEYS': () {
          final keyedParameters = method.keyedParameters;
          // if (keyedParameters.isEmpty) return;
          // buffer.write('(');
          buffer.write(keyedParameters.toInvocationCode());
          // buffer.write(')');
        },
        'MutationListenable': () {
          buffer.write('#{{riverpod_mutations_annotation|MutationListenable}}');
        },
      },
      '''
  #{{MutationListenable}}<${method.resultT.toCode()}, #{{EXECUTABLE_TYPE}}>
    #{{GETTER_DECLARATION}} => #{{MutationListenable}}.create((#{{ref}}, #{{mutation}}) => (
      #{{ref}}.watch(#{{mutation}}),
      #{{PARAMETERS_DECLARATION}} => #{{mutation}}.run(#{{ref}}, (#{{ref}}) {
        return #{{ref}}.get(this.notifier).$methodName#{{PARAMETERS_INVOCATION}};
      }),
    ),
    (this, '$methodName', #{{KEYS}})
  );
  ''',
      // #{{riverpod_mutations_annotation|\$Mutations}}.get<${method.resultT.toCode()}>(this, '$methodName')#{{KEYS}},
      // static final $methodName = Mutation<${method.resultT.toCode()}>(label: '${method.notifier.name}.$methodName');
      // Mutation<${method.resultT.toCode()}>(label: '\${this.name}.$methodName')((this, '${methodName}', #{{KEYS}})),
    );
  }

  void writeMethodDeclaration(
    String name,
    Iterable<FormalParameterElement> parameters,
    Iterable<TypeParameterElement2> typeParameters, {
    bool preferGetter = false,
  }) {
    if (parameters.isEmpty && typeParameters.isEmpty && preferGetter) {
      buffer.write('get $name ');
      return;
    }
    buffer.write(name);
    if (typeParameters.isNotEmpty) {
      buffer.write('<');
      buffer.write(
        typeParameters.map((typeParam) => typeParam.displayName).join(', '),
      );
      // for (final (i, typeParam) in typeParameters.indexed) {
      //   if (i > 0) buffer.write(', ');
      //   buffer.write(typeParam.displayName);
      // }
      buffer.write('>');
    }
    buffer.write(parameters.toCode());
  }

  void writeRecordLiteral(
    Iterable<String> positional,
    Map<String, String> named,
  ) {
    buffer.write((positional, named).toCode());
  }
}

extension ParameterList on Iterable<FormalParameterElement> {
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
  String toPartialCode() {
    return map((p) => p.toPartialCode()).join(', ');
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
  String toCode() {
    final buffer = StringBuffer();
    buffer.write('(');
    buffer.write(requiredPositional.toPartialCode());

    if (optionalPositional.isNotEmpty) {
      if (requiredPositional.isNotEmpty) buffer.write(', ');
      buffer.write('[');
      buffer.write(optionalPositional.toPartialCode());
      buffer.write(']');
    }
    if (named.isNotEmpty) {
      if (requiredPositional.isNotEmpty) buffer.write(', ');
      buffer.write('{');
      buffer.write(named.toPartialCode());
      buffer.write('}');
    }
    buffer.write(')');
    return buffer.toString();
  }

  @useResult
  String toInvocationCode({bool omitIfEmpty = false}) {
    if (omitIfEmpty && isEmpty) return '';
    return (
      [for (final param in this.positional) param.displayName],
      {for (final param in this.named) param.displayName: param.displayName},
    ).toCode();
  }
}

typedef RecordLiteral = (
  Iterable<String> positional,
  Map<String, String> named,
);

extension RecordLiteralToCode on RecordLiteral {
  String toCode() {
    final (positional, named) = this;
    final buffer = StringBuffer();
    buffer.write('(');
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
    buffer.write(')');
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
  String toPartialCode() {
    final buffer = StringBuffer();
    if (isRequiredNamed) buffer.write('required ');
    buffer.write('${type.toCode()} $displayName');
    if (computeConstantValue() case final constant? when hasDefaultValue) {
      buffer.write(' = ${constant.toCode()}');
    }
    return buffer.toString();
  }

  @useResult
  bool get isMutationRef => mutationRefTypeChecker.isExactlyType(type);
}

extension on String {
  String get public {
    if (startsWith('_')) return substring(1);
    return this;
  }
}

extension on String {
  String makeUnique(Iterable<String> existingNames) {
    String newName = this;
    int counter = 0;
    while (existingNames.contains(newName)) {
      newName = '${this}_$counter';
      counter++;
    }
    return newName;
  }
}
