abstract class RecordsState {}

class RecordsInitial extends RecordsState {}

class RecordsLoading extends RecordsState {}

class RecordsLoaded extends RecordsState {
  final List<dynamic> data;
  RecordsLoaded({required this.data});
}

class RecordsError extends RecordsState {
  final String error;
  RecordsError({required this.error});
}
