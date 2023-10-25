# Riverpod Mutations Generator

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
