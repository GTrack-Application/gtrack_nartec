part of 'job_order_cubit.dart';

sealed class JobOrderState {}

class JobOrderInitial extends JobOrderState {}

class JobOrderLoading extends JobOrderState {}

class JobOrderLoaded extends JobOrderState {
  final List<JobOrderModel> orders;
  JobOrderLoaded({required this.orders});
}

class JobOrderError extends JobOrderState {
  final String message;
  JobOrderError({required this.message});
}

// * Job order details
class JobOrderDetailsLoading extends JobOrderState {}

class JobOrderDetailsLoaded extends JobOrderState {
  final List<JobOrderBillOfMaterial> bomDetails;
  JobOrderDetailsLoaded({required this.bomDetails});
}

class JobOrderDetailsError extends JobOrderState {
  final String message;
  JobOrderDetailsError({required this.message});
}

// * Add to production
class AddToProductionLoading extends JobOrderState {}

class AddToProductionLoaded extends JobOrderState {}

class AddToProductionError extends JobOrderState {
  final String message;
  AddToProductionError({required this.message});
}

// * Assets by tag number
class AssetsByTagNumberLoading extends JobOrderState {}

class AssetsByTagNumberLoaded extends JobOrderState {}

class AssetsByTagNumberError extends JobOrderState {
  final String message;
  AssetsByTagNumberError({required this.message});
}

// Save Asset tags
class SaveAssetTagsLoading extends JobOrderState {}

class SaveAssetTagsLoaded extends JobOrderState {}

class SaveAssetTagsError extends JobOrderState {
  final String message;
  SaveAssetTagsError({required this.message});
}

// * Packaging Scan by SSCC Number
class PackagingScanLoading extends JobOrderState {}

class PackagingScanLoaded extends JobOrderState {
  final dynamic response;
  PackagingScanLoaded({required this.response});
}

class PackagingScanError extends JobOrderState {
  final String message;
  PackagingScanError({required this.message});
}

// * Package Item Selection
class PackagingItemSelectionUpdated extends JobOrderState {
  final int totalSelectedItems;
  final Map<String, Set<String>> selectedNestedItems;
  final Set<String> selectedPackages;

  PackagingItemSelectionUpdated({
    required this.totalSelectedItems,
    required this.selectedNestedItems,
    required this.selectedPackages,
  });
}
