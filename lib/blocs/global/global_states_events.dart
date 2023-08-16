// Events

abstract class GlobalEvent {}

class GlobalInitEvent extends GlobalEvent {}

abstract class GlobalState {}

class GlobalInitState extends GlobalState {}

class GlobalLoadingState extends GlobalState {}

class GlobalLoadedState extends GlobalState {
  final dynamic data;

  GlobalLoadedState({required this.data});
}

class GlobalErrorState extends GlobalState {
  final String message;

  GlobalErrorState({required this.message});
}
