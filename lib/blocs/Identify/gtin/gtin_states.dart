import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/image_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/ingredient_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/instruction_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/leaflet_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/packaging_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/promotional_offer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/recipe_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/retailer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/video_model.dart';

abstract class GtinState {}

class GtinInitState extends GtinState {}

// * Loading states
class GtinLoadingState extends GtinState {}

class GtinLoadingMoreState extends GtinState {
  final List<GTIN_Model> currentData;
  final bool hasMoreData;

  GtinLoadingMoreState({
    required this.currentData,
    required this.hasMoreData,
  });
}

class GtinDeleteProductLoadingState extends GtinState {}

// * Success states
class GtinLoadedState extends GtinState {
  final List<GTIN_Model> data;
  final int currentPage;
  final int totalPages;
  final bool hasMoreData;

  GtinLoadedState({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.hasMoreData,
  });
}

class GtinDeleteProductLoadedState extends GtinState {}

// ! Error states
class GtinErrorState extends GtinState {
  final String message;

  GtinErrorState({required this.message});
}

// * Digital Link View Data States
class GtinDigitalLinkViewDataLoadingState extends GtinState {}

class GtinDigitalLinkViewDataLoadedState extends GtinState {
  final List<AllergenModel> allergens;
  final List<RetailerModel> retailers;
  final List<IngredientModel> ingredients;
  final List<PackagingModel> packagings;
  final List<PromotionalOfferModel> promotions;
  final List<RecipeModel> recipes;
  final List<LeafletModel> leaflets;
  final List<ImageModel> images;
  final List<InstructionModel> instructions;
  final List<VideoModel> videos;

  GtinDigitalLinkViewDataLoadedState({
    required this.allergens,
    required this.retailers,
    required this.ingredients,
    required this.packagings,
    required this.promotions,
    required this.recipes,
    required this.leaflets,
    required this.images,
    required this.instructions,
    required this.videos,
  });
}

class GtinDigitalLinkViewDataErrorState extends GtinState {
  final String message;

  GtinDigitalLinkViewDataErrorState({required this.message});
}

// * Reviews
class GtinReviewsLoadingState extends GtinState {}

class GtinReviewsLoadedState extends GtinState {}

class GtinReviewsErrorState extends GtinState {
  final String message;

  GtinReviewsErrorState({required this.message});
}

class GtinReviewSubmittingState extends GtinState {}

class GtinReviewSubmittedState extends GtinState {}

class GtinReviewErrorState extends GtinState {
  final String message;

  GtinReviewErrorState({required this.message});
}

// * Nutrition Facts
class GtinNutritionFactsLoadingState extends GtinState {}

class GtinNutritionFactsLoadedState extends GtinState {}

class GtinNutritionFactsErrorState extends GtinState {
  final String message;

  GtinNutritionFactsErrorState(this.message);
}

class GetAllergenInformationLoading extends GtinState {}

class GetAllergenInformationLoaded extends GtinState {
  final List<AllergenModel> allergens;

  GetAllergenInformationLoaded(this.allergens);
}

class GetAllergenInformationError extends GtinState {
  final String message;

  GetAllergenInformationError(this.message);
}
