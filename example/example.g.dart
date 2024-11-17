// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'60491a7f13c10c25ce434486b4605d8db555ee04';

/// See also [TodoList].
@ProviderFor(TodoList)
final todoListProvider =
    AutoDisposeAsyncNotifierProvider<TodoList, List<Todo>>.internal(
  TodoList.new,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodoList = AutoDisposeAsyncNotifier<List<Todo>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// Generator: Gen
// **************************************************************************

final _addTodoTodoList = MutFamily<void, void Function(Todo), (), ()>((
  ref,
  args,
) =>
    (Todo newTodo) {
      ref.mutate(() => ref.read(todoListProvider.notifier).addTodo(newTodo));
    });
final _removeTodoTodoList = MutFamily<void, void Function(), ({int id}), ()>((
  ref,
  args,
) =>
    () {
      ref.mutate(() =>
          ref.read(todoListProvider.notifier).removeTodo(id: args.mutKeys.id));
    });

extension TodoListMutations
    on AutoDisposeAsyncNotifierProvider<TodoList, dynamic> {
  () get args => ();
  MutProvider<void, void Function(Todo), (), ()> get addTodo =>
      _addTodoTodoList(
        notifierKeys: args,
        mutKeys: (),
      );
  MutProvider<void, void Function(), ({int id}), ()> removeTodo(
          {required int id}) =>
      _removeTodoTodoList(
        notifierKeys: args,
        mutKeys: (id: id),
      );
}
