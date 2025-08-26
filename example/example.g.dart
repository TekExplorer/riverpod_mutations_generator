// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TodoListNotifier)
const todoListProvider = TodoListNotifierProvider._();

final class TodoListNotifierProvider
    extends $AsyncNotifierProvider<TodoListNotifier, List<Todo>> {
  const TodoListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListNotifierHash();

  @$internal
  @override
  TodoListNotifier create() => TodoListNotifier();
}

String _$todoListNotifierHash() => r'5de5c509863ee8139cc5f2be9291b9a585eb269b';

abstract class _$TodoListNotifier extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
              AsyncValue<List<Todo>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(example)
const exampleProvider = ExampleProvider._();

final class ExampleProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  const ExampleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return example(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$exampleHash() => r'e75f372c53ca876f1847faf2b447a4841426d004';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

extension TodoListNotifierMutations on TodoListNotifierProvider {
  Provider<(MutationState<void>, Future<void> Function(Todo))> get addTodo =>
      Provider<(MutationState<void>, Future<void> Function(Todo))>((ref) {
        final mutation = Mutation<void>()((this, 'addTodo'));
        return (
          ref.watch(mutation),
          (Todo newTodo) => mutation.run(
            ref,
            (ref) => ref.get(this.notifier).addTodo(newTodo),
          ),
        );
      });
  Provider<(MutationState<void>, Future<void> Function())> removeTodo({
    required int id,
  }) => Provider<(MutationState<void>, Future<void> Function())>((ref) {
    final mutation = Mutation<void>()((this, 'removeTodo'))((id: id));
    return (
      ref.watch(mutation),
      () =>
          mutation.run(ref, (ref) => ref.get(this.notifier).removeTodo(id: id)),
    );
  });
}

Provider<(MutationState<String>, Future<String> Function(int))>
get exampleFunctionMut =>
    Provider<(MutationState<String>, Future<String> Function(int))>((ref) {
      final mutation = Mutation<String>()(exampleFunction);
      return (
        ref.watch(mutation),
        (int id) => mutation.run(ref, (ref) => exampleFunction(id)),
      );
    });
