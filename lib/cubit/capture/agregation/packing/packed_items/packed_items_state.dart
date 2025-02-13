import 'package:gtrack_nartec/models/capture/aggregation/packing/PackedItemsModel.dart';

abstract class PackedItemsState {}

class PackedItemsInitial extends PackedItemsState {}

class PackedItemsLoading extends PackedItemsState {}

class PackedItemsLoaded extends PackedItemsState {
  final List<PackedItemsModel> data;

  PackedItemsLoaded({required this.data});
}

class PackedItemsError extends PackedItemsState {
  final String message;

  PackedItemsError({required this.message});
}
