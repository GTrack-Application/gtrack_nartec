import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/BundleItemsModel.dart';

abstract class BundleItemsState {}

class BundleItemsInitial extends BundleItemsState {}

class BundleItemsLoading extends BundleItemsState {}

class BundleItemsLoaded extends BundleItemsState {
  final List<BundleItemsModel> items;
  BundleItemsLoaded({required this.items});
}

class BundleItemsError extends BundleItemsState {
  final String message;
  BundleItemsError({required this.message});
}
