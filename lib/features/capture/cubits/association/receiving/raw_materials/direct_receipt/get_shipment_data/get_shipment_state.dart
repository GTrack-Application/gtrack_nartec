import 'package:gtrack_nartec/features/capture/models/Association/Receiving/raw_materials/direct_receipt/ShipmentDataModel.dart';

abstract class GetShipmentState {}

class GetShipmentInitial extends GetShipmentState {}

class GetShipmentLoading extends GetShipmentState {}

class GetShipmentLoaded extends GetShipmentState {
  final ShipmentDataModel shipment;

  GetShipmentLoaded({required this.shipment});
}

class GetShipmentError extends GetShipmentState {
  final String message;

  GetShipmentError({required this.message});
}
