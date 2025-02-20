import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/ItemReallocation/ItemReAllocationTableDataController.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';

part 'packaging_state.dart';

class PackagingCubit extends Cubit<PackagingState> {
  PackagingCubit() : super(PackagingInitial());

  final HttpService httpService = HttpService();

  final ssccController = TextEditingController();
  List<GetItemInfoByPalletCodeModel> items = [];
  Map<String, dynamic> itemsWithPallet = {};

  void scanItem() async {
    emit(PackagingScanLoading());

    try {
      final result = await ItemReAllocationTableDataController.getAllTable(
        ssccController.text.trim(),
      );

      if (itemsWithPallet.containsKey(ssccController.text.trim())) {
        emit(PackagingScanError(message: "Pallet already scanned"));
        print("pallet already scanned");
        return;
      } else {
        itemsWithPallet[ssccController.text.trim()] = {
          'palletCode': ssccController.text.trim(),
          'items': result,
          'count': result.length,
        };
      }

      // // Check if the item is already in the list
      // final newItems = result
      //     .where((item) => !items.any(
      //           (e) =>
      //               e.cID == item.cID &&
      //               e.pO == item.pO &&
      //               e.itemCode == item.itemCode,
      //         ))
      //     .toList();

      // items.addAll(newItems);
      items.add(result.first);

      ssccController.clear();

      emit(PackagingScanLoaded());
    } catch (error) {
      emit(PackagingScanError(message: error.toString()));
    }
  }

  void insertPackaging(String type) async {
    emit(PackagingInsertLoading());

    try {
      final memberId = await AppPreferences.getMemberId();
      final response = await httpService
          .request("/api/packaging/insert", method: HttpMethod.post, data: {
        "memberId": memberId,
        "palletCodes": items.map((e) => e.palletCode.toString()).toList(),
        "type": type,
      });

      if (response.success) {
        itemsWithPallet.clear();
        items.clear();
        emit(PackagingInsertLoaded());
      }
    } catch (error) {
      emit(PackagingInsertError(message: error.toString()));
    }
  }
}
