// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$exampleHash() => r'8e94925464b940f3e410c2c2054797d4910f3652';

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

extension TodoListNotifierMutations on TodoListNotifierProvider {
  MutationListenable<
    void,
    Future<void> Function(MutationTarget target, Todo newTodo),
    Future<void> Function(Todo newTodo)
  >
  get addTodo {
    final mutation = $Mutations.getForProvider<void>(this, 'addTodo');
    Future<void> run(MutationTarget target, Todo newTodo) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).addTodo(newTodo);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target, Todo newTodo) => run(target, newTodo),
      (MutationTarget target) =>
          (Todo newTodo) => run(target, newTodo),
    );
  }

  MutationListenable<
    void,
    Future<void> Function(MutationTarget target),
    Future<void> Function()
  >
  removeTodo({required int id}) {
    final mutation = $Mutations.getForProvider<void>(this, 'removeTodo', (
      id: id,
    ));
    Future<void> run(MutationTarget target) {
      return mutation.run(target, (tsx) {
        return tsx.get(this.notifier).removeTodo(id: id);
      });
    }

    return MutationListenable(
      mutation,
      (MutationTarget target) => run(target),
      (MutationTarget target) =>
          () => run(target),
    );
  }
}
