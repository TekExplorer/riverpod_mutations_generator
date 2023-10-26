// sealed class MutationBase {
//   Object? get error;
//   StackTrace? get stackTrace;
// }

abstract mixin class SyncMutation /*implements MutationBase */ {
  // @override
  Object? get error;
  // @override
  StackTrace? get stackTrace;
}

abstract mixin class AsyncMutation /*implements MutationBase */ {
  // @override
  Object? get error;
  // @override
  StackTrace? get stackTrace;
}

abstract mixin class MutationIdle implements SyncMutation, AsyncMutation {
  @override
  Object? get error;
  @override
  StackTrace? get stackTrace;
}

abstract mixin class MutationLoading implements AsyncMutation {
  @override
  Object? get error;
  @override
  StackTrace? get stackTrace;
}

abstract mixin class MutationSuccess implements SyncMutation, AsyncMutation {
  @override
  Object? get error;
  @override
  StackTrace? get stackTrace;
}

abstract mixin class MutationFailure implements SyncMutation, AsyncMutation {
  @override
  Object get error;
  @override
  StackTrace get stackTrace;
}
