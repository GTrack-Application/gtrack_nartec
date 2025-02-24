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
