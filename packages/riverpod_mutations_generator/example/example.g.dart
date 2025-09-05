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

String _$exampleHash() => r'8e94925464b940f3e410c2c2054797d4910f3652';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
extension TodoListNotifierMutations on TodoListNotifierProvider {
  Mutation<T> _$mutation<T>(String mutationName, [Object? key]) =>
      $Mutations.getForProvider<T>(this, mutationName, key);
  TodoListNotifier_AddTodo get addTodo => TodoListNotifier_AddTodo._(
    _$mutation<void>('addTodo'),
    (tsx, Todo newTodo) => tsx.get(this.notifier).addTodo(newTodo),
  );
  TodoListNotifier_RemoveTodo removeTodo({required int id}) =>
      TodoListNotifier_RemoveTodo._(
        _$mutation<void>('removeTodo', (id: id)),
        (tsx) => tsx.get(this.notifier).removeTodo(id: id),
      );
}

final class TodoListNotifier_AddTodo extends MutationListenable<void> {
  TodoListNotifier_AddTodo._(super.mutation, this._run);
  final Future<void> Function(MutationRef, Todo newTodo) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function(Todo newTodo))>
  get pair => $proxyMutationPair(this.mutation, (target) {
    return (Todo newTodo) => run(target, newTodo);
  });

  Future<void> run(MutationTarget target, Todo newTodo) =>
      this.mutation.run(target, (tsx) {
        return _run(tsx, newTodo);
      });
}

final class TodoListNotifier_RemoveTodo extends MutationListenable<void> {
  TodoListNotifier_RemoveTodo._(super.mutation, this._run);
  final Future<void> Function(MutationRef) _run;

  ProviderListenable<(MutationState<void>, Future<void> Function())> get pair =>
      $proxyMutationPair(this.mutation, (target) {
        return () => run(target);
      });

  Future<void> run(MutationTarget target) => this.mutation.run(target, (tsx) {
    return _run(tsx);
  });
}
