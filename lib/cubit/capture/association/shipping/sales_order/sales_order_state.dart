import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';

class SalesOrderState {}

class SalesOrderInitial extends SalesOrderState {}

class SalesOrderLoading extends SalesOrderState {}

class SalesOrderLoaded extends SalesOrderState {
  final List<SalesOrderModel> salesOrder;
  SalesOrderLoaded(this.salesOrder);
}

class SalesOrderError extends SalesOrderState {
  final String message;
  SalesOrderError(this.message);
}

class SubSalesOrderLoading extends SalesOrderState {}

class SubSalesOrderLoaded extends SalesOrderState {
  final List<SubSalesOrderModel> subSalesOrder;
  SubSalesOrderLoaded(this.subSalesOrder);
}

class SubSalesOrderError extends SalesOrderState {
  final String message;
  SubSalesOrderError(this.message);
}

class MapModelLoading extends SalesOrderState {}

class MapModelLoaded extends SalesOrderState {
  final List<MapModel> mapModel;
  MapModelLoaded(this.mapModel);
}

class MapModelError extends SalesOrderState {
  final String message;
  MapModelError(this.message);
}

class StatusUpdateLoading extends SalesOrderState {}

class StatusUpdateLoaded extends SalesOrderState {
  final String message;
  StatusUpdateLoaded(this.message);
}

class StatusUpdateError extends SalesOrderState {
  final String message;
  StatusUpdateError(this.message);
}

class SignatureUploadLoading extends SalesOrderState {}

class SignatureUploadLoaded extends SalesOrderState {
  final String message;
  SignatureUploadLoaded(this.message);
}

class SignatureUploadError extends SalesOrderState {
  final String message;
  SignatureUploadError(this.message);
}

class ImageUploadLoading extends SalesOrderState {}

class ImageUploadLoaded extends SalesOrderState {
  final String message;
  ImageUploadLoaded(this.message);
}

class ImageUploadError extends SalesOrderState {
  final String message;
  ImageUploadError(this.message);
}
