// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleHash() => r'18862360dafc310b852fc0c530d5269e4099886d';

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

extension TodoListMutations on AsyncNotifierProviderBase<TodoList, dynamic> {
  MutProvider<void, void Function(Todo)> get addTodo =>
      MutProvider<void, void Function(Todo)>(
        (_ref) => (Todo newTodo) =>
            _ref.mutate(() => _ref.read(this.notifier).addTodo(newTodo)),
        keys: (),
        source: this,
        method: 'addTodo',
      );
  MutProvider<void, void Function()> removeTodo({required int id}) =>
      MutProvider<void, void Function()>(
        (_ref) => () =>
            _ref.mutate(() => _ref.read(this.notifier).removeTodo(id: id)),
        keys: (id: id),
        source: this,
        method: 'removeTodo',
      );
}
