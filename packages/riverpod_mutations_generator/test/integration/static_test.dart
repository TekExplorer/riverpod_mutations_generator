import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

import 'shared.dart';

part 'static_test.g.dart';

class Static {
  static final test = _$Static_test;
  @mutation
  static Future<void> _test() async {
    Static.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$Static_test2;
  @mutation
  static Future<String> _test2(String id, @mutationKey String key) async {
    Static.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}

extension Extension on void {
  static final test = _$Extension_test;
  @mutation
  static Future<void> _test() async {
    Extension.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$Extension_test2;
  @mutation
  static Future<String> _test2(String id, @mutationKey String key) async {
    Extension.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}

extension type ExtensionType(int _) {
  static final test = _$ExtensionType_test;
  @mutation
  static Future<void> _test() async {
    ExtensionType.test
        .check<
          void,
          Future<void> Function(MutationTarget target),
          Future<void> Function()
        >();
  }

  static final test2 = _$ExtensionType_test2;
  @mutation
  static Future<String> _test2(String id, @mutationKey String key) async {
    ExtensionType.test2(key)
        .check<
          String,
          Future<String> Function(MutationTarget target, String id),
          Future<String> Function(String id)
        >();
    return 'result';
  }
}
