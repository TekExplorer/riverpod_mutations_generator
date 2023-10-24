# Riverpod Mutations Generator

Hello! This is an attempt to cover the gap left behind by the lack of mutation support in riverpod.

Try it out like so!

First, import both this and `riverpod_mutations_annotation`

```yaml
dependencies:
  riverpod_annotation: ^2.2.0  
  riverpod_mutations_annotation: ^1.0.0

dev_dependencies:
  build_runner: ^2.3.3
  riverpod: ^2.4.4
  riverpod_generator: ^2.3.5
  riverpod_mutations_generator: ^1.0.0
```

```dart
@riverpod
class Todo extends _$Example {
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
    List<Todo> todos = ref.watch(exampleProvider);
    // here's the fancy part
    AddTodoMutation addTodo = ref.watch(exampleProvider.addTodo);

    // this will allow you to track the same method multiple times, exactly like a family. note: the parameter was removed from `removeTodo()` as shown. This particular value is now stored in the object in `removeTodo.params.id`
    RemoveTodoMutation removeTodo = ref.watch(exampleProvider.removeTodo(id: 4));

    return Row(
      children: [
        AddButton(
          // invoke the Todo.addTodo method
          // disable the button if its currently loading
          onTap: addTodo is AddTodoMutationLoading ? null : () => addTodo(Todo()),
          // show how the side effect is doing
          trailing: switch (addTodo) {
            AddTodoMutationInitial() => Icon(IconData.circle),
            AddTodoMutationLoading() => CircularProgressIndicator(),
            AddTodoMutationSuccess() => Icon(IconData.check),
            AddTodoMutationFailure(:final error) => IconButton(IconData.info, onPressed: () => showErrorDialog(error)),
          },
        );
        RemoveButton(
          // Notice, the parameter was removed, as it's already stored in the object in `removeTodo.params.id`
          onTap: removeTodo is RemoveTodoMutationLoading ? null : () => removeTodo(),
          // show how the side effect is doing
          trailing: switch (removeTodo) {
            RemoveTodoMutationInitial() => Icon(IconData.circle),
            RemoveTodoMutationLoading() => CircularProgressIndicator(),
            RemoveTodoSuccess() => Icon(IconData.check),
            RemoveTodoFailure(:final error) => IconButton(IconData.info, onPressed: () => showErrorDialog(error)),
          },
        );
      ],
    );
  },
);
```
