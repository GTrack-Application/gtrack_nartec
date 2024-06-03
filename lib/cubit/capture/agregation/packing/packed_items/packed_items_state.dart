import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/products_model.dart';

abstract class PackedItemsState {}

class PackedItemsInitial extends PackedItemsState {}

class PackedItemsLoading extends PackedItemsState {}

class PackedItemsLoaded extends PackedItemsState {
  final List<ProductsModel> data;

  PackedItemsLoaded({required this.data});
}

class PackedItemsError extends PackedItemsState {
  final String message;

  PackedItemsError({required this.message});
}
