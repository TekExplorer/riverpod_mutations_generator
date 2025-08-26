import 'package:analyzer/dart/element/element2.dart';
import 'package:code_builder/code_builder.dart' as c;

import 'dart_type_extensions.dart';

extension ParameterElementToParameter on FormalParameterElement {
  c.Parameter get toParameter => c.Parameter((p) {
    p.name = name3!;
    p.type = type.toRef;
    if (defaultValueCode case final code?) p.defaultTo = c.Code(code);
    p.named = isNamed;
    p.required = isRequiredNamed;
  });
}
