import 'package:gtrack_nartec/screens/home/identify/GIAI/model/brand_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/category_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/city_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/country_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/employee_name_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/generate_tag_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/state_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/tag_model.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/model/varified_asset_model.dart';

class FatsState {}

class FatsInitial extends FatsState {}

class FatsCountryLoading extends FatsState {}

class FatsCountryLoaded extends FatsState {
  final List<CountryModel> countries;
  FatsCountryLoaded({required this.countries});
}

class FatsCountryError extends FatsState {
  final String message;
  FatsCountryError({required this.message});
}

class FatsStateLoading extends FatsState {}

class FatsStateLoaded extends FatsState {
  final List<StateModel> states;
  FatsStateLoaded({required this.states});
}

class FatsStateError extends FatsState {
  final String message;
  FatsStateError({required this.message});
}

class FatsCityLoading extends FatsState {}

class FatsCityLoaded extends FatsState {
  final List<CityModel> cities;
  FatsCityLoaded({required this.cities});
}

class FatsCityError extends FatsState {
  final String message;
  FatsCityError({required this.message});
}

class FatsCategoryLoading extends FatsState {}

class FatsCategoryLoaded extends FatsState {
  final List<CategoryModel> categories;
  FatsCategoryLoaded({required this.categories});
}

class FatsCategoryError extends FatsState {
  final String message;
  FatsCategoryError({required this.message});
}

class FatsBrandLoading extends FatsState {}

class FatsBrandLoaded extends FatsState {
  final List<BrandModel> brands;
  FatsBrandLoaded({required this.brands});
}

class FatsBrandError extends FatsState {
  final String message;
  FatsBrandError({required this.message});
}

class FatsSendBarcodeLoading extends FatsState {}

class FatsSendBarcodeLoaded extends FatsState {
  final String message;
  FatsSendBarcodeLoaded({required this.message});
}

class FatsSendBarcodeError extends FatsState {
  final String message;
  FatsSendBarcodeError({required this.message});
}

class FatsGetTagsLoading extends FatsState {}

class FatsGetTagsLoaded extends FatsState {
  final List<GenerateTagsModel> tags;
  FatsGetTagsLoaded({required this.tags});
}

class FatsGetTagsError extends FatsState {
  final String message;
  FatsGetTagsError({required this.message});
}

class FatsGenerateTagsLoading extends FatsState {}

class FatsGenerateTagsLoaded extends FatsState {
  final String message;
  FatsGenerateTagsLoaded({required this.message});
}

class FatsGenerateTagsError extends FatsState {
  final String message;
  FatsGenerateTagsError({required this.message});
}

class FatsGetEmployeeNamesLoading extends FatsState {}

class FatsGetEmployeeNamesLoaded extends FatsState {
  final List<EmployeeNameModel> employeeNames;
  FatsGetEmployeeNamesLoaded({required this.employeeNames});
}

class FatsGetEmployeeNamesError extends FatsState {
  final String message;
  FatsGetEmployeeNamesError({required this.message});
}

class FatsGetTagDetailsLoading extends FatsState {}

class FatsGetTagDetailsLoaded extends FatsState {
  final TagModel tag;
  FatsGetTagDetailsLoaded({required this.tag});
}

class FatsGetTagDetailsError extends FatsState {
  final String message;
  FatsGetTagDetailsError({required this.message});
}

class FatsHandleSubmitLoading extends FatsState {}

class FatsHandleSubmitLoaded extends FatsState {
  final String message;
  FatsHandleSubmitLoaded({required this.message});
}

class FatsHandleSubmitError extends FatsState {
  final String message;
  FatsHandleSubmitError({required this.message});
}

class VerifiedAssetLoading extends FatsState {}

class VerifiedAssetLoaded extends FatsState {
  final List<VarifiedAssetModel> data;
  VerifiedAssetLoaded({required this.data});
}

class VerifiedAssetError extends FatsState {
  final String message;
  VerifiedAssetError({required this.message});
}
