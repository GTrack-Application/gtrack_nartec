import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/pallet_number_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_model.dart';

class PurchaseOrderReceiptState {}

class PurchaseOrderReceiptInitial extends PurchaseOrderReceiptState {}

class PurchaseOrderReceiptLoading extends PurchaseOrderReceiptState {}

class PurchaseOrderReceiptLoaded extends PurchaseOrderReceiptState {
  final List<PurchaseOrderReceiptModel> purchaseOrderReceipt;
  PurchaseOrderReceiptLoaded(this.purchaseOrderReceipt);
}

class PurchaseOrderReceiptError extends PurchaseOrderReceiptState {
  final String message;
  PurchaseOrderReceiptError(this.message);
}

class PurchaseOrderDetailsLoading extends PurchaseOrderReceiptState {}

class PurchaseOrderDetailsLoaded extends PurchaseOrderReceiptState {
  final List<PurchaseOrderDetailsModel> purchaseOrderDetails;
  PurchaseOrderDetailsLoaded(this.purchaseOrderDetails);
}

class PurchaseOrderDetailsFilterLoaded extends PurchaseOrderReceiptState {
  final List<PurchaseOrderDetailsModel> purchaseOrderDetails;
  PurchaseOrderDetailsFilterLoaded(this.purchaseOrderDetails);
}

class PurchaseOrderDetailsError extends PurchaseOrderReceiptState {
  final String message;
  PurchaseOrderDetailsError(this.message);
}

class PalletNumberDetailsLoading extends PurchaseOrderReceiptState {}

class PalletNumberDetailsLoaded extends PurchaseOrderReceiptState {
  final List<PalletNumberDetailsModel> palletNumberDetails;
  PalletNumberDetailsLoaded(this.palletNumberDetails);
}

class PalletNumberDetailsError extends PurchaseOrderReceiptState {
  final String message;
  PalletNumberDetailsError(this.message);
}

class CreateBatchSerialLoading extends PurchaseOrderReceiptState {}

class CreateBatchSerialLoaded extends PurchaseOrderReceiptState {}

class CreateBatchSerialError extends PurchaseOrderReceiptState {
  final String message;
  CreateBatchSerialError(this.message);
}
