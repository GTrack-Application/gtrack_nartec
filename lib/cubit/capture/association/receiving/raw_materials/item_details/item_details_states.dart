part of 'item_details_cubit.dart';

abstract class ItemDetailsState {}

class ItemDetailsInitial extends ItemDetailsState {}

// Loading

class ItemDetailsAssetDetailsLoading extends ItemDetailsState {}

// * Success

class ItemDetailsAssetDetailsSuccess extends ItemDetailsState {
  final AssetDetailsModel asset;
  ItemDetailsAssetDetailsSuccess(this.asset);
}

// ! Error

class ItemDetailsAssetDetailsError extends ItemDetailsState {
  final String message;

  ItemDetailsAssetDetailsError(this.message);
}
