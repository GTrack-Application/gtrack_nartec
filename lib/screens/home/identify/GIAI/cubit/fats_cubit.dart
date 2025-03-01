// ignore_for_file: unused_local_variable

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/controller/fats_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/send_barcode_screen.dart';

class FatsCubit extends Cubit<FatsState> {
  FatsCubit() : super(FatsInitial());

  Future<void> getCountries() async {
    emit(FatsCountryLoading());
    try {
      final countries = await FatsController.getContries();
      emit(FatsCountryLoaded(countries: countries));
    } catch (e) {
      emit(FatsCountryError(message: e.toString()));
    }
  }

  Future<void> getStates(String countryId) async {
    emit(FatsStateLoading());
    try {
      final states = await FatsController.getStates(countryId);
      emit(FatsStateLoaded(states: states));
    } catch (e) {
      emit(FatsStateError(message: e.toString()));
    }
  }

  Future<void> getCities(String stateId) async {
    emit(FatsCityLoading());
    try {
      final cities = await FatsController.getCities(stateId);
      emit(FatsCityLoaded(cities: cities));
    } catch (e) {
      emit(FatsCityError(message: e.toString()));
    }
  }

  Future<void> getCategories() async {
    emit(FatsCategoryLoading());
    try {
      final categories = await FatsController.getCategories();
      emit(FatsCategoryLoaded(categories: categories));
    } catch (e) {
      emit(FatsCategoryError(message: e.toString()));
    }
  }

  Future<void> getBrands(String categoryId) async {
    emit(FatsBrandLoading());
    try {
      final brands = await FatsController.getBrands(categoryId);
      emit(FatsBrandLoaded(brands: brands));
    } catch (e) {
      emit(FatsBrandError(message: e.toString()));
    }
  }

  Future<void> sendBarcode(List<AssetItem> assetItems) async {
    emit(FatsSendBarcodeLoading());
    try {
      final response = await FatsController.sendBarcode(assetItems);
      emit(FatsSendBarcodeLoaded(message: "Assets inserted successfully."));
    } catch (e) {
      emit(FatsSendBarcodeError(message: e.toString()));
    }
  }

  Future<void> getTags() async {
    emit(FatsGetTagsLoading());
    try {
      final tags = await FatsController.getTags();
      emit(FatsGetTagsLoaded(tags: tags));
    } catch (e) {
      emit(FatsGetTagsError(message: e.toString()));
    }
  }

  Future<void> generateTags() async {
    emit(FatsGenerateTagsLoading());
    try {
      final response = await FatsController.generateTags();
      emit(FatsGenerateTagsLoaded(message: "Tags updated successfully"));
    } catch (e) {
      emit(FatsGenerateTagsError(message: e.toString()));
    }
  }

  Future<void> getEmployeeNames() async {
    emit(FatsGetEmployeeNamesLoading());
    try {
      final employeeNames = await FatsController.getEmployeeNames();
      emit(FatsGetEmployeeNamesLoaded(employeeNames: employeeNames));
    } catch (e) {
      emit(FatsGetEmployeeNamesError(message: e.toString()));
    }
  }
}
