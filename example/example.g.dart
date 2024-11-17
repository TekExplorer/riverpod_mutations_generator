// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'0add584e92f9c88db43c195c0608c1ef551fbe32';

/// See also [example].
@ProviderFor(example)
final exampleProvider = AutoDisposeProvider<void>.internal(
  example,
  name: r'exampleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$exampleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExampleRef = AutoDisposeProviderRef<void>;
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
// RiverpodMutationsGenerator
// **************************************************************************

final _addTodoTodoList = MutFamily<void, void Function(Todo), (), ()>((
  _ref,
  _args,
) =>
    (Todo newTodo) {
      _ref.mutate(() => _ref.read(todoListProvider.notifier).addTodo(newTodo));
    });
final _removeTodoTodoList = MutFamily<void, void Function(), ({int id}), ()>((
  _ref,
  _args,
) =>
    () {
      _ref.mutate(() => _ref
          .read(todoListProvider.notifier)
          .removeTodo(id: _args.mutKeys.id));
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
