import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/bin_location.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/palletization_model.dart';

class AggregationCubit extends Cubit<AggregationState> {
  AggregationCubit() : super(AggregationInitial());

  final HttpService httpService = HttpService();

  // Lists
  List<PackagingModel> packaging = [];
  List<SerializationModel> scannedItems = [];
  List<PalletizationModel> pallets = [];
  List<PackagingModel> availableSSCCPackages = [];
  List<String> selectedSSCCNumbers = [];

  // Maps
  Map<String, List<SerializationModel>> batchGroups = {};
  Set<String> uniqueBatches = {};

  // Selected
  String? selectedBatch;
  String? selectedBinLocationId;
  BinLocation? selectedBinLocation;
  PackagingModel? selectedSSCCPackage;
  String? selectedPalletId;

  void getPackaging(String type) async {
    try {
      emit(AggregationLoading());
      final response = await httpService.request(
        "/api/ssccPackaging?packagingType=$type&association=true",
        method: HttpMethod.get,
      );
      final res = response.data['data'] as List;
      log(res.toString());
      packaging = res.map((json) => PackagingModel.fromJson(json)).toList();
      emit(AggregationLoaded(packaging: packaging));
    } catch (e) {
      emit(AggregationError(message: e.toString()));
    }
  }

  // Process serialization data and group by batch
  void processSerializationData(List<SerializationModel> data) {
    try {
      emit(PackagingBatchesLoading());

      // Clear previous batch data
      batchGroups.clear();
      uniqueBatches.clear();

      // Group items by batch
      for (var item in data) {
        if (item.bATCH != null) {
          if (!batchGroups.containsKey(item.bATCH)) {
            batchGroups[item.bATCH!] = [];
            uniqueBatches.add(item.bATCH!);
          }
          batchGroups[item.bATCH!]!.add(item);
        }
      }

      // Reset selected batch
      selectedBatch = null;

      // Debug print to verify data
      log('Found ${uniqueBatches.length} unique batches');
      log('Batch groups: ${batchGroups.keys.join(', ')}');

      emit(PackagingBatchesLoaded(
        batchGroups: batchGroups,
        uniqueBatches: uniqueBatches,
      ));
    } catch (e) {
      emit(PackagingBatchesError(message: e.toString()));
    }
  }

  // Set selected batch
  void setSelectedBatch(String? batch) {
    selectedBatch = batch;
    emit(PackagingBatchesLoaded(
      batchGroups: batchGroups,
      uniqueBatches: uniqueBatches,
    ));
  }

  // Set selected bin location
  void setSelectedBinLocation(String? binLocationId) {
    selectedBinLocationId = binLocationId;
    emit(PackagingBatchesLoaded(
      batchGroups: batchGroups,
      uniqueBatches: uniqueBatches,
    ));
  }

  // Add items from a batch
  void addItemsFromBatch(String batchName, int count) {
    if (batchGroups.containsKey(batchName)) {
      final itemsToAdd = batchGroups[batchName]!.take(count).toList();
      scannedItems.addAll(itemsToAdd);
      emit(PackagingItemsAdded(scannedItems: scannedItems));
    }
  }

  // Remove an item
  void removeItem(SerializationModel item) {
    scannedItems.remove(item);
    emit(PackagingItemRemoved(scannedItems: scannedItems));
  }

  // Clear all scanned items
  void clearScannedItems() {
    scannedItems.clear();
    emit(PackagingItemsAdded(scannedItems: scannedItems));
  }

  // Save packaging
  void savePackaging(String description, {required String type}) async {
    try {
      emit(AggregationLoading());

      // Get memberId from preferences
      final memberId = await AppPreferences.getMemberId();

      // Get the bin location ID (using the selectedBinLocation from state)
      final binLocationId = selectedBinLocationId;

      if (memberId == null || binLocationId == null) {
        emit(AggregationError(message: 'Missing member ID or bin location'));
        return;
      }

      // Prepare the serialsList from scanned items
      final serialsList = scannedItems
          .map((item) => {
                "serialGTIN": "${item.gTIN}",
                "serialNo": "${item.serialNo}",
              })
          .toList();

      // Make the API call
      final response = await httpService.request(
        "/api/ssccPackaging",
        method: HttpMethod.post,
        payload: {
          "packagingType": type,
          "description": description,
          "memberId": memberId,
          "binLocationId": binLocationId,
          "serialsList": serialsList,
        },
      );

      if (response.success) {
        emit(PackagingSaved(message: 'Packaging saved successfully'));
        // Clear the scanned items after successful save
        clearScannedItems();
      } else {
        emit(AggregationError(
            message: response.data['message'] ?? 'Failed to save packaging'));
      }
    } catch (e) {
      emit(AggregationError(message: e.toString()));
    }
  }

  /*
  ##############################################################################
  ? Palletization
  ##############################################################################
  */

  // Add selected SSCC package to list
  void addSSCCPackageToSelection(PackagingModel package) {
    if (package.sSCCNo != null &&
        !selectedSSCCNumbers.contains(package.sSCCNo!)) {
      selectedSSCCNumbers.add(package.sSCCNo!);
      emit(SSCCPackageSelectionChanged(
          selectedSSCCNumbers: selectedSSCCNumbers));
    }
  }

  // Remove SSCC package from selection
  void removeSSCCPackageFromSelection(String ssccNo) {
    if (selectedSSCCNumbers.contains(ssccNo)) {
      selectedSSCCNumbers.remove(ssccNo);
      emit(SSCCPackageSelectionChanged(
          selectedSSCCNumbers: selectedSSCCNumbers));
    }
  }

  // Clear SSCC package selection
  void clearSSCCPackageSelection() {
    selectedSSCCNumbers.clear();
    emit(SSCCPackageSelectionChanged(selectedSSCCNumbers: selectedSSCCNumbers));
  }

  /*
  ##############################################################################
  ? Palletization Start
  ##############################################################################
  */

  // Fetch palletization data
  void fetchPalletizationData() async {
    try {
      emit(PalletizationLoading());

      final response = await httpService.request(
        '/api/palletPackaging?status=active&association=true',
      );

      if (response.success) {
        final data = response.data['data'] as List;
        pallets =
            data.map((item) => PalletizationModel.fromJson(item)).toList();
        emit(PalletizationLoaded(pallets: pallets));
      } else {
        emit(PalletizationError(
            message: response.data['message'] ??
                'Failed to load palletization data'));
      }
    } catch (e) {
      emit(PalletizationError(message: e.toString()));
    }
  }

  // Fetch available SSCC packages for palletization
  void fetchAvailableSSCCPackages() async {
    try {
      emit(SSCCPackagesLoading());

      final response = await httpService.request(
        '/api/ssccPackaging?packagingType[]=box_carton&packagingType[]=batching&packagingType[]=grouping&packagingType[]=consolidating',
        method: HttpMethod.get,
      );

      if (response.success) {
        final data = response.data['data'] as List;
        final ssccPackages =
            data.map((item) => PackagingModel.fromJson(item)).toList();

        // Filter out packages that already have a palletId (already assigned to a pallet)
        availableSSCCPackages =
            ssccPackages.where((pkg) => pkg.palletId == null).toList();
        emit(SSCCPackagesLoaded(packages: availableSSCCPackages));
      } else {
        emit(SSCCPackagesError(
            message:
                response.data['message'] ?? 'Failed to load SSCC packages'));
      }
    } catch (e) {
      emit(SSCCPackagesError(message: e.toString()));
    }
  }

  // Create a new pallet with selected SSCC packages
  void createPallet(
    String description,
    List<String> selectedSSCCNumbers,
  ) async {
    try {
      if (state is PalletizationLoading) return;

      if (selectedSSCCNumbers.isEmpty) {
        emit(PalletizationError(message: 'No SSCC packages selected'));
        return;
      }

      if (selectedBinLocationId == null) {
        emit(PalletizationError(message: 'No bin location selected'));
        return;
      }

      if (description.isEmpty) {
        emit(PalletizationError(message: 'No description provided'));
        return;
      }

      emit(PalletizationLoading());

      // Get memberId from preferences
      final memberId = await AppPreferences.getMemberId();

      if (memberId == null || selectedBinLocationId == null) {
        emit(PalletizationError(message: 'Missing member ID or bin location'));
        return;
      }

      // Get package IDs from their SSCC numbers
      List<String> ssccPackageIds = [];
      for (var ssccNo in selectedSSCCNumbers) {
        final package = availableSSCCPackages.firstWhere(
          (pkg) => pkg.sSCCNo == ssccNo,
          orElse: () => PackagingModel(),
        );
        if (package.id != null) {
          ssccPackageIds.add(package.id!);
        }
      }

      final response = await httpService.request(
        '/api/palletPackaging',
        method: HttpMethod.post,
        payload: {
          "description": description,
          "memberId": memberId,
          "binLocationId": selectedBinLocationId,
          "ssccPackageIds": ssccPackageIds,
        },
      );

      if (response.success) {
        final data = response.data['data'];
        final message =
            response.data['message'] ?? 'Pallet created successfully';
        final ssccNo = data['SSCCNo'] ?? '';
        final totalPackages = data['totalSSCCPackages'] ?? 0;

        emit(PalletCreated(
          message: '$message SSCC: $ssccNo, Total packages: $totalPackages',
        ));
      } else {
        emit(PalletizationError(
            message: response.data['message'] ??
                response.data['error'] ??
                'Failed to create pallet'));
      }
    } catch (e) {
      emit(PalletizationError(message: e.toString()));
    }
  }

  void setSelectedSSCCPackage(PackagingModel? package) {
    selectedSSCCPackage = package;
    emit(PalletizationLoaded(pallets: pallets));
  }

  void resetPalletization() {
    selectedSSCCPackage = null;
    selectedBinLocationId = null;
    selectedBinLocation = null;

    availableSSCCPackages = [];
    selectedSSCCNumbers = [];
  }

  /*
  ##############################################################################
  ? Palletization End
  ##############################################################################
  */
}
