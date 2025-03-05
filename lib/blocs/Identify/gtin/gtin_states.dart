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

  final bool hasMoreAllergens;
  final bool hasMoreRetailers;
  final bool hasMoreIngredients;
  final bool hasMorePackagings;
  final bool hasMorePromotions;
  final bool hasMoreRecipes;
  final bool hasMoreLeaflets;
  final bool hasMoreImages;
  final bool hasMoreInstructions;

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
    required this.hasMoreAllergens,
    required this.hasMoreRetailers,
    required this.hasMoreIngredients,
    required this.hasMorePackagings,
    required this.hasMorePromotions,
    required this.hasMoreRecipes,
    required this.hasMoreLeaflets,
    required this.hasMoreImages,
    required this.hasMoreInstructions,
  });
}

class GtinDigitalLinkViewDataErrorState extends GtinState {
  final String message;

  GtinDigitalLinkViewDataErrorState({required this.message});
}

// * Loading More States
class GtinLoadingMoreDigitalLinkDataState extends GtinState {
  final List<AllergenModel> currentAllergens;
  final List<RetailerModel> currentRetailers;
  final List<IngredientModel> currentIngredients;
  final List<PackagingModel> currentPackagings;
  final List<PromotionalOfferModel> currentPromotions;

  GtinLoadingMoreDigitalLinkDataState({
    required this.currentAllergens,
    required this.currentRetailers,
    required this.currentIngredients,
    required this.currentPackagings,
    required this.currentPromotions,
  });
}
