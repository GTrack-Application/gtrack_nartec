import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';

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
