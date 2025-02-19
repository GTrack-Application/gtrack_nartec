import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/cubit/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/epcis_controller.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bin_locations_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bom_start_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/mapped_barcodes_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order_bom.dart';
import 'package:http/http.dart' as http;

class ProductionJobOrderCubit extends Cubit<ProductionJobOrderState> {
  ProductionJobOrderCubit() : super(ProductionJobOrderInitial());

  ProductionJobOrderBom? bomStartData;
  String bomStartType = 'pallet';
  List<MappedBarcode> items = [];

  Future<void> getProductionJobOrders() async {
    emit(ProductionJobOrderLoading());
    try {
      final memberId = await AppPreferences.getUserId();
      final token = await AppPreferences.getToken();

      final response = await http.get(
        Uri.parse(
            '${AppUrls.baseUrlWith7010}/api/jobOrder/details?memberId=$memberId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final orders = data.map((e) => ProductionJobOrder.fromJson(e)).toList();
        emit(ProductionJobOrderLoaded(orders: orders));
      } else {
        emit(ProductionJobOrderError(message: 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(ProductionJobOrderError(message: e.toString()));
    }
  }

  Future<void> getProductionJobOrderBom(String jobOrderDetailsId) async {
    emit(ProductionJobOrderBomLoading());
    try {
      final token = await AppPreferences.getToken();

      final response = await http.get(
        Uri.parse(
            '${AppUrls.baseUrlWith7010}/api/bom?jobOrderDetailsId=$jobOrderDetailsId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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

      final response = await http.get(
        Uri.parse(
            '${AppUrls.domain}/api/products/paginatedProducts?page=1&pageSize=10&barcode=$barcode'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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

      final response = await http.get(
        Uri.parse(
            '${AppUrls.baseUrlWith7010}/api/mappedBarcodes/getlocationsByGTIN?GTIN=$gtin'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
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
      final token = await AppPreferences.getToken();
      String url = '';
      if (palletCode != null) {
        url =
            '${AppUrls.baseUrlWith7010}/api/mappedBarcodes?PalletCode=$palletCode&GTIN=$gtin';
      } else if (serialNo != null) {
        url =
            '${AppUrls.baseUrlWith7010}/api/mappedBarcodes?ItemSerialNo=$serialNo&GTIN=$gtin';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final mappedBarcodes = MappedBarcodesResponse.fromJson(data);
        if (mappedBarcodes.data?.isEmpty ?? true) {
          emit(ProductionJobOrderMappedBarcodesError(
            message: 'No mapped barcodes found',
          ));
          return;
        }
        // add all new list but don't add duplicates
        final newItems = mappedBarcodes.data
            ?.where((element) => !items.any((e) => e.id == element.id))
            .toList();
        items.addAll(newItems ?? []);
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

  Future<void> updateMappedBarcodes(
      String location, List<MappedBarcode> scannedItems) async {
    emit(ProductionJobOrderUpdateMappedBarcodesLoading());

    try {
      final token = await AppPreferences.getToken();
      final url = Uri.parse(
          '${AppUrls.baseUrlWith7010}/api/mappedBarcodes/updateBinLocationForMappedBarcodes');

      final itemIds = scannedItems.map((item) => item.id).toList();

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'ids': itemIds,
          'newBinLocation': location,
        }),
      );

      // EPCIS API Call
      await EPCISController.insertEPCISEvent(
        type: "Transaction Event",
        action: "ADD",
        bizStep: "shipping",
        disposition: "in_transit",
      );

      log(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
}
