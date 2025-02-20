import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/packing/gtin_product_details_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packing_state.dart';

class PackingCubit extends Cubit<PackingState> {
  PackingCubit() : super(PackingInitial());

  static PackingCubit get(BuildContext context) => context.read<PackingCubit>();

  void identifyGln(String barcode) async {
    emit(PackingLoading());
    try {
      final data =
          await GtinProductDetailsController.getGtinProductDetails(barcode);
      emit(PackingLoaded(data: data));
    } catch (e) {
      emit(PackingError(message: e.toString()));
    }
  }
}
