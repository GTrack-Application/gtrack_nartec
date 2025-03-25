import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/palletization_model.dart';

abstract class AggregationState {}

class AggregationInitial extends AggregationState {}

class AggregationLoading extends AggregationState {}

class AggregationLoaded extends AggregationState {
  final List<PackagingModel> packaging;

  AggregationLoaded({required this.packaging});
}

class AggregationError extends AggregationState {
  final String message;

  AggregationError({required this.message});
}

// New states for packaging scan item screen
class PackagingBatchesLoading extends AggregationState {}

class PackagingBatchesLoaded extends AggregationState {
  final Map<String, List<SerializationModel>> batchGroups;
  final Set<String> uniqueBatches;

  PackagingBatchesLoaded({
    required this.batchGroups,
    required this.uniqueBatches,
  });
}

class PackagingBatchesError extends AggregationState {
  final String message;

  PackagingBatchesError({required this.message});
}

class PackagingItemsAdded extends AggregationState {
  final List<SerializationModel> scannedItems;

  PackagingItemsAdded({required this.scannedItems});
}

class PackagingItemRemoved extends AggregationState {
  final List<SerializationModel> scannedItems;

  PackagingItemRemoved({required this.scannedItems});
}

class PackagingSaved extends AggregationState {
  final String message;

  PackagingSaved({required this.message});
}

class PalletizationLoading extends AggregationState {}

class PalletizationLoaded extends AggregationState {
  final List<PalletizationModel> pallets;

  PalletizationLoaded({required this.pallets});
}

class PalletizationError extends AggregationState {
  final String message;

  PalletizationError({required this.message});
}
