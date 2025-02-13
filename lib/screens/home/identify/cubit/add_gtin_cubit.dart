// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/screens/home/identify/controller/add_gtin_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/cubit/add_gtin_state.dart';

class AddGtinCubit extends Cubit<AddGtinState> {
  AddGtinCubit() : super(AddGtinInitial());

  fetAddGtinData() async {
    emit(AddGtinLoading());
    try {
      final fetchBrands = await AddGtinController.fetchBrandsName();
      final unitData = await AddGtinController.fetchUnit();
      final originData = await AddGtinController.fetchOrigin();
      final productDesc = await AddGtinController.fetchProductDescLanguage();
      final productType = await AddGtinController.fetchProductType();
      final packageType = await AddGtinController.fetchPackageType();

      emit(AddGtinBrandLoaded(brands: fetchBrands));
      emit(AddGtinUnitLoaded(units: unitData));
      emit(AddGtinOriginLoaded(origins: originData));
      emit(AddGtinProductDesLoaded(productDesc: productDesc));
      emit(AddGtinProductTypeLoaded(productType: productType));
      emit(AddGtinPackageTypeLoaded(packageType: packageType));
    } catch (e) {
      emit(AddGtinError(message: e.toString()));
    }
  }

  insertGtinProduct(
    String productnameenglish,
    String productnamearabic,
    String BrandName,
    String ProductType,
    String Origin,
    String PackagingType,
    String unit,
    String size,
    String gpc,
    String gpc_type,
    String gpc_code,
    String countrySale,
    String HsDescription,
    String HSCODES,
    String details_page,
    String details_page_ar,
    String product_url,
    String BrandNameAr,
    String product_type,
    File front_image,
    File back_image,
    List<File?> optionalImages,
  ) async {
    emit(InsertGtinLoading());
    try {
      await AddGtinController.postProduct(
        productnameenglish,
        productnamearabic,
        BrandName,
        ProductType,
        Origin,
        PackagingType,
        unit,
        size,
        gpc,
        gpc_type,
        gpc_code,
        countrySale,
        HsDescription,
        HSCODES,
        details_page,
        details_page_ar,
        product_url,
        BrandNameAr,
        product_type,
        front_image,
        back_image,
        optionalImages,
      );
      emit(InsertGtinLoaded());
    } catch (e) {
      emit(InsertGtinError(message: e.toString()));
    }
  }
}
