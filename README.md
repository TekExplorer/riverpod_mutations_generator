# Riverpod Mutations Generator

Hello! This is an attempt to cover the gap left behind by the lack of mutation support in riverpod.

Try it out like so!

```dart
@riverpod
class Todo extends _$Example {
  Future<List<Todo>> build() => fetchTodoList();

  @mutation
  Future<void> addTodo(Todo todo) async {
    await http.post(...., todo.toJson());
  }

  // @mutation
  // Future<void> updateTodo(...) async {...}
}

// flutter example
return Consumer(
  builder: (context, ref, child) {
    // normal list of todos
    List<Todo> todos = ref.watch(exampleProvider);
    // here's the fancy part
    AddTodoMutation addTodo = ref.watch(exampleProvider.addTodo);

    return SomeButton(
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
  },
);
```
