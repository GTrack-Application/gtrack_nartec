import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Association/Receiving/raw_materials/direct_receipt/direct_receipt_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/association/receiving/raw_materials/direct_receipt/unit_country_list/unit_country_state.dart';

class UnitCountryCubit extends Cubit<UnitCountryState> {
  UnitCountryCubit() : super(UnitCountryInitial());

  void getUnits() async {
    emit(UnitLoading());
    try {
      final units = await DirectReceiptController.getUnitList();
      emit(UnitLoaded(units));
    } catch (e) {
      emit(UnitError(e.toString()));
    }
  }

  void getCountries() async {
    emit(CountryLoading());
    try {
      final countries = await DirectReceiptController.getCountryList();
      emit(CountryLoaded(countries));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }
}
