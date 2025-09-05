# Riverpod Mutations Annotation

## 2.0.0-dev.4

For `2.0.0-dev.3` of the generator

Changes the wrapper to instead be a forwarder to `Mutation` itself

## 2.0.0-dev.3

Fix an issue where a single key results in a single value, and not a record.

It now accepts any Object

(probably shouldn't have skipped dev.1)

## 2.0.0-dev.2

Revamped to use riverpod's included mutations as of `v3.0.0-dev.17`

The type is now `(MutationState<ResultT>, Future<ResultT> Function(...))`

You can also reset the mutation by doing `provider.doSomething.reset(ref)`

You can also access the original mutation with `..doSomething.mutation`

- The above reset method just forwards to the mutation object.

Much simpler, now that its just a wrapper of sorts.

### Notice: Invalidation does nothing

## 2.0.0-dev.0

Replaced the 4 mutation types with Mut with MutIdle, MutError, and MutSuccess.
An isLoading field indicates a loading state instead of a separate state.

No distinction between a sync or async mutation

The mutation type is now a record of `(Mut<State>, Action extends Function)` instead of a generated callable class.

the provider is also much simpler now, no need to know about mut keys or notifier keys, just pass the the provider in, the mutation keys, and the name of the method for equality to take over.

## 1.0.4

Export `ProviderListenable`

## 1.0.3

Add super-interfaces for mutation classes that have values

- `MutationResult<T>`
- `MutationSuccessResult<T>`

Remove duplicated code

## 1.0.2

Add super-interfaces for all mutation classes to inherit

- `AsyncMutation`: `MutationIdle`, `MutationSuccess`, `MutationFailure`, `MutationLoading`
- `SyncMutation`: `MutationIdle`, `MutationSuccess`, `MutationFailure`

## 1.0.2-dev.2

Removed `MutationBase`

- Really should just make extensions on `AsyncMutation` or `SyncMutation` directly, as an `isLoading` extension has no use on a `SyncMutation` which does not have a loading state

## 1.0.2-dev.1

Unseal AsyncMutation and SyncMutation

## 1.0.2-dev

Added super-interfaces for all mutation classes to inherit

## 1.0.1

Drop `meta` dependency version to allow for use with the current release of flutter

## 1.0.0

Initial version.
