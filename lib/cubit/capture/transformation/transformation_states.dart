abstract class EventStationState {}

class EventStationInitState extends EventStationState {}

class EventStationLoadingState extends EventStationState {}

class EventStationLoadedState extends EventStationState {}

class EventStationErrorState extends EventStationState {
  final String message;

  EventStationErrorState({required this.message});
}

// Selected Event Station States
abstract class SelectedEventStationState {}

class SelectedEventStationInitState extends SelectedEventStationState {}

class SelectedEventStationLoadingState extends SelectedEventStationState {}

class SelectedEventStationLoadedState extends SelectedEventStationState {}

class SelectedEventStationErrorState extends SelectedEventStationState {
  final String message;

  SelectedEventStationErrorState({required this.message});
}

// Transaction Save States
class TransactionSavingState extends SelectedEventStationState {}

class TransactionSavedState extends SelectedEventStationState {
  final dynamic data;

  TransactionSavedState({this.data});
}

class TransactionSaveErrorState extends SelectedEventStationState {
  final String message;

  TransactionSaveErrorState({required this.message});
}
