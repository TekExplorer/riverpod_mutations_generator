# Riverpod Mutations Generator

## 2.0.0-dev.5

Bump to riverpod 3.0.0 proper
Support non-generated providers
Support static methods

## 2.0.0-dev.4

Bump to riverpod 3.0.0-dev.18

## 2.0.0.dev.3

Changed tracks again to make the api like _this_ in order to match traditional usage of the `Mutation` object

```dart
final MutationState<T> state = ref.watch(todosProvider.addTodo);
await todosProvider.addTodo.run(ref, Todo(...));
// traditionally
final addTodoMutation = Mutation<void>();
await addTodoMutation.run(ref, (ref) {...});
```

Of course, the `(state, action)` syntax may still be valuable, so its available as an extension as so:

```dart
final (state, addTodo) = ref.watch(todosProvider.addTodo.pair);
await addTodo(Todo(...));
```

## 2.0.0-dev.2

Forget all of that and wrap riverpod 3.0.0-dev.17's mutations for a state of `(MutationState<ResultT>, F extends Function)`

- Access the original mutation by doing `yourProvider.yourMutation.mutation`
- Reset the mutation by doing `yourProvider.yourMutation.reset(ref)`
  - At least until invalidation forwarding comes around

Dependencies have been updated

- `3.0.0-dev.17` on all riverpod dependencies
- `source_gen` bumped to v3
  - many associated dependencies are bumped too

- No longer depending on `code_builder`
  - Switched to using `analyzer_buffer` by @rrousselGit

## 2.0.0-dev.1

Bump source_gen to v2.0.0 and analyzer to v7

## 2.0.0-dev.0

Replaced the 4 mutation types with `Mut` with `MutIdle`, `MutError`, and `MutSuccess`.
An isLoading field indicates a loading state instead of a separate state.

No distinction between a sync or async mutation

The mutation type is now a record of `(Mut<State>, Action extends Function)` instead of a generated callable class.

the provider is also much simpler now, no need to know about mut keys or notifier keys, just pass the the provider in, the mutation keys, and the name of the method for equality to take over.

## 1.0.9

Go back to a previous method with the hope it breaks less (as keeps happening _immediately_ after publishing - of course - not before)

## 1.0.8

_Don't_ break nullable parameters

## 1.0.7

Once more, let's not forget the _other_ spot that needed the fix.

## 1.0.6

Turn the metaphorical wrench a few more times. (fix `InvalidType` again)

## 1.0.5

Hopefully fix instances where the generator produces `InvalidType`

## 1.0.4

Fixed a couple bugs in generation

Support eager `FutureOr` returns (ie. `FutureOr<String> getValue() => 'Eager'`) which skips MutationLoading

Add result super-interfaces `MutationResult<T>` and `MutationSuccessResult<T>` (which implements `MutationResult<T>`)

- This allows you to make extensions on mutations that have results, allowing you to do things like `bool get hasValue => value != null;`
- Notice, this does not handle nullable return types.

## 1.0.3

Add super-interfaces to all mutation classes

- `AsyncMutation`: `MutationIdle`, `MutationSuccess`, `MutationFailure`, `MutationLoading`
- `SyncMutation`: `MutationIdle`, `MutationSuccess`, `MutationFailure`

## 1.0.3-dev.4

Fix a bug regarding `.result` breaking classes

## 1.0.3-dev.3

Support returned values from a notifier method with `.result`

## 1.0.3-dev.2

Add dependencies to the mutation providers

## 1.0.3-dev.1

Fixed an issue where a private notifier generated a private extension

## 1.0.3-dev

Added super-interfaces for all mutation classes to inherit

## 1.0.2

Expand dependencies to allow greater compatibility with other packages

## 1.0.1

Fixed a bug where a `@mutationKey` failed when the surrounding provider was not a family

## 1.0.0

Refactor to have less bad generator code.

Supports annotating methods on an `@riverpod` class with `@mutation` to generate a `final yourMethod = ref.watch(yourProvider.yourMethod)` setup that allows you to track the state of a mutating method.

Supports annotating parameters on an `@mutation` method with `@mutationKey` to make those parameters act as family parameters for that method

- say, `final yourMethod = ref.watch(yourProvider.yourMethod(id: 2))`
- where, `void yourMethod({required int id}) ()`
- used as, `yourMethod();`
  - The family-ified method's parameter is removed from the caller, as it's already stored in the object in `yourMethod.params.id`

## 1.0.0-dev

Initial upload
