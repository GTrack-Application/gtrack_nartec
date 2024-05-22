part of 'capture_cubit.dart';

abstract class CaptureState {}

class CaptureInitial extends CaptureState {}

// * LOADING ***

class CaptureSerializationLoading extends CaptureState {}

// * SUCCESS ***

class CaptureSerializationSuccess extends CaptureState {
  final List<SerializationModel> data;

  CaptureSerializationSuccess(this.data);
}

// * ERROR ***

class CaptureSerializationError extends CaptureState {
  final String message;

  CaptureSerializationError(this.message);
}
