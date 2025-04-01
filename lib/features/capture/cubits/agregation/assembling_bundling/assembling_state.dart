import 'package:gtrack_nartec/features/capture/models/aggregation/assembling_bundling/products_model.dart';

abstract class AssemblingState {}

class AssemblingInitial extends AssemblingState {}

class AssemblingLoading extends AssemblingState {}

class AssemblingLoaded extends AssemblingState {
  final List<ProductsModel> assemblings;

  AssemblingLoaded(this.assemblings);
}

class AssemblingError extends AssemblingState {
  final String message;

  AssemblingError(this.message);
}
