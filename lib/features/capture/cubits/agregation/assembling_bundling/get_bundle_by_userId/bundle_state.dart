import 'package:gtrack_nartec/features/capture/models/aggregation/assembling_bundling/products_model.dart';

abstract class BundleState {}

class BundleInitial extends BundleState {}

class BundleLoading extends BundleState {}

class BundleLoaded extends BundleState {
  List<ProductsModel> products;

  BundleLoaded({required this.products});
}

class BundleError extends BundleState {
  final String message;

  BundleError({required this.message});
}
