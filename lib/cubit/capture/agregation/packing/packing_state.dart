import 'package:gtrack_mobile_app/models/capture/aggregation/packing/GtinProductDetailsModel.dart';

abstract class PackingState {}

class PackingInitial extends PackingState {}

class PackingLoading extends PackingState {}

class PackingLoaded extends PackingState {
  final GtinProductDetailsModel data;

  PackingLoaded({required this.data});
}

class PackingError extends PackingState {
  final String message;

  PackingError({required this.message});
}
