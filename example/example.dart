// ignore_for_file: unused_local_variable

import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

part 'example.g.dart';

class Todo {
  const Todo(this.id, this.todo);
  final int id;
  final String todo;
}

@riverpod
class TodoList extends _$TodoList {
  @override
  FutureOr<List<Todo>> build() => [];

  @mutation
  Future<void> addTodo(Todo newTodo) async {
    // simulate doing something
    await Future.delayed(Duration.zero);
    // load the new item into the list
    state = AsyncData((await future)..add(newTodo));

    // or, do this to let the build method acquire the most up to date information
    ref.invalidateSelf();
    await future;
  }

  @mutation
  Future<void> removeTodo({@mutationKey required int id}) async {
    // simulate doing something
    await Future.delayed(Duration.zero);

    // remove the item from the list
    state = AsyncData((await future)..removeWhere((e) => e.id == id));

    // or, do this to let the build method acquire the most up to date information
    ref.invalidateSelf();
    await future;
  }
}

void example(AutoDisposeRef ref) {
  // normal usage
  final todoList = ref.watch(todoListProvider);

  final addTodo = ref.watch(todoListProvider.addTodo);

  switch (addTodo) {
    case AddTodoMutationIdle():
      print('Idle/Initial');

    case AddTodoMutationLoading():
      print('Loading...');

    case AddTodoMutationSuccess():
      print('Success!');

    case AddTodoMutationFailure(:final error):
      print(error.toString());
  }

  addTodo(Todo(1, 'newTodo'));

  final removeTodo = ref.watch(todoListProvider.removeTodo(id: 1));

  // the parameter marked by @mutationKey was removed, as it's stored
  removeTodo();

  final int storedId = removeTodo.params.id;
}
