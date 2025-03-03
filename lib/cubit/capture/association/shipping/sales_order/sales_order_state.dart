import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';

class SalesOrderState {}

class SalesOrderInitial extends SalesOrderState {}

class SalesOrderLoading extends SalesOrderState {}

class SalesOrderLoaded extends SalesOrderState {
  final List<SalesOrderModel> salesOrder;
  SalesOrderLoaded(this.salesOrder);
}

class SalesOrderError extends SalesOrderState {
  final String message;
  SalesOrderError(this.message);
}
