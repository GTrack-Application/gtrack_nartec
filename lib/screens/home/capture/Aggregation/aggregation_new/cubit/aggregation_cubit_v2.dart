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

  List<PackagingModel> packaging = [];
  Map<String, List<SerializationModel>> batchGroups = {};
  Set<String> uniqueBatches = {};
  List<SerializationModel> scannedItems = [];
  String? selectedBatch;
  String? selectedBinLocationId;
  BinLocation? selectedBinLocation;
  List<PalletizationModel> pallets = [];

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

  // Fetch palletization data
  Future<void> fetchPalletizationData() async {
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
}
