import 'package:gtrack_nartec/models/IDENTIFY/GTIN/brands_name_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/origin_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/package_type_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/product_description_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/product_type_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/unit_model.dart';

abstract class AddGtinState {}

class AddGtinInitial extends AddGtinState {}

class AddGtinLoading extends AddGtinState {}

class AddGtinBrandLoaded extends AddGtinState {
  final List<BrandsNameModel> brands;

  AddGtinBrandLoaded({required this.brands});
}

class AddGtinUnitLoaded extends AddGtinState {
  final List<UnitModel> units;

  AddGtinUnitLoaded({required this.units});
}

class AddGtinOriginLoaded extends AddGtinState {
  final List<OriginModel> origins;

  AddGtinOriginLoaded({required this.origins});
}

class AddGtinProductDesLoaded extends AddGtinState {
  final List<ProductDescriptionModel> productDesc;

  AddGtinProductDesLoaded({required this.productDesc});
}

class AddGtinProductTypeLoaded extends AddGtinState {
  final List<ProductTypeModel> productType;

  AddGtinProductTypeLoaded({required this.productType});
}

class AddGtinPackageTypeLoaded extends AddGtinState {
  final List<PackageTypeModel> packageType;

  AddGtinPackageTypeLoaded({required this.packageType});
}

class AddGtinError extends AddGtinState {
  final String message;

  AddGtinError({required this.message});
}

class InsertGtinLoading extends AddGtinState {}

class InsertGtinLoaded extends AddGtinState {}

class InsertGtinError extends AddGtinState {
  final String message;

  InsertGtinError({required this.message});
}
