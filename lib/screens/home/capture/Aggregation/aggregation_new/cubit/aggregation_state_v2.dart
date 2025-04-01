import 'package:gtrack_nartec/features/capture/models/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/container_model.dart';
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

/*
##############################################################################
? Palletization Start
##############################################################################
*/

class PalletizationLoading extends AggregationState {}

class PalletizationLoaded extends AggregationState {
  final List<PalletizationModel> pallets;

  PalletizationLoaded({required this.pallets});
}

class PalletizationError extends AggregationState {
  final String message;

  PalletizationError({required this.message});
}

class SSCCPackagesLoading extends AggregationState {}

class SSCCPackagesLoaded extends AggregationState {
  final List<PackagingModel> packages;

  SSCCPackagesLoaded({required this.packages});
}

class SSCCPackagesError extends AggregationState {
  final String message;

  SSCCPackagesError({required this.message});
}

class PalletCreated extends AggregationState {
  final String message;

  PalletCreated({required this.message});
}

class SSCCPackageSelectionChanged extends AggregationState {
  final List<String> selectedSSCCNumbers;

  SSCCPackageSelectionChanged({required this.selectedSSCCNumbers});
}

/*
##############################################################################
? Palletization End
##############################################################################
*/

// State for pallet creation

// Containerization States
class ContainersLoading extends AggregationState {}

class ContainersLoaded extends AggregationState {
  final List<ContainerModel> containers;

  ContainersLoaded({required this.containers});
}

class ContainersError extends AggregationState {
  final String message;

  ContainersError({required this.message});
}

class ContainerSelected extends AggregationState {
  final ContainerModel container;

  ContainerSelected({required this.container});
}

class PalletsForContainerSelected extends AggregationState {
  final List<String> palletIds;

  PalletsForContainerSelected({required this.palletIds});
}

class ContainerCreationLoading extends AggregationState {}

class ContainerCreated extends AggregationState {}

class ContainerCreationError extends AggregationState {
  final String message;

  ContainerCreationError({required this.message});
}

class GtinPackagingLoading extends AggregationState {}

class GtinPackagingLoaded extends AggregationState {}

class GtinPackagingError extends AggregationState {
  final String message;

  GtinPackagingError({required this.message});
}
