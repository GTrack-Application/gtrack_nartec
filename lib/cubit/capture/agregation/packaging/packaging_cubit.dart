import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/ItemReallocation/ItemReAllocationTableDataController.dart';
import 'package:gtrack_nartec/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';

part 'packaging_state.dart';

class PackagingCubit extends Cubit<PackagingState> {
  PackagingCubit() : super(PackagingInitial());

  final ssccController = TextEditingController();
  List<GetItemInfoByPalletCodeModel> items = [];

  void scanItem() async {
    emit(PackagingScanLoading());

    try {
      final result = await ItemReAllocationTableDataController.getAllTable(
          ssccController.text.trim());

      // Check if the item is already in the list
      final newItems = result
          .where((item) => !items.any(
                (e) =>
                    e.cID == item.cID &&
                    e.pO == item.pO &&
                    e.itemCode == item.itemCode,
              ))
          .toList();

      items.addAll(newItems);

      emit(PackagingScanLoaded());
    } catch (error) {
      emit(PackagingScanError(message: error.toString()));
    }
  }
}
