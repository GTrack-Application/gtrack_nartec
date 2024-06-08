part of 'share_cubit.dart';

abstract class ShareState {}

class ShareInitial extends ShareState {}

// Loading

class ShareTraceabilityLoading extends ShareState {}

// * Success

class ShareTraceabilitySuccess extends ShareState {
  final List<TraceabilityModel> traceabilityData;

  ShareTraceabilitySuccess(this.traceabilityData);
}

// ! Error

class ShareTraceabilityError extends ShareState {
  final String message;

  ShareTraceabilityError(this.message);
}
