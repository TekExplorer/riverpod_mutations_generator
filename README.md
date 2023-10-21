# Riverpod Mutations Generator

Hello! This is an attempt to cover the gap left behind by the lack of mutation support in riverpod.

Simply tag a notifier method with `@mutation` from `riverpod_mutations_annotation` and run build_runner as normal!

The method should then be accessible via `final yourMethod ref.watch(yourProvider.yourMethod)`

And called with `yourMethod(...)` somewhere.
