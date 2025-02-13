import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/get_sub_bundle_items/sub_bundle_items_state.dart';

class SubBundleItemsCubit extends Cubit<SubBundleItemsState> {
  SubBundleItemsCubit() : super(SubBundleItemsInitial());

  void getSubBundleItems(String gtin) async {
    emit(SubBundleItemsLoading());

    try {
      final data = await AssemblingController.getSubBundleItems(gtin);
      emit(SubBundleItemsLoaded(items: data));
    } catch (e) {
      emit(SubBundleItemsError(message: e.toString()));
    }
  }

  void getSubAssembleItems(String gtin) async {
    emit(SubBundleItemsLoading());

    try {
      final data = await AssemblingController.getSubAssembleItems(gtin);
      emit(SubBundleItemsLoaded(items: data));
    } catch (e) {
      emit(SubBundleItemsError(message: e.toString()));
    }
  }
}
