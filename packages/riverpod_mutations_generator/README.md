# Riverpod Mutations Generator

Hello! This is an attempt to cover the gap left behind by the lack of mutation support in riverpod. See <https://github.com/rrousselGit/riverpod/issues/1660>
NEW: Riverpod's dev builds now have their own mutations solution! However, they are not as convenient as I would like, so here we go again!

Try it out like so!

First, import both this and `riverpod_mutations_annotation`

```yaml
dependencies:
  riverpod: ^3.0.0-dev.17 # Your preferred riverpod package
  riverpod_annotation: ^3.0.0-dev.17
  riverpod_mutations_annotation: ^2.0.0-dev.4

dev_dependencies:
  build_runner: ^2.3.3
  riverpod_generator: ^3.0.0-dev.17
  riverpod_mutations_generator: ^2.0.0-dev.3
```

```dart
@riverpod
class Todo extends _$Todo {
  Future<List<Todo>> build() => fetchTodoList();

  @mutation
  Future<void> addTodo(Todo todo) async {
    await http.post(...., todo.toJson());
  }

  // special @mutationKey allows you to convert a specific parameter into a family key,
  // which you provide ahead of time as you would any family
  // this is useful for tracking multiple instances of the same method
  @mutation
  Future<void> removeTodo({@mutationKey required int id}) async {...}
}

// flutter example
return Consumer(
  builder: (context, ref, child) {
    // normal list of todos
    final List<Todo> todos = ref.watch(exampleProvider);
    
    // here's the fancy part
    // this example shows the use of pattern matching to destructure the record
    // the types are explicitly specified here for demonstration.
    // in the real world, you would omit these and let the language infer them
    final (
      MutationState<void> addTodoState,
      Future<void> Function(Todo) addTodo,
    ) = ref.watch(exampleProvider.addTodo.pair);


    // this will allow you to track the same method multiple times, exactly like a family.
    // note: the parameter was removed from `removeTodo()` as shown.
    // This particular value is now stored in the object in `removeTodo.params.id`

    // this example also shows using the state and action without unpacking it
    final removeTodo = ref.watch(exampleProvider.removeTodo(id: 4).pair);

    // you can also do it separately (the normal usage)
    final removeTodoMutation = exampleProvider.removeTodo(id: 4);
    final MutationState<void> removeTodoState = ref.watch(removeTodoMutation);
    // and call it with
    onPressed() {
      await removeTodoMutation.run(ref);
    }


    return Row(
      children: [
        AddButton(
          // invoke the Todo.addTodo method
          // disable the button if its currently loading
          onTap: addTodoState is MutationPending ? null : () => addTodo(Todo()),
          // show how the side effect is doing
          trailing: switch (addTodo) {
            MutationIdle() => Icon(IconData.circle),
            MutationPending() => CircularProgressIndicator(),
            MutationSuccess() => Icon(IconData.check),
            MutationFailure(:final error) => IconButton(IconData.info, onPressed: () => showErrorDialog(error)),
          },
        ),
        RemoveButton(
          // Notice, the parameter was removed, as it's already stored in the object in `removeTodo.params.id`
          onTap: removeTodo is MutationPending ? null : () => removeTodo.run(),
          // show how the side effect is doing
          trailing: switch (removeTodo.state) {
            MutationIdle() => Icon(IconData.circle),
            MutationPending() => CircularProgressIndicator(),
            MutationSuccess() => Icon(IconData.check),
            MutationFailure(:final error) => IconButton(IconData.info, onPressed: () => showErrorDialog(error)),
          },
        );
      ],
    );
  },
);
```
