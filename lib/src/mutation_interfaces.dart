sealed class _Mutation {
  Object? get error;
  StackTrace? get stackTrace;
}

abstract mixin class SyncMutation implements _Mutation {}

abstract mixin class AsyncMutation implements _Mutation {
  // Refreshable<Future> get future;
}

abstract mixin class MutationResult<T> {
  T? get result;
}

abstract mixin class MutationSuccessResult<T>
    implements MutationResult<T>, MutationSuccess {
  @override
  T get result;
}

abstract mixin class MutationIdle implements SyncMutation, AsyncMutation {}

abstract mixin class MutationLoading implements AsyncMutation {}

abstract mixin class MutationSuccess implements SyncMutation, AsyncMutation {}

abstract mixin class MutationFailure implements SyncMutation, AsyncMutation {
  @override
  Object get error;
  @override
  StackTrace get stackTrace;
}
