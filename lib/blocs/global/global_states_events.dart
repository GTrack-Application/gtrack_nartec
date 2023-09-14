// Events

abstract class GlobalEvent {}

class GlobalInitEvent extends GlobalEvent {}

class GlobalDataEvent extends GlobalEvent {
  final dynamic data;
  GlobalDataEvent(this.data);
}

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
