import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Receiving/raw_materials/direct_receipt/direct_receipt_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/association/receiving/raw_materials/direct_receipt/direct_receipt_state.dart';
import 'package:nb_utils/nb_utils.dart';

class DirectReceiptCubit extends Cubit<DirectReceiptState> {
  DirectReceiptCubit() : super(DirectReceiptInitial());

  getReceivingTypes() async {
    try {
      var network = await isNetworkAvailable();
      if (network) {
        emit(DirectReceiptLoading());

        List<Map<String, dynamic>> data =
            await DirectReceiptController.getReceivingTypes();

        emit(DirectReceiptLoaded(directReceiptModel: data));
      } else {
        emit(DirectReceiptError(message: 'No Internet Connection'));
      }
    } catch (error) {
      emit(DirectReceiptError(message: error.toString()));
    }
  }
}
