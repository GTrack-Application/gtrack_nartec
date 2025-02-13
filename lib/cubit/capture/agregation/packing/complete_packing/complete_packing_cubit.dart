import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/packing/gtin_product_details_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/complete_packing/complete_packing_state.dart';

class CompletePackingCubit extends Cubit<CompletePackingState> {
  CompletePackingCubit() : super(CompletePackingInitial());

  void completePacking(
    String gtin,
    String batchNo,
    String manufacturingDate,
    String expiryDate,
    int quantity,
    String gln,
    double netWeight,
    String unitOfMeasure,
    String itemImage,
    String itemName,
  ) async {
    emit(CompletePackingLoading());

    try {
      await GtinProductDetailsController.completePacking(
        gtin,
        batchNo,
        manufacturingDate,
        expiryDate,
        quantity,
        gln,
        netWeight,
        unitOfMeasure,
        itemImage,
        itemName,
      );
      emit(CompletePackingLoaded());
    } catch (e) {
      emit(CompletePackingError(message: e.toString()));
    }
  }
}
