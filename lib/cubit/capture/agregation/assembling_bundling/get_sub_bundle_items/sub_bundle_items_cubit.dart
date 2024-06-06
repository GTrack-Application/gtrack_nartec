import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_sub_bundle_items/sub_bundle_items_state.dart';
import 'package:nb_utils/nb_utils.dart';

class SubBundleItemsCubit extends Cubit<SubBundleItemsState> {
  SubBundleItemsCubit() : super(SubBundleItemsInitial());

  void getSubBundleItems(String gtin) async {
    emit(SubBundleItemsLoading());

    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(SubBundleItemsError(message: "No Internet Connection"));
      }
      var data = await AssemblingController.getSubBundleItems(gtin);
      emit(SubBundleItemsLoaded(items: data));
    } catch (e) {
      emit(SubBundleItemsError(message: e.toString()));
    }
  }
}
