import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_controller/sscc_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_cubit/add_sscc_state.dart';

class AddSSCCCubit extends Cubit<AddSSCCState> {
  AddSSCCCubit() : super(AddSSCCInitial());

  void addSSCCByPallet(
    String ssccType,
    String vendorId,
    String vendorName,
    String productId,
    String productDesc,
    String serialNo,
    String itemCode,
    String qty,
    String useBy,
    String batchNo,
    String boxOf,
  ) async {
    emit(AddSSCCLoading());
    try {
      await SsccController.addSsccByPallet(
        ssccType,
        vendorId,
        vendorName,
        productId,
        productDesc,
        serialNo,
        itemCode,
        qty,
        useBy,
        batchNo,
        boxOf,
      );
      emit(AddSSCCAddedByPallet());
    } catch (e) {
      emit(AddSSCCError(error: e.toString()));
    }
  }

  void addSSCCByLabel(
    String ssccType,
    String hsnSkuNo,
    String poNo,
    String expDate,
    String vendorId,
    String cartonQty,
    String shipTo,
    String shipDate,
    String vendorItemNo,
    String desc,
    String shortQtyCode,
    String carton,
    String origin,
  ) async {
    emit(AddSSCCLoading());
    try {
      await SsccController.addSsccByLabel(
        ssccType,
        hsnSkuNo,
        poNo,
        expDate,
        vendorId,
        cartonQty,
        shipTo,
        shipDate,
        vendorItemNo,
        desc,
        shortQtyCode,
        carton,
        origin,
      );
      emit(AddSSCCAddedByLabel());
    } catch (e) {
      emit(AddSSCCError(error: e.toString()));
    }
  }
}
