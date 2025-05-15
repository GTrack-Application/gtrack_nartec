import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/epcis_controller.dart';
import 'package:gtrack_nartec/features/capture/cubits/association_internal_goodsIssue_productionJobOrder/production_job_order_state.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/bin_locations_model.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/bom_start_model.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/mapped_barcodes_model.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/production_job_order.dart';
import 'package:gtrack_nartec/features/capture/models/association_internal_goodsIssue_productionJobOrder/production_job_order_bom.dart';
import 'package:gtrack_nartec/features/capture/models/scan_packages/container_response_model.dart';
import 'package:gtrack_nartec/features/capture/models/scan_packages/pallet_response_model.dart';
import 'package:gtrack_nartec/features/capture/models/scan_packages/serial_response_model.dart';
import 'package:gtrack_nartec/features/capture/models/scan_packages/sscc_response_model.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/shipping/vehicle_model.dart';

class ProductionJobOrderCubit extends Cubit<ProductionJobOrderState> {
  ProductionJobOrderCubit() : super(ProductionJobOrderInitial());

  // HTTP Services
  final HttpService _httpService = HttpService();
  final HttpService _httpServiceForDomain = HttpService(
    baseUrl: AppUrls.domain,
  );

  ProductionJobOrderDetail? jobOrderDetail;
  ProductionJobOrder? order;
  String bomStartType = 'pallet';
  List<MappedBarcode> items = [];
  late BomStartModel gs1Data;

  List<ProductionJobOrder> filteredOrders = [];
  List<ProductionJobOrder> _orders = [];
  List<VehicleModel> _vehicles = [];
  List<BinLocation> binLocations = [];
  VehicleModel? selectedVehicle;
  BinLocation? selectedBinLocation;
  int quantityPicked = 0;
  String? selectedGLN;

  // Maps
  final Map<String, List<Map>> _packagingScanResults = {};
  final List<Map> _selectedpackagingScanResults = [];

  // Getters
  List<VehicleModel> get vehicles => _vehicles;
  Map<String, List<Map>> get packagingScanResults => _packagingScanResults;
  List<Map> get selectedpackagingScanResults => _selectedpackagingScanResults;

  // Selected Data
  SubSalesOrderModel? selectedSubSalesOrder;

  /*
  ##############################################################################
  ! Packaging Scan
  ##############################################################################
  */

  // Item selection methods
  void toggleItemSelection(Map item) {
    final existingIndex = _selectedpackagingScanResults.indexWhere((element) =>
        element['serialGTIN'] == item['serialGTIN'] &&
        element['serialNo'] == item['serialNo']);

    if (existingIndex >= 0) {
      _selectedpackagingScanResults.removeAt(existingIndex);
      quantityPicked--;
    } else {
      // // If picked quantity is equal to the quantity, don't fetch mapped barcodes
      if (quantityPicked >= (jobOrderDetail?.quantity ?? 0)) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'You have reached the maximum quantity',
        ));
        return;
      }

      _selectedpackagingScanResults.add(item);
      quantityPicked++;
    }
    emit(PackagingSelectionChanged(selected: _selectedpackagingScanResults));
  }

  bool isItemSelected(Map item) {
    return _selectedpackagingScanResults.any((element) =>
        element['serialGTIN'] == item['serialGTIN'] &&
        element['serialNo'] == item['serialNo']);
  }

  void clearSelectedItems() {
    _selectedpackagingScanResults.clear();
    quantityPicked = 0;
    emit(PackagingSelectionChanged(selected: _selectedpackagingScanResults));
  }

  Future<void> getMappedBarcodes(
    String gtin, {
    String? palletCode,
    String? serialNo,
  }) async {
    if (state is ProductionJobOrderMappedBarcodesLoading) return;
    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Pallet code is required',
        ));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Serial number is required',
        ));
        return;
      }
    }
    emit(ProductionJobOrderMappedBarcodesLoading());
    try {
      // If picked quantity is equal to the quantity, don't fetch mapped barcodes
      if (quantityPicked >= (jobOrderDetail?.quantity ?? 0)) {
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
            message: 'No mapped barcodes found for $gtin',
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
        if (jobOrderDetail != null) {
          jobOrderDetail = jobOrderDetail!.increasePickedQuantity();
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

  Future<void> scanPackagingBySscc({
    String? palletCode,
    String? serialNo,
  }) async {
    if (state is ProductionJobOrderMappedBarcodesLoading) {
      return;
    }

    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Pallet code is required',
        ));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Serial number is required',
        ));
        return;
      }
    }
    emit(ProductionJobOrderMappedBarcodesLoading());
    try {
      final token = await AppPreferences.getToken();

      // check if the ssccNo is already scanned
      if (_packagingScanResults.containsKey(serialNo ?? palletCode)) {
        emit(ProductionJobOrderMappedBarcodesError(
            message: 'Packaging already scanned'));
        return;
      }

      final path = palletCode != null
          ? '/api/scanPackaging/sscc?ssccNo=$palletCode'
          : '/api/ssccPackaging/details?serialNo=$serialNo&association=true';

      // call the API
      final response = await _httpService.request(
        path,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.success) {
        // If we are scanning by pallet
        if (palletCode != null) {
          if (response.data['level'] == 'container') {
            final containerData =
                ContainerResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final pallet in containerData.container.pallets) {
              for (final ssccPackage in pallet.ssccPackages) {
                for (final detail in ssccPackage.details) {
                  _packagingScanResults[palletCode]!.add({
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
          } else if (response.data['level'] == 'pallet') {
            final palletData = PalletResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final pallet in palletData.pallet.ssccPackages) {
              for (final detail in pallet.details) {
                _packagingScanResults[palletCode]!.add({
                  "ssccNo": pallet.ssccNo,
                  "description": pallet.description,
                  "memberId": pallet.memberId,
                  "binLocationId": pallet.binLocationId,
                  "masterPackagingId": detail.masterPackagingId,
                  "serialGTIN": detail.serialGTIN,
                  "serialNo": detail.serialNo,
                });
              }
            }
          } else if (response.data['level'] == 'sscc') {
            final ssccData = SSCCResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final detail in ssccData.sscc.details) {
              _packagingScanResults[palletCode]!.add({
                "ssccNo": ssccData.sscc.ssccNo,
                "description": ssccData.sscc.description,
                "memberId": ssccData.sscc.memberId,
                "binLocationId": ssccData.sscc.binLocationId,
                "masterPackagingId": detail.masterPackagingId,
                "serialGTIN": detail.serialGTIN,
                "serialNo": detail.serialNo,
              });
            }
          }
        }

        // If we are scanning by serial
        else if (serialNo != null) {
          final serialResponse = SerialResponseModel.fromJson(response.data);
          // Initialize an empty list for this ssccNo if it doesn't exist yet
          if (!_packagingScanResults.containsKey(serialNo)) {
            _packagingScanResults[serialNo] = [];
          }

          for (final item in serialResponse.data.items) {
            _packagingScanResults[serialNo]!.add({
              "ssccNo": item.masterPackaging.ssccNo,
              "description": item.masterPackaging.description,
              "memberId": item.masterPackaging.memberId,
              "binLocationId": item.masterPackaging.binLocationId,
              "masterPackagingId": item.masterPackaging.id,
              "serialGTIN": item.serialGTIN,
              "serialNo": item.serialNo,
            });
          }
        }

        // Emit the loaded state with the scan results for this SSCC
        // emit(PackagingScanLoaded(response: _packagingScanResults));
        emit(ProductionJobOrderMappedBarcodesLoaded(
          mappedBarcodes: _packagingScanResults,
        ));
      } else {
        final errorMessage =
            response.data?['message'] ?? 'Failed to scan packaging';
        emit(ProductionJobOrderMappedBarcodesError(message: errorMessage));
      }
    } catch (error) {
      emit(ProductionJobOrderMappedBarcodesError(message: error.toString()));
    }
  }

  void pickSelectedItems({required String orderDetailId}) async {
    try {
      if (state is PickItemsLoading) {
        return;
      }

      emit(PickItemsLoading());
      final path = '/api/packagingPickActivity';
      final payload = _selectedpackagingScanResults
          .map((scannedItem) => {
                "contextType": "sales",
                "contextId": orderDetailId,
                "serialGTIN": scannedItem['serialGTIN'],
                "serialNo": scannedItem['serialNo'],
                "pickedQuantity": "1",
                "binLocationId": scannedItem['binLocationId'],
                "pickedBy": scannedItem['memberId']
              })
          .toList();

      log(payload.toString());

      final response = await _httpService.request(
        path,
        method: HttpMethod.post,
        payload: payload,
      );

      if (response.success) {
        emit(PickItemsLoaded(message: response.data['message']));
      } else {
        emit(PickItemsError(message: response.data['message']));
      }
    } catch (e) {
      emit(PickItemsError(message: e.toString()));
    }
  }

  void updateMappedBarcodes(
    String location, {
    ProductionJobOrder? oldOrder,
    int? qty,
    String? gln,
  }) async {
    emit(ProductionJobOrderUpdateMappedBarcodesLoading());

    final gs1CompanyPrefix = await AppPreferences.getGs1Prefix();
    try {
      final results = await Future.any([
        // update bom API call
        _httpService.request(
          "/api/bom/${jobOrderDetail?.id}", // sales order detail id
          method: HttpMethod.put,
          payload: {
            'binLocation': location,
            'quantityPicked': "$quantityPicked",
          },
        ),

        _httpService.request(
          "/api/workInProgress/submitPickAndCreateWIP",
          method: HttpMethod.post,
          payload: {
            'jobOrderDetailId': "${jobOrderDetail?.jobOrderDetailsId}",
          },
        ),
        // update mapped barcodes API call
        // _httpService.request(
        //   "/api/salesInvoice/master/${oldOrder?.id}", // job order id
        //   method: HttpMethod.put,
        //   payload: {
        //     'binLocationId': location,
        //   },
        // ),

        // Then update Job Order Details
        _httpService.request(
          "/api/jobOrder/details/${jobOrderDetail?.jobOrderDetailsId}",
          method: HttpMethod.put,
          payload: {
            "binLocationId": selectedBinLocation?.id.toString(),
          },
        ),

        // EPCIS API Call
        EPCISController.insertNewEPCISEvent(
          // eventType: "TransactionEvent",
          eventType: "AssociationEvent",
          latitude: selectedBinLocation?.latitude?.toString(),
          longitude: selectedBinLocation?.longitude?.toString(),
          gln: selectedBinLocation?.gln,
          ssccNo: selectedpackagingScanResults.first['ssccNo'],
          bizTransactionList: [
            {
              "type": "po",
              "bizTransaction":
                  "http://transaction.acme.com/jo/${jobOrderDetail?.jobOrderDetailsId}"
            },
          ],
          childEPCs: selectedpackagingScanResults
              .map((item) =>
                  'urn:epc:id:sscc:$gs1CompanyPrefix.${item['ssccNo']}')
              .toList(),
        ),
      ]);

      // // EPCIS API Call
      // await EPCISController.insertEPCISEvent(
      //   type: "Transaction Event",
      //   action: "ADD",
      //   bizStep: "shipping",
      //   disposition: "in_transit",
      // );

      // await _httpService.request(
      //   // "/api/bom/${oldOrder?.jobOrderMaster?.id}",
      //   "/api/bom/${bomStartData?.id}", // jobOrderId || id
      //   method: HttpMethod.put,
      //   data: {
      //     'binLocation': location,
      //     'quantityPicked': "$quantityPicked",
      //   },
      // );

      emit(ProductionJobOrderUpdateMappedBarcodesLoaded(
        message: "Packaging process completed",
        updatedCount: selectedpackagingScanResults.length,
      ));
    } catch (e) {
      emit(ProductionJobOrderUpdateMappedBarcodesError(message: e.toString()));
    }
  }

  /*
  ##############################################################################
  ! End
  ##############################################################################
  */

  Future<void> getProductionJobOrders() async {
    emit(ProductionJobOrderLoading());
    try {
      final memberId = await AppPreferences.getMemberId();
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
            data.map((e) => ProductionJobOrderDetail.fromJson(e)).toList();
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
          gs1Data = BomStartModel.fromJson(data['products'][0]);
          emit(ProductionJobOrderBomStartLoaded(bomStartData: gs1Data));
        } else {
          gs1Data = BomStartModel();
          emit(ProductionJobOrderBomStartError(
              message: 'Product Details not found for $barcode'));
        }
      } else {
        emit(ProductionJobOrderBomStartError(
            message: 'Failed to fetch product details'));
      }
    } catch (e) {
      emit(ProductionJobOrderBomStartError(message: e.toString()));
    }
  }

  Future<void> getBinLocations() async {
    emit(ProductionJobOrderBinLocationsLoading());
    try {
      final memberId = await AppPreferences.getMemberId();
      final token = await AppPreferences.getToken();

      // final url = "/api/mappedBarcodes/getlocationsByGTIN?GTIN=$gtin";
      final url = "/api/binLocation?memberId=$memberId";

      final response = await _httpService.request(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final data = response.data as List;
        final binLocations = data.map((e) => BinLocation.fromJson(e)).toList();
        this.binLocations = binLocations;

        emit(ProductionJobOrderBinLocationsLoaded(binLocations: binLocations));
      } else {
        emit(ProductionJobOrderBinLocationsError(
            message: 'Failed to fetch bin locations'));
      }
    } catch (e) {
      emit(ProductionJobOrderBinLocationsError(message: e.toString()));
    }
  }

  Future<void> getMappedBarcodesByVehicle(
    String gtin, {
    String? palletCode,
    String? serialNo,
  }) async {
    if (state is ProductionJobOrderMappedBarcodesLoading) return;
    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Pallet code is required',
        ));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ProductionJobOrderMappedBarcodesError(
          message: 'Serial number is required',
        ));
        return;
      }
    }
    emit(ProductionJobOrderMappedBarcodesLoading());
    try {
      // If picked quantity is equal to the quantity, don't fetch mapped barcodes
      if (quantityPicked >= (selectedSubSalesOrder?.quantity ?? 0)) {
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
            message: 'No mapped barcodes found for $gtin',
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
        if (selectedSubSalesOrder != null) {
          selectedSubSalesOrder =
              selectedSubSalesOrder?.increasePickedQuantity();
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

  void updateMappedBarcodesByVehicle(
    String location,
    List<MappedBarcode> scannedItems, {
    int? qty,
  }) async {
    emit(ProductionJobOrderUpdateMappedBarcodesLoading());

    try {
      final itemIds = scannedItems.map((item) => item.id).toList();

      final response = await _httpService.request(
        "/api/mappedBarcodes/updateBinLocationForMappedBarcodes",
        method: HttpMethod.put,
        payload: {
          'ids': itemIds,
          'newBinLocation': location,
        },
      );

      await Future.any([
        // EPCIS API Call
        // EPCISController.insertEPCISEvent(
        //   type: "Transaction Event",
        //   action: "ADD",
        //   bizStep: "shipping",
        //   disposition: "in_transit",
        //   gln: selectedVehicle?.glnIdNumber,
        // ),

        EPCISController.insertNewEPCISEvent(
          eventType: "TransactionEvent",
          latitude: selectedBinLocation?.latitude?.toString(),
          longitude: selectedBinLocation?.longitude?.toString(),
          gln: selectedBinLocation?.gln?.toString(),
        ),

        // update mapped barcodes API call
        _httpService.request(
          "/api/salesInvoice/details/${selectedSubSalesOrder?.id}",
          method: HttpMethod.put,
          payload: {
            'quantityPicked': qty,
            'vehicleId': selectedVehicle?.id.toString(),
          },
        ).catchError((error) {
          throw Exception(error.data['message'] ??
              error.data['error'] ??
              'Failed to update mapped barcodes');
        }),
      ]);

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
      emit(ProductionJobOrderUpdateMappedBarcodesError(message: e.toString()));
    }
  }

  void clearItems() {
    items = [];
    quantityPicked = 0;
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(
        data: items,
        message: "All items cleared successfully",
      ),
    ));
  }

  void removeItem(MappedBarcode item) {
    items.remove(item);
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(
          data: items, message: "Item removed successfully"),
    ));
  }

  /*
  ##############################################################################
  ! Sales Order
  ##############################################################################
  */

  Future<void> getVehicles() async {
    emit(VehiclesLoading());
    try {
      final token = await AppPreferences.getToken();
      final memberId = await AppPreferences.getMemberId();

      if (memberId == null) {
        throw Exception("Member ID not found");
      }

      final response = await _httpService.request(
        '/api/vehicle?member_id=$memberId',
        method: HttpMethod.get,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.success) {
        final List<dynamic> data = response.data;
        _vehicles = data.map((e) => VehicleModel.fromJson(e)).toList();
        emit(VehiclesLoaded(vehicles: _vehicles));
      } else {
        emit(VehiclesError(message: response.message));
      }
    } catch (error) {
      emit(VehiclesError(message: error.toString()));
    }
  }

  void setSelectedVehicle(VehicleModel vehicle) {
    selectedVehicle = vehicle;
    emit(VehiclesLoaded(vehicles: _vehicles));
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(
        data: items,
        message: null,
      ),
    ));
  }

  void clearAll() {
    items = [];
    quantityPicked = 0;
    // selectedSubSalesOrder?.quantityPicked = 0;
    emit(ProductionJobOrderMappedBarcodesLoaded(
      mappedBarcodes: MappedBarcodesResponse(data: items),
    ));
  }
}
