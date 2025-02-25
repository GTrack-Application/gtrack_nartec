part of 'capture_cubit.dart';

abstract class CaptureState {}

class CaptureInitial extends CaptureState {}

// * LOADING ***

class CaptureSerializationLoading extends CaptureState {}

class CaptureCreateSerializationLoading extends CaptureState {}

class CaptureGetGtinProductsLoading extends CaptureState {}

// * EMPTY ***

class CaptureSerializationEmpty extends CaptureState {}

// * SUCCESS ***

class CaptureSerializationSuccess extends CaptureState {
  final List<SerializationModel> data;

  CaptureSerializationSuccess(this.data);
}

class CaptureCreateSerializationSuccess extends CaptureState {
  final String message;

  CaptureCreateSerializationSuccess(this.message);
}

class CaptureGetGtinProductsSuccess extends CaptureState {
  final List<GTINModell> data;

  CaptureGetGtinProductsSuccess(this.data);
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

class CaptureGetGtinProductsError extends CaptureState {
  final String message;

  CaptureGetGtinProductsError(this.message);
}
