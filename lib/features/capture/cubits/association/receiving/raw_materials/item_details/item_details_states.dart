part of 'item_details_cubit.dart';

abstract class ItemDetailsState {}

class ItemDetailsInitial extends ItemDetailsState {}

// Loading

class ItemDetailsLoading extends ItemDetailsState {}

class ItemDetailsAssetDetailsLoading extends ItemDetailsState {}

// * Success

class ItemDetailsSuccess extends ItemDetailsState {}

class ItemDetailsAssetDetailsSuccess extends ItemDetailsState {
  final AssetDetailsModel asset;
  ItemDetailsAssetDetailsSuccess(this.asset);
}

// ! Error
class ItemDetailsError extends ItemDetailsState {
  final String message;

  ItemDetailsError(this.message);
}

class ItemDetailsAssetDetailsError extends ItemDetailsState {
  final String message;

  ItemDetailsAssetDetailsError(this.message);
}
