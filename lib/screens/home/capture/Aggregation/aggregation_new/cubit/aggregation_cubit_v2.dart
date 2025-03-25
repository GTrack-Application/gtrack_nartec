import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';

class AggregationCubit extends Cubit<AggregationState> {
  AggregationCubit() : super(AggregationInitial());

  final HttpService httpService = HttpService();

  List<PackagingModel> packaging = [];
  Map<String, List<SerializationModel>> batchGroups = {};
  Set<String> uniqueBatches = {};
  List<SerializationModel> scannedItems = [];
  String? selectedBatch;
  String? selectedBinLocation;

  void getPackaging() async {
    try {
      emit(AggregationLoading());
      final response = await httpService.request(
        "/api/ssccPackaging?packagingType=box_carton&association=true",
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
  void setSelectedBinLocation(String? location) {
    selectedBinLocation = location;
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
  void savePackaging(String description) async {
    try {
      emit(AggregationLoading());

      // Here you would implement the API call to save the packaging
      // For now, we'll just simulate a successful save

      await Future.delayed(const Duration(seconds: 1));

      emit(PackagingSaved(message: 'Packaging saved successfully'));
    } catch (e) {
      emit(AggregationError(message: e.toString()));
    }
  }
}
