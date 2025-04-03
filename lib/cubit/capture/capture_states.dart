part of 'capture_cubit.dart';

abstract class CaptureState {}

class CaptureInitial extends CaptureState {}

// * LOADING ***

class CaptureSerializationLoading extends CaptureState {}

class CaptureCreateSerializationLoading extends CaptureState {}

class CaptureGetGtinProductsLoading extends CaptureState {}

class CaptureStockMasterLoading extends CaptureState {}

class CaptureCreateMappedBarcodeLoading extends CaptureState {}

// * EMPTY ***

class CaptureSerializationEmpty extends CaptureState {}

class CaptureStockMasterEmpty extends CaptureState {}

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

class CaptureStockMasterSuccess extends CaptureState {
  final List<StockMasterModel> data;
  CaptureStockMasterSuccess(this.data);
}

class CaptureCreateMappedBarcodeSuccess extends CaptureState {
  final String message;
  CaptureCreateMappedBarcodeSuccess(this.message);
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

class CaptureStockMasterError extends CaptureState {
  final String message;
  CaptureStockMasterError(this.message);
}

class CaptureCreateMappedBarcodeError extends CaptureState {
  final String message;
  CaptureCreateMappedBarcodeError(this.message);
}
