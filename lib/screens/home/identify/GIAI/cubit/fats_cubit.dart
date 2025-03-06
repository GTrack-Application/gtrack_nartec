// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/controller/fats_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/cubit/fats_state.dart';
import 'package:gtrack_nartec/screens/home/identify/GIAI/send_barcode_screen.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getTagDetails(String tagNumber) async {
    emit(FatsGetTagDetailsLoading());
    try {
      final tagDetails = await FatsController.getTagDetails(tagNumber);
      emit(FatsGetTagDetailsLoaded(tag: tagDetails));
    } catch (e) {
      emit(FatsGetTagDetailsError(message: e.toString()));
    }
  }

  Future<void> handleSubmit(
    String id,
    String subUserId,
    String tagNumber,
    String locationTag,
    String serialNo,
    String employeeId,
    String phoneExtension,
    String otherTag,
    String notes,
    String assetCondition,
    String bought,
    String assetLocationDetails,
    List<File> selectedFiles,
    String fullLocationDetails,
  ) async {
    final token = await AppPreferences.getToken();
    emit(FatsHandleSubmitLoading());
    final deleteUrl = '${AppUrls.baseUrlWith7010}/api/assetMasterEncoder/$id';
    print(deleteUrl);
    final deleteHeaders = {'Authorization': 'Bearer $token'};
    print(deleteHeaders);
    try {
      final response = await FatsController.handleSubmit(
        id,
        subUserId,
        tagNumber,
        locationTag,
        serialNo,
        employeeId,
        phoneExtension,
        otherTag,
        notes,
        assetCondition,
        bought,
        assetLocationDetails,
        fullLocationDetails,
        selectedFiles,
      );

      emit(FatsHandleSubmitLoaded(message: "Assets inserted successfully."));

      final deleteResponse =
          await http.delete(Uri.parse(deleteUrl), headers: deleteHeaders);

      print(deleteResponse.body);
      print(deleteResponse.statusCode);

      if (deleteResponse.statusCode == 200 ||
          deleteResponse.statusCode == 201) {
        print(deleteResponse.body);
      } else {
        print(deleteResponse.body);
      }
    } catch (e) {
      emit(FatsHandleSubmitError(message: e.toString()));
    }
  }
}
