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

    write('extension ${notifierName}Mutations on ${notifierName}Provider {');
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
            (p) => p.isMutationRef && p.name3 == 'ref',
          )) {
            buffer.write('ref');
            return;
          }

          final ref = 'ref'.makeUnique(
            method.formalParameters.map((p) => p.name3!),
          );

          buffer.write(ref);
        },
        'mutation': () {
          final mutation = 'mutation'.makeUnique(
            method.formalParameters.map((p) => p.name3!),
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
            methodName.public,
            method.keyedParameters,
            method.type.typeParameters,
          );
        },

        'KEYS': () {
          final keyedParameters = method.keyedParameters;
          if (keyedParameters.isEmpty) return;
          buffer.write(keyedParameters.toInvocationCode());
        },
        'MutationListenable': () {
          buffer.write('#{{riverpod_mutations_annotation|MutationListenable}}');
        },
      },
      '''
  static final mut = Mutation<${method.resultT.toCode()}>();
  #{{MutationListenable}}<${method.resultT.toCode()}, #{{EXECUTABLE_TYPE}}>
    #{{GETTER_DECLARATION}} => #{{MutationListenable}}((#{{ref}}, #{{mutation}}) => (
      #{{ref}}.watch(#{{mutation}}),
      #{{PARAMETERS_DECLARATION}} => #{{mutation}}.run(#{{ref}}, (#{{ref}}) {
        return #{{ref}}.get(this.notifier).$methodName#{{PARAMETERS_INVOCATION}};
      }),
    ),
    (this, '${methodName}', #{{KEYS}}),
    label: '\${this.name}.$methodName',
  );
  ''',
    );
  }

  void writeMethodDeclaration(
    String name,
    Iterable<FormalParameterElement> parameters,
    Iterable<TypeParameterElement2> typeParameters, {
    bool preferGetter = true,
  }) {
    if (parameters.isEmpty && typeParameters.isEmpty && preferGetter) {
      buffer.write('get $name ');
      return;
    }
    buffer.write(name);
    if (typeParameters.isNotEmpty) {
      buffer.write('<');
      for (final (i, typeParam) in typeParameters.indexed) {
        if (i > 0) buffer.write(', ');
        buffer.write(typeParam.displayName);
      }
      buffer.write('>');
    }
    buffer.write(parameters.toCode());
  }
}

extension ParameterList on Iterable<FormalParameterElement> {
  Iterable<FormalParameterElement> get named {
    return where((p) => p.isNamed);
  }

  Iterable<FormalParameterElement> get requiredPositional {
    return where((p) => p.isRequiredPositional);
  }

  Iterable<FormalParameterElement> get optionalPositional {
    return where((p) => p.isOptionalPositional);
  }

  bool get hasAnyMutationKeys => any(mutationKeyTypeChecker.hasAnnotationOf);

  String _toPartialCode() {
    final buffer = StringBuffer();
    for (final p in this) {
      buffer.write(p.toPartialCode());
      buffer.write(', ');
    }
    return buffer.toString();
  }

  @useResult
  String toCode() {
    final buffer = StringBuffer();
    buffer.write('(');
    buffer.write(requiredPositional._toPartialCode());
    if (optionalPositional.isNotEmpty) {
      buffer.write('[');
      buffer.write(optionalPositional._toPartialCode());
      buffer.write(']');
    }
    if (named.isNotEmpty) {
      buffer.write('{');
      buffer.write(named._toPartialCode());
      buffer.write('}');
    }
    buffer.write(')');
    return buffer.toString();
  }

  @useResult
  String toInvocationCode({bool omitIfEmpty = false}) {
    if (omitIfEmpty && isEmpty) return '';
    final buffer = StringBuffer();
    buffer.write('(');
    for (final param in this) {
      if (param.isNamed) buffer.write('${param.name3!}: ');
      buffer.write(param.name3!);
      buffer.write(', ');
    }
    buffer.write(')');
    return buffer.toString();
  }
}

extension on FormalParameterElement {
  @useResult
  String toPartialCode() {
    final buffer = StringBuffer();
    if (isRequiredNamed) buffer.write('required ');
    buffer.write('${type.toCode()} $name3');
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
