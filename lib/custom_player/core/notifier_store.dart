import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';

class NotifierStore<T extends StoreState> extends RxNotifier<T> {
  NotifierStore(super.value);

  void update(T state) {
    value = state;
  }

  T get state => value;

  VoidCallback observer({
    void Function(T state)? onState,
    void Function(ErrorState error)? onError,
    VoidCallback? onLoading,
  }) {
    void listener() {
      var _ = switch (state) {
        ErrorState() => onError?.call(state as ErrorState),
        LoadingState() => onLoading?.call(),
        _ => onState?.call(state),
      };
    }

    addListener(listener);
    return () => removeListener(listener);
  }

  void destroy() {
    dispose();
  }
}

abstract class StoreState {}

class ErrorState implements StoreState {}

class LoadingState implements StoreState {}
