import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/goods_receipt/job_order/job_order_asset_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/goods_receipt/job_order/job_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/shipping/scan_packages/container_response_model.dart';

part 'job_order_state.dart';

class JobOrderCubit extends Cubit<JobOrderState> {
  JobOrderCubit() : super(JobOrderInitial());

  static JobOrderCubit get(BuildContext context) =>
      BlocProvider.of<JobOrderCubit>(context);

  final HttpService _httpService = HttpService();

  // Lists
  final List<JobOrderBillOfMaterial> _selectedItems = [];
  List<JobOrderModel> orders = [];
  final List<JobOrderAssetModel> _assets = [];

  // Maps
  final Map<String, List<JobOrderAssetModel>> _assetsByTagNumber = {};
  final Map<String, List<Map>> _packagingScanResults = {};

  // Getters
  get items => _selectedItems;
  List<JobOrderAssetModel> get assets => _assets;
  Map<String, List<Map>> get packagingScanResults => _packagingScanResults;

  // Other Variables
  bool isSaveAssetTagsForSalesOrder = false;

  Future<void> getJobOrders() async {
    emit(JobOrderLoading());
    try {
      final token = await AppPreferences.getToken();
      final response = await _httpService.request(
        '/api/workInProgress/items',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final List<dynamic> data = response.data;
        orders = data.map((e) => JobOrderModel.fromJson(e)).toList();

        emit(JobOrderLoaded(orders: orders));
      } else {
        emit(JobOrderError(message: 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(JobOrderError(message: e.toString()));
    }
  }

  Future<void> getJobOrderBomDetails(String wipItemId) async {
    emit(JobOrderDetailsLoading());
    try {
      final token = await AppPreferences.getToken();
      final url = '/api/workInProgress/wipBom?wipItemId=$wipItemId';
      final response = await _httpService.request(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final List<dynamic> data = response.data;
        final bomDetails =
            data.map((e) => JobOrderBillOfMaterial.fromJson(e)).toList();

        _selectedItems.clear();
        _selectedItems.addAll(bomDetails);

        emit(JobOrderDetailsLoaded(bomDetails: bomDetails));
      } else {
        emit(JobOrderDetailsError(message: 'Failed to fetch BOM details'));
      }
    } catch (e) {
      emit(JobOrderDetailsError(message: e.toString()));
    }
  }

  void selectJobOrderItem(int index) {
    // unselect all items
    for (var element in _selectedItems) {
      element.isSelected = -1;
    }
    final item = _selectedItems[index];
    item.isSelected = item.isSelected == -1 ? 1 : -1;
    emit(JobOrderDetailsLoaded(bomDetails: _selectedItems));
  }

  void addToProduction() {
    try {
// get selected item
      final selectedItems =
          _selectedItems.where((element) => element.isSelected == 1).toList();
      if (selectedItems.isEmpty) {
        throw Exception("No items selected");
      }
      for (var item in selectedItems) {
        if (item.status == "picked") {
          throw Exception("Item is already picked");
        }
      }

      // ignore: unused_local_variable
      final selectedItem = selectedItems.first;
      // TODO: Add to production
    } catch (error) {
      emit(AddToProductionError(message: error.toString()));
    }
  }

  void getAssetsByTagNumber(String tagNumber) async {
    if (state is AssetsByTagNumberLoading) {
      return;
    }
    emit(AssetsByTagNumberLoading());
    try {
      final token = await AppPreferences.getToken();
      if (_assetsByTagNumber.containsKey(tagNumber)) {
        emit(AssetsByTagNumberError(message: 'Assets already scanned'));
        return;
      }

      final response = await _httpService.request(
        '/api/assetCapture/getMasterEncodeAssetCaptureFinal?TagNumber=$tagNumber',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.success) {
        final List<dynamic> data = response.data["data"];
        final assets = data.map((e) => JobOrderAssetModel.fromJson(e)).toList();

        _assets.addAll(assets);
        _assetsByTagNumber[tagNumber] = assets;
        emit(AssetsByTagNumberLoaded());
      } else {
        emit(AssetsByTagNumberError(message: 'Failed to fetch assets'));
      }
    } catch (error) {
      emit(AssetsByTagNumberError(message: error.toString()));
    }
  }

  void saveAssetTags(
    String jobOrderMasterId,
    DateTime productionExecutionDateTime,
  ) async {
    if (state is SaveAssetTagsLoading) {
      return;
    }
    emit(SaveAssetTagsLoading());
    try {
      if (_assets.isEmpty) {
        throw Exception("No assets selected");
      }
      final token = await AppPreferences.getToken();
      final response = await _httpService.request(
        '/api/wipAsset/createWIPAssetInProgress',
        method: HttpMethod.post,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        payload: {
          'jobOrderMasterId': jobOrderMasterId,
          'productionExecutionDateTime':
              productionExecutionDateTime.toUtc().toIso8601String(),
          'tblAssetMasterEncodeAssetCaptureIDs': assets
              .map(
                (asset) => asset.tblAssetMasterEncodeAssetCaptureID.toInt(),
              )
              .toList(),
        },
      );
      if (response.success) {
        emit(SaveAssetTagsLoaded());
      } else {
        emit(SaveAssetTagsError(message: response.message));
      }
    } catch (error) {
      emit(SaveAssetTagsError(message: error.toString()));
    }
  }

  void saveAssetTagsForSalesOrder(
    String jobOrderMasterId,
    DateTime productionExecutionDateTime,
    SubSalesOrderModel? salesOrder,
  ) async {
    if (state is SaveAssetTagsLoading) {
      return;
    }
    emit(SaveAssetTagsLoading());
    try {
      if (_assets.isEmpty) {
        throw Exception("No assets selected");
      }
      final token = await AppPreferences.getToken();
      final response = await _httpService.request(
        '/api/equipmentUsage',
        method: HttpMethod.post,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        payload: assets
            .map(
              (e) => {
                "salesInvoiceNumber":
                    "${salesOrder?.salesInvoiceMaster?.salesInvoiceNumber}",
                "salesInvoiceDetailsId": "${salesOrder?.id}",
                // "jobOrderNo": "${salesOrder?.id}",
                // "poNumber": "${e.poNumber}",
                "productionLine": e.productionLine?.text,
                "TblAssetMasterEncodeAssetCaptureID":
                    e.tblAssetMasterEncodeAssetCaptureID,
                "processName": "sales_delivery"
              },
            )
            .toList(),
      );
      if (response.success) {
        // will show a button to navigate to bin location screen
        isSaveAssetTagsForSalesOrder = true;

        emit(SaveAssetTagsLoaded());
      } else {
        emit(SaveAssetTagsError(message: response.message));
      }
    } catch (error) {
      emit(SaveAssetTagsError(message: error.toString()));
    }
  }

  Future<void> scanPackagingBySscc(String ssccNo) async {
    if (state is PackagingScanLoading) {
      return;
    }
    emit(PackagingScanLoading());
    try {
      final token = await AppPreferences.getToken();

      // check if the ssccNo is already scanned
      if (_packagingScanResults.containsKey(ssccNo)) {
        emit(PackagingScanError(message: 'Packaging already scanned'));
        return;
      }

      // call the API
      final response = await _httpService.request(
        '/api/scanPackaging/sscc?ssccNo=$ssccNo',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.success) {
        if (response.data['level'] == 'container') {
          final containerData = ContainerResponseModel.fromJson(response.data);

          // Initialize an empty list for this ssccNo if it doesn't exist yet
          if (!_packagingScanResults.containsKey(ssccNo)) {
            _packagingScanResults[ssccNo] = [];
          }

          for (final pallet in containerData.container.pallets) {
            for (final ssccPackage in pallet.ssccPackages) {
              for (final detail in ssccPackage.details) {
                _packagingScanResults[ssccNo]!.add({
                  "ssccNo": ssccPackage.ssccNo,
                  "description": ssccPackage.description,
                  "memberId": ssccPackage.memberId,
                  "binLocationId": ssccPackage.binLocationId,
                  "masterPackagingId": detail.masterPackagingId,
                  "serialGTIN": detail.serialGTIN,
                  "serialNo": detail.serialNo,
                });
              }
            }
          }
        }

        log("_packagingScanResults: " + jsonEncode(_packagingScanResults));

        // Emit the loaded state with the scan results for this SSCC
        emit(PackagingScanLoaded(response: _packagingScanResults[ssccNo]));
      } else {
        emit(PackagingScanError(
            message: response.message ?? 'Failed to scan packaging'));
      }
    } catch (error) {
      emit(PackagingScanError(message: error.toString()));
    }
  }
}
