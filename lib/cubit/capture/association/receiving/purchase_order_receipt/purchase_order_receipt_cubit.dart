import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_controller.dart';
import 'package:gtrack_nartec/cubit/capture/association/receiving/purchase_order_receipt/purchase_order_receipt_state.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_model.dart';

class PurchaseOrderReceiptCubit extends Cubit<PurchaseOrderReceiptState> {
  PurchaseOrderReceiptCubit() : super(PurchaseOrderReceiptInitial());

  List<PurchaseOrderReceiptModel> purchaseOrderReceipt = [];

  Future<void> getPurchaseOrderReceipt() async {
    emit(PurchaseOrderReceiptLoading());
    try {
      final purchaseOrderReceipt =
          await PurchaseOrderReceiptController.getPurchaseOrderReceipt();
      this.purchaseOrderReceipt = purchaseOrderReceipt;
      emit(PurchaseOrderReceiptLoaded(purchaseOrderReceipt));
    } catch (e) {
      emit(PurchaseOrderReceiptError(e.toString()));
    }
  }

  Future<void> handleRetrievePOs() async {
    try {
      emit(PurchaseOrderDetailsLoading());
      final purchaseOrderDetails =
          await PurchaseOrderReceiptController.handleRetrievePOs();
      emit(PurchaseOrderDetailsLoaded(purchaseOrderDetails));
    } catch (e) {
      emit(PurchaseOrderDetailsError(e.toString()));
    }
  }

  Future<void> handleSearch(String filter) async {
    try {
      emit(PurchaseOrderDetailsLoading());
      final purchaseOrderDetails =
          await PurchaseOrderReceiptController.handleSearch(filter);

      emit(PurchaseOrderDetailsFilterLoaded(purchaseOrderDetails));
    } catch (e) {
      emit(PurchaseOrderDetailsError(e.toString()));
    }
  }

  Future<void> searchPalletNumber(String palletNumber) async {
    try {
      emit(PalletNumberDetailsLoading());
      final palletNumberDetails =
          await PurchaseOrderReceiptController.searchPalletNumber(palletNumber);
      emit(PalletNumberDetailsLoaded(palletNumberDetails));
    } catch (e) {
      emit(PalletNumberDetailsError(e.toString()));
    }
  }

  Future<void> createBatchSerial(
      PurchaseOrderDetailsModel purchaseOrderDetails,
      String itemType,
      String palletNo,
      String batchNumber,
      String expiryDate,
      String netWeight,
      String sourceGln,
      String destinationGln,
      String shipmentDate,
      String expectedDeliveryDate) async {
    emit(CreateBatchSerialLoading());
    try {
      await PurchaseOrderReceiptController.createExpectedGoodsReceipt(
        purchaseOrderDetails,
        itemType,
        palletNo,
        batchNumber,
        expiryDate,
        netWeight,
        sourceGln,
        destinationGln,
        shipmentDate,
        expectedDeliveryDate,
      );
      emit(CreateBatchSerialLoaded());
    } catch (e) {
      emit(CreateBatchSerialError(e.toString()));
    }
  }
}
