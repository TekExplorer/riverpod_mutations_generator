// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

import 'dart:async';

import 'package:meta/meta.dart';
// ignore: implementation_imports
import 'package:riverpod/src/internals.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';

part 'mut_provider.dart';
part 'mut_ref.dart';

typedef MutAction<T, Action extends Function> = (Mut<T>, Action);

extension MutActionX<State, Action extends Function>
    on MutAction<State, Action> {
  Action get action => $2;
  Mut<State> get state => $1;

  MutAction<State, Action> withState(Mut<State> state) => (state, action);
}

extension MutMap<State> on Mut<State> {
  V map<V>({
    required V Function(MutIdle self) idle,
    required V Function(MutError self) error,
    required V Function(MutSuccess<State> self) success,
  }) =>
      switch (this) {
        final MutIdle self => idle(self),
        final MutError self => error(self),
        final MutSuccess<State> self => success(self),
      };
}

extension<State> on Mut<State> {
  Mut<State> toLoading() {
    if (isLoading) return this;
    return map(
      idle: (self) => MutIdle.loading,
      error: (self) => MutError.loading(self.error, self.stackTrace),
      success: (self) => MutSuccess.loading(self.result),
    );
  }

  Mut<State> toNotLoading() {
    if (!isLoading) return this;
    return map(
      idle: (self) => MutIdle.idle,
      error: (self) => MutError(self.error, self.stackTrace),
      success: (self) => MutSuccess(self.result),
    );
  }
}

sealed class MutResult<State extends Object?> implements Mut<State> {}

sealed class Mut<State extends Object?> {
  static Future<MutResult<T>> guard<T>(FutureOr<T> Function() cb) =>
      guardAsync(() async => cb());

  static Future<MutResult<T>> guardAsync<T>(Future<T> Function() cb) =>
      Future.sync(cb).then<MutResult<T>>(MutSuccess.new).onError(MutError.new);

  static MutResult<T> guardSync<T>(T Function() cb) {
    try {
      return MutSuccess(cb());
    } catch (e, s) {
      return MutError(e, s);
    }
  }

  static const idle = MutIdle.idle;
  const factory Mut.error(Object error, StackTrace stackTrace) = MutError;
  const factory Mut.success(State result) = MutSuccess;

  bool get isLoading;

  State? get result;

  Object? get error;
  StackTrace? get stackTrace;

  @override
  operator ==(Object other) =>
      other is Mut<State> &&
      other.runtimeType == runtimeType &&
      other.isLoading == isLoading &&
      other.result == result &&
      other.error == error;

  @override
  int get hashCode => Object.hash(result, error);
}

enum MutIdle implements Mut<Never> {
  idle,
  loading(true);

  const MutIdle([this.isLoading = false]);

  @override
  final bool isLoading;

  @override
  final Null result = null;

  @override
  final Null error = null;

  @override
  final Null stackTrace = null;
}

final class MutError implements Mut<Never>, MutResult<Never> {
  const MutError.loading(
    this.error,
    this.stackTrace,
  ) : isLoading = true;

  const MutError(
    this.error,
    this.stackTrace,
  ) : isLoading = false;

  @override
  final bool isLoading;

  @override
  final Null result = null;

  @override
  final Object error;

  @override
  final StackTrace stackTrace;
}

final class MutSuccess<State extends Object?>
    implements Mut<State>, MutResult<State> {
  const MutSuccess.loading(this.result) : isLoading = true;
  const MutSuccess(this.result) : isLoading = false;
  @override
  final bool isLoading;

  @override
  final State result;

  @override
  final Null error = null;

  @override
  final Null stackTrace = null;
}
