import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Transfer/ItemReallocation/ItemReAllocationTableDataController.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Transfer/ItemReAllocation/GetItemInfoByPalletCodeModel.dart';
import 'package:gtrack_nartec/models/capture/aggregation/packaging/packaging_master_model.dart';

part 'packaging_state.dart';

class PackagingCubit extends Cubit<PackagingState> {
  PackagingCubit() : super(PackagingInitial());

  static PackagingCubit get(BuildContext context) =>
      BlocProvider.of<PackagingCubit>(context);

  final HttpService httpService = HttpService();

  final ssccController = TextEditingController();
  List<GetItemInfoByPalletCodeModel> items = [];
  Map<String, dynamic> itemsWithPallet = {};

  List<PackagingMasterModel> packagingMasters = [];
  PackagingPaginationModel? pagination;
  int currentPage = 1;
  bool hasMoreData = true;
  int limit = 10;

  void scanItem() async {
    emit(PackagingScanLoading());

    try {
      final result = await ItemReAllocationTableDataController.getAllTable(
        ssccController.text.trim(),
      );

      if (itemsWithPallet.containsKey(ssccController.text.trim())) {
        emit(PackagingScanError(message: "Pallet already scanned"));
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
        "memberId": memberId.toString(),
        "palletCodes": items.map((e) => "${e.palletCode}").toList(),
        "type": type,
      });

      if (response.success) {
        itemsWithPallet.clear();
        items.clear();
        emit(PackagingInsertLoaded(message: response.message));
      }
    } catch (error) {
      emit(PackagingInsertError(message: error.toString()));
    }
  }

  Future<void> getPackagingMasters({
    bool refresh = false,
    bool loadMore = false,
  }) async {
    if (refresh) {
      currentPage = 1;
      packagingMasters.clear();
    }

    if (state is PackagingMasterLoading) return;

    final currentState = state;

    if (!refresh && currentState is PackagingMasterLoaded) {
      if (currentPage >= (pagination?.totalPages ?? 1)) return;
      currentPage += 1;
    }

    if (loadMore) {
      emit(PackagingLoadingMoreState(
        currentData: packagingMasters,
        hasMoreData: hasMoreData,
      ));
    } else {
      emit(PackagingMasterLoading());
    }

    try {
      final url = "/api/packaging/master?page=$currentPage&limit=$limit";
      final response = await httpService.request(url);

      if (response.success) {
        final List<PackagingMasterModel> newPackages =
            (response.data['data'] as List)
                .map((e) => PackagingMasterModel.fromJson(e))
                .toList();

        pagination =
            PackagingPaginationModel.fromJson(response.data['pagination']);

        hasMoreData = currentPage < (pagination?.totalPages ?? 1);

        if (refresh) {
          packagingMasters = newPackages;
        } else {
          packagingMasters.addAll(newPackages);
          // final totalPages = (response.totalProducts / _pageSize).ceil();
          // final hasMore = _currentPage < totalPages;
        }

        emit(PackagingMasterLoaded(
          packages: packagingMasters,
          hasReachedEnd: currentPage >= (pagination?.totalPages ?? 1),
        ));
      }
    } catch (error) {
      emit(PackagingMasterError(message: error.toString()));
    }
  }

  void loadMore() {
    try {
      if (state is PackagingLoadingMoreState) return;
      if (state is PackagingMasterLoading) return;
      if (currentPage >= (pagination?.totalPages ?? 1)) return;
      if (hasMoreData) {
        emit(PackagingLoadingMoreState(
          currentData: packagingMasters,
          hasMoreData: hasMoreData,
        ));
      }
      if (hasMoreData) {
        currentPage += 1;
        getPackagingMasters(loadMore: true);
      }
    } catch (error) {
      emit(PackagingMasterError(message: error.toString()));
    }
  }
}
