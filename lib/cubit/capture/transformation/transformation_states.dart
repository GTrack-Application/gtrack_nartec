abstract class TransformationState {}

class EventStationInitState extends TransformationState {}

class EventStationLoadingState extends TransformationState {}

class EventStationLoadedState extends TransformationState {}

class EventStationErrorState extends TransformationState {
  final String message;

  EventStationErrorState({required this.message});
}

class SelectedEventStationInitState extends TransformationState {}

class SelectedEventStationLoadingState extends TransformationState {}

class SelectedEventStationLoadedState extends TransformationState {}

class SelectedEventStationErrorState extends TransformationState {
  final String message;

  SelectedEventStationErrorState({required this.message});
}

// Transaction Save States
class TransactionSavingState extends TransformationState {}

class TransactionSavedState extends TransformationState {
  final dynamic data;

  TransactionSavedState({this.data});
}

class TransactionSaveErrorState extends TransformationState {
  final String message;

  TransactionSaveErrorState({required this.message});
}
