# Riverpod Mutations Annotation

See `riverpod_mutations_generator`'s readme

Supports `@mutation` on a Notifier's method or top-level function.

Use `@mutationPair` for access to `ProviderListenable<(MutationState<T>, F extends Function)> get .pair`

Supports `@mutationKey` on an `@mutation` annotated function or method's parameter.
