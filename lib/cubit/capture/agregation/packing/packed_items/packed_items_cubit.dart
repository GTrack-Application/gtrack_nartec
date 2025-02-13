import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/packing/packed_items/packed_items_state.dart';
import 'package:gtrack_nartec/models/capture/aggregation/packing/PackedItemsModel.dart';

class PackedItemsCubit extends Cubit<PackedItemsState> {
  PackedItemsCubit() : super(PackedItemsInitial());

  void getPackedItems(String gtin) async {
    emit(PackedItemsLoading());

    try {
      List<PackedItemsModel> data =
          await AssemblingController.getPackedItems(gtin);
      emit(PackedItemsLoaded(data: data));
    } catch (e) {
      emit(
          PackedItemsError(message: "No Packed items found for this Location"));
    }
  }
}
