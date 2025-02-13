import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/get_bundle_items/bundle_items_state.dart';

class BundleItemsCubit extends Cubit<BundleItemsState> {
  BundleItemsCubit() : super(BundleItemsInitial());

  void getBundleItems() async {
    emit(BundleItemsLoading());

    try {
      final data = await AssemblingController.getBundleItems();
      emit(BundleItemsLoaded(items: data));
    } catch (e) {
      emit(BundleItemsError(message: e.toString()));
    }
  }

  void getAssembleItems() async {
    emit(BundleItemsLoading());

    try {
      final data = await AssemblingController.getAssembleItems();
      emit(AssembleItemsLoaded(items: data));
    } catch (e) {
      emit(BundleItemsError(message: e.toString()));
    }
  }
}
