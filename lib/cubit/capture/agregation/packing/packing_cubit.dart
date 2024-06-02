import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/packing/gtin_product_details_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/packing/packing_state.dart';
import 'package:nb_utils/nb_utils.dart';

class PackingCubit extends Cubit<PackingState> {
  PackingCubit() : super(PackingInitial());

  void identifyGln(String barcode) async {
    emit(PackingLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(PackingError(message: "No Internet Connection"));
      }
      final data =
          await GtinProductDetailsController.getGtinProductDetails(barcode);
      emit(PackingLoaded(data: data));
    } catch (e) {
      emit(PackingError(message: e.toString()));
    }
  }
}
