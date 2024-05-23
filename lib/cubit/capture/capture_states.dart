part of 'capture_cubit.dart';

abstract class CaptureState {}

class CaptureInitial extends CaptureState {}

// * LOADING ***

class CaptureSerializationLoading extends CaptureState {}

class CaptureCreateSerializationLoading extends CaptureState {}

// * SUCCESS ***

class CaptureSerializationSuccess extends CaptureState {
  final List<SerializationModel> data;

  CaptureSerializationSuccess(this.data);
}

class CaptureCreateSerializationSuccess extends CaptureState {
  final String message;

  CaptureCreateSerializationSuccess(this.message);
}

// * ERROR ***

class CaptureSerializationError extends CaptureState {
  final String message;

  CaptureSerializationError(this.message);
}

class CaptureCreateSerializationError extends CaptureState {
  final String message;

  CaptureCreateSerializationError(this.message);
}
