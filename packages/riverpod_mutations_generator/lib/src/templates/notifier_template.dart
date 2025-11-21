part of 'templates.dart';

class NotifierTemplate {
  NotifierTemplate(this.notifier);
  final NotifierClass notifier;

  String get notifierName => notifier.name;

  late final mutations = notifier.mutations;
  late final templates = mutations.map(MutationTemplate.new);

  void writeExtension(AnalyzerBuffer buffer) {
    if (mutations.isEmpty) return;

    buffer.write(
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
        'mutation_getters': () {
          for (final template in templates) {
            template.writeGetter(buffer);
          }
        },
        'on_type': () {
          if (riverpodTypeChecker.hasAnnotationOf(notifier.element)) {
            buffer.write(
              '${notifierName}Provider#{{NotifierGenericsApplication}}',
            );
          } else {
            buffer.write(
              '\$ClassProvider<${notifierName}#{{NotifierGenericsApplication}}, dynamic, dynamic, dynamic>',
            );
          }
        },
      },
      '''
extension ${notifierName}Mutations#{{NotifierGenerics}} on #{{on_type}} {
  #{{mutation_getters}}
}
''',
    );
  }
}
