import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/bom_start_model.dart';
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
