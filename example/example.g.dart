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

String _$exampleHash() => r'd7387c366d4b862b8004d28c0cef5f53de53e5f7';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
extension TodoListNotifierMutations on TodoListNotifierProvider {
  MutationListenable<void, Future<void> Function(Todo newTodo)> get addTodo =>
      MutationListenable.create(
        (ref, mutation) => (
          ref.watch(mutation),
          (Todo newTodo) => mutation.run(ref, (ref) {
            return ref.get(this.notifier).addTodo(newTodo);
          }),
        ),
        (this, 'addTodo', ()),
      );
  MutationListenable<void, Future<void> Function()> removeTodo({
    required int id,
  }) => MutationListenable.create(
    (ref, mutation) => (
      ref.watch(mutation),
      () => mutation.run(ref, (ref) {
        return ref.get(this.notifier).removeTodo(id: id);
      }),
    ),
    (this, 'removeTodo', (id: id)),
  );
}
