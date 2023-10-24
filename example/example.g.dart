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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// **************************************************************************
// RiverpodMutationsGenerator
// **************************************************************************

extension TodoListMutationExtension
    on AutoDisposeAsyncNotifierProvider<TodoList, List<Todo>> {
  Refreshable<AddTodoMutation> get addTodo => _addTodoProvider;
  Refreshable<RemoveTodoMutation> removeTodo({required int id}) =>
      _removeTodoProvider((id: id,));
}

final _addTodoProvider = Provider.autoDispose((ref) {
  final notifier = ref.watch(todoListProvider.notifier);
  return AddTodoMutation(
    (newState) => ref.state = newState,
    notifier.addTodo,
  );
});

typedef AddTodoSignature = Future<void> Function(Todo newTodo);
typedef AddTodoStateSetter = void Function(AddTodoMutation newState);

sealed class AddTodoMutation {
  const factory AddTodoMutation(
    AddTodoStateSetter updateState,
    AddTodoSignature fn,
  ) = AddTodoMutationIdle._;

  const AddTodoMutation._(this._updateState, this._fn);

  final AddTodoStateSetter _updateState;
  final AddTodoSignature _fn;

  Object? get error;
  StackTrace? get stackTrace;

  Future<void> call(Todo newTodo) async {
    _updateState(AddTodoMutationLoading.from(this));
    try {
      await _fn(newTodo);
      _updateState(AddTodoMutationSuccess.from(this));
    } catch (e, s) {
      _updateState(AddTodoMutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class AddTodoMutationIdle extends AddTodoMutation {
  const AddTodoMutationIdle._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory AddTodoMutationIdle.from(AddTodoMutation other) =>
      AddTodoMutationIdle._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class AddTodoMutationLoading extends AddTodoMutation {
  const AddTodoMutationLoading._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory AddTodoMutationLoading.from(AddTodoMutation other) =>
      AddTodoMutationLoading._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class AddTodoMutationSuccess extends AddTodoMutation {
  const AddTodoMutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory AddTodoMutationSuccess.from(AddTodoMutation other) =>
      AddTodoMutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class AddTodoMutationFailure extends AddTodoMutation {
  const AddTodoMutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
  }) : super._();

  factory AddTodoMutationFailure.from(
    AddTodoMutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      AddTodoMutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}

typedef RemoveTodoFamilyParameters = ({
  int id,
});
final _removeTodoProvider =
    Provider.autoDispose.family((ref, RemoveTodoFamilyParameters _params) {
  final notifier = ref.watch(todoListProvider.notifier);
  return RemoveTodoMutation(
    (newState) => ref.state = newState..params = _params,
    notifier.removeTodo,
  )..params = _params;
});
typedef RemoveTodoSignature = Future<void> Function({required int id});
typedef RemoveTodoStateSetter = void Function(RemoveTodoMutation newState);

sealed class RemoveTodoMutation {
  factory RemoveTodoMutation(
    RemoveTodoStateSetter updateState,
    RemoveTodoSignature fn,
  ) = RemoveTodoMutationIdle._;

  RemoveTodoMutation._(this._updateState, this._fn);

  final RemoveTodoStateSetter _updateState;
  final RemoveTodoSignature _fn;

  Object? get error;
  StackTrace? get stackTrace;

  /// This stores the @mutationKey parameters for this method. This may change.
  late final RemoveTodoFamilyParameters params;

  Future<void> call() async {
    _updateState(RemoveTodoMutationLoading.from(this));
    try {
      await _fn(id: params.id);
      _updateState(RemoveTodoMutationSuccess.from(this));
    } catch (e, s) {
      _updateState(
          RemoveTodoMutationFailure.from(this, error: e, stackTrace: s));
    }
  }
}

final class RemoveTodoMutationIdle extends RemoveTodoMutation {
  RemoveTodoMutationIdle._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory RemoveTodoMutationIdle.from(RemoveTodoMutation other) =>
      RemoveTodoMutationIdle._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class RemoveTodoMutationLoading extends RemoveTodoMutation {
  RemoveTodoMutationLoading._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory RemoveTodoMutationLoading.from(RemoveTodoMutation other) =>
      RemoveTodoMutationLoading._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class RemoveTodoMutationSuccess extends RemoveTodoMutation {
  RemoveTodoMutationSuccess._(
    super._updateState,
    super._fn, {
    this.error,
    this.stackTrace,
  }) : super._();

  factory RemoveTodoMutationSuccess.from(RemoveTodoMutation other) =>
      RemoveTodoMutationSuccess._(
        other._updateState,
        other._fn,
        error: other.error,
        stackTrace: other.stackTrace,
      );

  @override
  final Object? error;

  @override
  final StackTrace? stackTrace;
}

final class RemoveTodoMutationFailure extends RemoveTodoMutation {
  RemoveTodoMutationFailure._(
    super._updateState,
    super._fn, {
    required this.error,
    required this.stackTrace,
  }) : super._();

  factory RemoveTodoMutationFailure.from(
    RemoveTodoMutation other, {
    required Object error,
    required StackTrace stackTrace,
  }) =>
      RemoveTodoMutationFailure._(
        other._updateState,
        other._fn,
        error: error,
        stackTrace: stackTrace,
      );

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}
