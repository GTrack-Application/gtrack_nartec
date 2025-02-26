import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/epcis_controller.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bin_locations_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bom_start_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/mapped_barcodes_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order_bom.dart';

class ProductionJobOrderCubit extends Cubit<ProductionJobOrderState> {
  ProductionJobOrderCubit() : super(ProductionJobOrderInitial());
  final HttpService _httpService = HttpService();
  final HttpService _httpServiceForDomain =
      HttpService(baseUrl: AppUrls.domain);

  ProductionJobOrderBom? bomStartData;
  String bomStartType = 'pallet';
  List<MappedBarcode> items = [];

  List<ProductionJobOrder> filteredOrders = [];
  List<ProductionJobOrder> _orders = [];

  int quantityPicked = 0;

  Future<void> getProductionJobOrders() async {
    emit(ProductionJobOrderLoading());
    try {
      final memberId = await AppPreferences.getUserId();
      final token = await AppPreferences.getToken();

      final response = await _httpService
          .request("/api/jobOrder/details?memberId=$memberId", headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.success) {
        final List<dynamic> data = response.data;
        final orders = data.map((e) => ProductionJobOrder.fromJson(e)).toList();
        _orders = orders;
        emit(ProductionJobOrderLoaded(orders: orders));
      } else {
        emit(ProductionJobOrderError(message: 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(ProductionJobOrderError(message: e.toString()));
    }
  }

  Future<void> searchProductionJobOrders(String query) async {
    try {
      log(query);
      if (query.isEmpty) {
        filteredOrders = _orders;
        emit(ProductionJobOrderLoaded(orders: _orders));
        return;
      }
      final orders = _orders.where((element) {
        return element.jobOrderMaster?.jobOrderNumber
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      }).toList();
      filteredOrders = orders;
      emit(ProductionJobOrderLoaded(orders: orders));
    } catch (e) {
      emit(ProductionJobOrderError(message: e.toString()));
    }
  }

  Future<void> getProductionJobOrderBom(String jobOrderDetailsId) async {
    emit(ProductionJobOrderBomLoading());
    try {
      final token = await AppPreferences.getToken();
      final response = await _httpService
          .request("/api/bom?jobOrderDetailsId=$jobOrderDetailsId", headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.success) {
        final List<dynamic> data = response.data;
        final bomItems =
            data.map((e) => ProductionJobOrderBom.fromJson(e)).toList();
        emit(ProductionJobOrderBomLoaded(bomItems: bomItems));
      } else {
        emit(ProductionJobOrderBomError(message: 'Failed to fetch BOM items'));
      }
    } catch (e) {
      emit(ProductionJobOrderBomError(message: e.toString()));
    }
  }

  Future<void> getBomStartDetails(String barcode) async {
    emit(ProductionJobOrderBomStartLoading());
    try {
      final token = await AppPreferences.getToken();

      final response = await _httpServiceForDomain.request(
        "/api/products/paginatedProducts?page=1&pageSize=10&barcode=$barcode",
        method: HttpMethod.get,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final data = response.data;
        if (data['products']?.isNotEmpty ?? false) {
          final bomStartData = BomStartModel.fromJson(data['products'][0]);
          emit(ProductionJobOrderBomStartLoaded(bomStartData: bomStartData));
        } else {
          emit(ProductionJobOrderBomStartError(message: 'No product found'));
        }
      } else {
        emit(ProductionJobOrderBomStartError(
            message: 'Failed to fetch product details'));
      }
    } catch (e) {
      emit(ProductionJobOrderBomStartError(message: e.toString()));
    }
  }

  Future<void> getBinLocations(String gtin) async {
    emit(ProductionJobOrderBinLocationsLoading());
    try {
      final token = await AppPreferences.getToken();

      final response = await _httpService.request(
        "/api/mappedBarcodes/getlocationsByGTIN?GTIN=$gtin",
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final data = response.data;
        final binLocations = BinLocationsResponse.fromJson(data);
        emit(ProductionJobOrderBinLocationsLoaded(binLocations: binLocations));
      } else {
        emit(ProductionJobOrderBinLocationsError(
            message: 'Failed to fetch bin locations'));
      }
    } catch (e) {
      emit(ProductionJobOrderBinLocationsError(message: e.toString()));
    }
  }

  Future<void> getMappedBarcodes(
    String gtin, {
    String? palletCode,
    String? serialNo,
  }) async {
    emit(ProductionJobOrderMappedBarcodesLoading());
    try {
      // If picked quantity is equal to the quantity, don't fetch mapped barcodes
      if (quantityPicked >= (bomStartData?.quantity ?? 0)) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'You have reached the maximum quantity',
        ));
        return;
      }
      final token = await AppPreferences.getToken();
      String url = '/api/mappedBarcodes?';
      if (palletCode != null) {
        url += 'PalletCode=$palletCode&GTIN=$gtin';
      } else if (serialNo != null) {
        url += 'ItemSerialNo=$serialNo&GTIN=$gtin';
      }

      final response = await _httpService.request(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final data = response.data;
        final mappedBarcodes = MappedBarcodesResponse.fromJson(data);
        if (mappedBarcodes.data?.isEmpty ?? true) {
          emit(ProductionJobOrderMappedBarcodesError(
            message: 'No mapped barcodes found',
          ));
          return;
        }
        // add all new list but don't add duplicates
        // final newItems = mappedBarcodes.data
        //     ?.where((element) => !items.any((e) => e.id == element.id))
        //     .toList();
        final newItems = mappedBarcodes.data;
        items.addAll(newItems ?? []);
        // increment quantity
        if (bomStartData != null) {
          bomStartData = bomStartData!.increasePickedQuantity();
          quantityPicked++;
        }

        emit(ProductionJobOrderMappedBarcodesLoaded(
            mappedBarcodes: mappedBarcodes));
      } else {
        emit(ProductionJobOrderMappedBarcodesError(
            message: 'Failed to fetch mapped barcodes'));
      }
    } catch (e) {
      emit(ProductionJobOrderMappedBarcodesError(message: e.toString()));
    }
  }

  Future<void> updateMappedBarcodes(
      String location, List<MappedBarcode> scannedItems) async {
    emit(ProductionJobOrderUpdateMappedBarcodesLoading());

    try {
      final itemIds = scannedItems.map((item) => item.id).toList();

      final response = await _httpService.request(
        "/api/mappedBarcodes/updateBinLocationForMappedBarcodes",
        method: HttpMethod.put,
        data: {
          'ids': itemIds,
          'newBinLocation': location,
        },
      );

      // EPCIS API Call
      await EPCISController.insertEPCISEvent(
        type: "Transaction Event",
        action: "ADD",
        bizStep: "shipping",
        disposition: "in_transit",
      );

      log(response.body);

      if (response.success) {
        final data = response.data;
        emit(ProductionJobOrderUpdateMappedBarcodesLoaded(
          message: data['message'],
          updatedCount: data['updatedCount'],
        ));
      } else {
        throw Exception('Failed to update mapped barcodes');
      }
    } catch (e) {
      log(e.toString());
      emit(ProductionJobOrderUpdateMappedBarcodesError(message: e.toString()));
    }
  }

  void clearItems() {
    items = [];
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(
          data: items, message: "All items cleared successfully"),
    ));
  }

  void removeItem(MappedBarcode item) {
    items.remove(item);
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(
          data: items, message: "Item removed successfully"),
    ));
  }
}
