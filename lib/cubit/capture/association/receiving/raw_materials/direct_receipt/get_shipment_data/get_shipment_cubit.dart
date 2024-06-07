import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Receiving/raw_materials/direct_receipt/direct_receipt_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/association/receiving/raw_materials/direct_receipt/get_shipment_data/get_shipment_state.dart';
import 'package:nb_utils/nb_utils.dart';

class GetShipmentCubit extends Cubit<GetShipmentState> {
  GetShipmentCubit() : super(GetShipmentInitial());

  Future<void> getShipmentData(
    String receivingTypeId,
    String shipmentIdNo,
  ) async {
    emit(GetShipmentLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(GetShipmentError(message: "No Internet Connection"));
      }
      final shipmentData = await DirectReceiptController.getShipmentData(
          receivingTypeId, shipmentIdNo);
      emit(GetShipmentLoaded(shipment: shipmentData));
    } catch (e) {
      emit(GetShipmentError(message: e.toString()));
    }
  }
}
