import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/models/capture/Association/item_details/asset_details_model.dart';

part 'item_details_states.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  ItemDetailsCubit() : super(ItemDetailsInitial());

  static ItemDetailsCubit get(context) => BlocProvider.of(context);

  // * Asset Details
  final TextEditingController assetIdController = TextEditingController();
  final TextEditingController tagNoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void clearTextFields() {
    assetIdController.clear();
    tagNoController.clear();
    descriptionController.clear();
    classController.clear();
    locationController.clear();
  }

  bool isEmptyTextField() {
    if (assetIdController.text.isEmpty ||
        tagNoController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        classController.text.isEmpty ||
        locationController.text.isEmpty) {
      emit(ItemDetailsAssetDetailsError("Please fill all the fields"));
      return true;
    }
    return false;
  }

  List<AssetDetailsModel> assets = [];

  void addAssetDetails() {
    emit(ItemDetailsAssetDetailsLoading());
    try {
      // * Success
      emit(ItemDetailsAssetDetailsSuccess(AssetDetailsModel(
        assetId: assetIdController.text.trim(),
        tagNo: tagNoController.text.trim(),
        description: descriptionController.text.trim(),
        assetClass: classController.text.trim(),
        location: locationController.text.trim(),
      )));
    } catch (e) {
      // ! Error
      emit(ItemDetailsAssetDetailsError(e.toString()));
    }
  }

  void deleteAsset(index) {
    emit(ItemDetailsAssetDetailsLoading());
    try {
      // * Success
      assets.removeAt(index);
    } catch (e) {
      // ! Error
      emit(ItemDetailsAssetDetailsError(e.toString()));
    }
  }
}
