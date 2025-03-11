import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bin_locations_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bom_start_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/mapped_barcodes_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order_bom.dart';

abstract class ProductionJobOrderState {}

class ProductionJobOrderInitial extends ProductionJobOrderState {}

class ProductionJobOrderLoading extends ProductionJobOrderState {}

class ProductionJobOrderLoaded extends ProductionJobOrderState {
  final List<ProductionJobOrder> orders;
  ProductionJobOrderLoaded({required this.orders});
}

class ProductionJobOrderError extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderError({required this.message});
}

class ProductionJobOrderBomLoading extends ProductionJobOrderState {}

class ProductionJobOrderBomLoaded extends ProductionJobOrderState {
  final List<ProductionJobOrderBom> bomItems;
  ProductionJobOrderBomLoaded({required this.bomItems});
}

class ProductionJobOrderBomError extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderBomError({required this.message});
}

class ProductionJobOrderBomStartLoading extends ProductionJobOrderState {}

class ProductionJobOrderBomStartLoaded extends ProductionJobOrderState {
  final BomStartModel bomStartData;
  ProductionJobOrderBomStartLoaded({required this.bomStartData});
}

class ProductionJobOrderBomStartError extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderBomStartError({required this.message});
}

class ProductionJobOrderBinLocationsLoading extends ProductionJobOrderState {}

class ProductionJobOrderBinLocationsLoaded extends ProductionJobOrderState {
  final List<BinLocation> binLocations;
  ProductionJobOrderBinLocationsLoaded({required this.binLocations});
}

class ProductionJobOrderBinLocationsError extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderBinLocationsError({required this.message});
}

class ProductionJobOrderMappedBarcodesLoading extends ProductionJobOrderState {}

class ProductionJobOrderMappedBarcodesLoaded extends ProductionJobOrderState {
  final MappedBarcodesResponse mappedBarcodes;

  ProductionJobOrderMappedBarcodesLoaded({required this.mappedBarcodes});
}

class ProductionJobOrderMappedBarcodesError extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderMappedBarcodesError({required this.message});
}

class ProductionJobOrderUpdateMappedBarcodesLoading
    extends ProductionJobOrderState {}

class ProductionJobOrderUpdateMappedBarcodesLoaded
    extends ProductionJobOrderState {
  final String message;
  final int updatedCount;

  ProductionJobOrderUpdateMappedBarcodesLoaded({
    required this.message,
    required this.updatedCount,
  });
}

class ProductionJobOrderUpdateMappedBarcodesError
    extends ProductionJobOrderState {
  final String message;
  ProductionJobOrderUpdateMappedBarcodesError({required this.message});
}
