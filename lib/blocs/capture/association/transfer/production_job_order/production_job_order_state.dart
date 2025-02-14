import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';

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
