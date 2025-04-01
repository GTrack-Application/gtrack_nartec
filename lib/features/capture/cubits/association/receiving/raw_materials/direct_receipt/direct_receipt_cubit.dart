import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/controllers/Association/Receiving/raw_materials/direct_receipt/direct_receipt_controller.dart';
import 'package:gtrack_nartec/features/capture/cubits/association/receiving/raw_materials/direct_receipt/direct_receipt_state.dart';

class DirectReceiptCubit extends Cubit<DirectReceiptState> {
  DirectReceiptCubit() : super(DirectReceiptInitial());

  getReceivingTypes() async {
    try {
      emit(DirectReceiptLoading());

      List<Map<String, dynamic>> data =
          await DirectReceiptController.getReceivingTypes();

      emit(DirectReceiptLoaded(directReceiptModel: data));
    } catch (error) {
      emit(DirectReceiptError(message: error.toString()));
    }
  }
}
