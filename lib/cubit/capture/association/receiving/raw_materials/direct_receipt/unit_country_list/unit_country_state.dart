import 'package:gtrack_mobile_app/models/capture/Association/Receiving/raw_materials/direct_receipt/CountryListModel.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Receiving/raw_materials/direct_receipt/UnitListModel.dart';

abstract class UnitCountryState {}

class UnitCountryInitial extends UnitCountryState {}

class UnitLoading extends UnitCountryState {}

class CountryLoading extends UnitCountryState {}

class UnitLoaded extends UnitCountryState {
  final List<UnitListModel> units;

  UnitLoaded(this.units);
}

class CountryLoaded extends UnitCountryState {
  final List<CountryListModel> countries;

  CountryLoaded(this.countries);
}

class UnitError extends UnitCountryState {
  final String message;

  UnitError(this.message);
}

class CountryError extends UnitCountryState {
  final String message;

  CountryError(this.message);
}
