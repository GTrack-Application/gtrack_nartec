abstract class EventStationState {}

class EventStationInitState extends EventStationState {}

class EventStationLoadingState extends EventStationState {}

class EventStationLoadedState extends EventStationState {}

class EventStationErrorState extends EventStationState {
  final String message;

  EventStationErrorState({required this.message});
}

class SelectedEventStationInitState extends EventStationState {}

class SelectedEventStationLoadingState extends EventStationState {}

class SelectedEventStationLoadedState extends EventStationState {}

class SelectedEventStationErrorState extends EventStationState {
  final String message;

  SelectedEventStationErrorState({required this.message});
}

// Transaction Save States
class TransactionSavingState extends EventStationState {}

class TransactionSavedState extends EventStationState {
  final dynamic data;

  TransactionSavedState({this.data});
}

class TransactionSaveErrorState extends EventStationState {
  final String message;

  TransactionSaveErrorState({required this.message});
}
