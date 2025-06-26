// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/Identify/gtin/gtin_controller.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/image_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/ingredient_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/instruction_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/leaflet_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/nutrition_facts_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/packaging_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/promotional_offer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/recipe_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/retailer_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/review_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/video_model.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  static GtinCubit get(context) => BlocProvider.of<GtinCubit>(context);
  final HttpService upcHubService = HttpService(baseUrl: AppUrls.upcHub);

  // * Lists
  final List<GTIN_Model> data = [];
  List<ReviewModel> _reviews = [];
  List<NutritionFactsModel> _nutritionFacts = [];

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  final List<GTIN_Model> _allProducts = [];

  List<AllergenModel> _allergens = [];
  static const int _allergenPageSize = 20;

  List<RetailerModel> _retailers = [];

  List<IngredientModel> _ingredients = [];
  static const int _ingredientPageSize = 10;

  List<PackagingModel> _packagings = [];
  static const int _packagingPageSize = 10;

  List<PromotionalOfferModel> _promotions = [];
  static const int _promotionPageSize = 10;

  List<RecipeModel> _recipes = [];
  static const int _recipePageSize = 10;

  List<LeafletModel> _leaflets = [];
  static const int _leafletPageSize = 10;

  List<ImageModel> _images = [];
  static const int _imagePageSize = 10;

  List<InstructionModel> _instructions = [];
  static const int _instructionPageSize = 10;

  List<VideoModel> _videos = [];
  static const int _videoPageSize = 10;

  // * Getters
  int get page => _currentPage;
  int get pageSize => _pageSize;
  List<GTIN_Model> get products => _allProducts;
  List<AllergenModel> get allergens => _allergens;
  List<RetailerModel> get retailers => _retailers;
  List<IngredientModel> get ingredients => _ingredients;
  List<PackagingModel> get packagings => _packagings;
  List<PromotionalOfferModel> get promotions => _promotions;
  List<RecipeModel> get recipes => _recipes;
  List<LeafletModel> get leaflets => _leaflets;
  List<ImageModel> get images => _images;
  List<InstructionModel> get instructions => _instructions;
  List<VideoModel> get videos => _videos;
  List<ReviewModel> get reviews => _reviews;
  List<NutritionFactsModel> get nutritionFacts => _nutritionFacts;
  TextEditingController get searchController => _searchController;

  final TextEditingController _searchController = TextEditingController();

  void getProducts({String? searchQuery}) async {
    if (state is GtinLoadingState) return;

    if (_currentPage == 1) {
      emit(GtinLoadingState());
      _allProducts.clear();
    }

    try {
      final response = await GTINController.getPaginatedProducts(
        page: _currentPage,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      _allProducts.addAll(response.products);

      final totalPages = (response.totalProducts / _pageSize).ceil();
      _hasMoreData = _currentPage < totalPages;

      emit(GtinLoadedState(
        data: _allProducts,
        currentPage: _currentPage,
        totalPages: totalPages,
        hasMoreData: _hasMoreData,
      ));
    } catch (error) {
      emit(GtinErrorState(message: error.toString()));
    }
  }

  void loadMore({String? searchQuery}) {
    if (state is GtinLoadedState) {
      final currentState = state as GtinLoadedState;
      if (currentState.hasMoreData) {
        emit(GtinLoadingMoreState(
          currentData: _allProducts,
          hasMoreData: true,
        ));
        _currentPage++;
        getProducts(searchQuery: searchQuery);
      }
    }
  }

  void refresh() {
    _currentPage = 1;
    getProducts();
  }

  // void getGtinData() async {
  //   emit(GtinLoadingState());

  //   try {
  //     final data = await GTINController.getProducts();
  //     emit(GtinLoadedState(
  //       data: data,
  //       currentPage: 1,
  //       totalPages: 1,
  //       hasMoreData: false,
  //     ));
  //   } catch (e) {
  //     emit(GtinErrorState(message: e.toString()));
  //   }
  // }

  void deleteGtinProductById(String productId) async {
    emit(GtinDeleteProductLoadingState());

    try {
      await GTINController.deleteProductById(productId);
      emit(GtinDeleteProductLoadedState());
    } catch (e) {
      emit(GtinErrorState(message: e.toString()));
    }
  }

  Future<void> getDigitalLinkViewData(String gtin) async {
    try {
      final response = await GTINController.getDigitalLinkViewData(
        gtin,
        limit: _videoPageSize,
      );

      // Fix: Handle allergens properly
      final allergens = response['allergens'] as List<AllergenModel>;
      final retailerResponse = response['data'] as List<RetailerModel>;
      final ingredientResponse = response['ingredients'] as IngredientResponse;
      final packagingResponse = response['packagings'] as List<PackagingModel>;
      final promotionalResponse =
          response['promotionalOffers'] as List<PromotionalOfferModel>;
      final recipeResponse = response as List<RecipeModel>;
      final leafletResponse = response as List<LeafletModel>;
      final instructionResponse =
          response['instructions'] as InstructionResponse;

      // Fix: Assign allergens properly
      _allergens = allergens;
      _retailers = retailerResponse;
      _ingredients = ingredientResponse.ingredients;
      _packagings = packagingResponse;
      _promotions = promotionalResponse;
      _recipes = recipeResponse;
      _leaflets = leafletResponse;
      _instructions = instructionResponse.instructions;

      final imageResponse = response['data'] as List<ImageModel>;
      _images = imageResponse;

      final videoResponse = response['data'] as List<VideoModel>;
      _videos = videoResponse;

      emit(GtinDigitalLinkViewDataLoadedState(
        allergens: _allergens,
        retailers: _retailers,
        ingredients: _ingredients,
        packagings: _packagings,
        promotions: _promotions,
        recipes: _recipes,
        leaflets: _leaflets,
        images: _images,
        instructions: _instructions,
        videos: _videos,
      ));
    } catch (e) {
      emit(GtinDigitalLinkViewDataErrorState(message: e.toString()));
    }
  }

  // * Reviews
  Future<void> getReviews(String gtin) async {
    emit(GtinReviewsLoadingState());
    try {
      _reviews = await GTINController.getReviews(gtin);
      emit(GtinReviewsLoadedState());
    } catch (e) {
      emit(GtinReviewsErrorState(message: e.toString()));
    }
  }

  Future<void> getAllergenInformation(String barcode) async {
    _allergens.clear();
    emit(GetAllergenInformationLoading());
    try {
      _allergens = await GTINController.getAllergenInformation(barcode);
      emit(GetAllergenInformationLoaded(_allergens));
    } catch (e) {
      emit(GetAllergenInformationError(e.toString()));
    }
  }

  Future<void> getNutritionFacts(String barcode) async {
    _nutritionFacts.clear();
    emit(GtinNutritionFactsLoadingState());
    try {
      _nutritionFacts = await GTINController.fetchNutritionFacts(barcode);
      emit(GtinNutritionFactsLoadedState());
    } catch (e) {
      emit(GtinNutritionFactsErrorState(e.toString()));
    }
  }

  void submitReview({
    required String barcode,
    required int rating,
    required String comment,
    required String productDescription,
    required String brandName,
  }) async {
    emit(GtinReviewSubmittingState());
    try {
      final newReview = await GTINController.postReview(
        barcode: barcode,
        rating: rating,
        comment: comment,
        productDescription: productDescription,
        brandName: brandName,
      );

      // Add the new review to the existing reviews
      _reviews = [newReview, ..._reviews];

      emit(GtinReviewSubmittedState());
      // Notify that reviews are loaded with the updated list
      emit(GtinReviewsLoadedState());
    } catch (e) {
      emit(GtinReviewErrorState(message: e.toString()));
    }
  }

  Future<void> getRetailersInformation(String gtin) async {
    _retailers.clear();
    emit(GetRetailerInformationLoading());
    try {
      final newRetailers = await GTINController.getRetailerInformation(gtin);
      _retailers.addAll(newRetailers);
      emit(GetRetailerInformationLoaded(_retailers));
    } catch (e) {
      emit(GetRetailerInformationError(e.toString()));
    }
  }

  Future<void> getPackagingInformation(String gtin) async {
    _packagings.clear();
    emit(GetPackagingInformationLoading());
    try {
      _packagings = await GTINController.getPackagingInformation(gtin);
      emit(GetPackagingInformationLoaded(_packagings));
    } catch (e) {
      emit(GetPackagingInformationError(e.toString()));
    }
  }

  Future<void> getPromotionalOffers(String gtin) async {
    _promotions.clear();
    emit(GetPromotionalOffersLoading());
    try {
      _promotions = await GTINController.getPromotionalOffers(gtin);

      emit(GetPromotionalOffersLoaded(_promotions));
    } catch (e) {
      emit(GetPromotionalOffersError(e.toString()));
    }
  }

  Future<void> getRecipes(String gtin) async {
    _recipes.clear();
    emit(GetRecipeInformationLoading());
    try {
      _recipes = await GTINController.getRecipeInformation(gtin);
      emit(GetRecipeInformationLoaded(_recipes));
    } catch (e) {
      emit(GetRecipeInformationError(e.toString()));
    }
  }

  Future<void> getImages(String gtin) async {
    _images.clear();
    emit(GetImagesLoading());
    try {
      _images = await GTINController.getImageInformation(gtin);
      emit(GetImagesLoaded(_images));
    } catch (e) {
      emit(GetImagesError(e.toString()));
    }
  }

  Future<void> getLeafletInformation(String gtin) async {
    _leaflets.clear();
    emit(GetLeafletLoading());
    try {
      _leaflets = await GTINController.getLeafletInformation(gtin);
      emit(GetLeafletLoaded(_leaflets));
    } catch (e) {
      emit(GetLeafletError(e.toString()));
    }
  }

  Future<void> getVideoInformation(String gtin) async {
    _videos.clear();
    emit(GetVideoLoading());
    try {
      _videos = await GTINController.getVideoInformation(gtin);
      emit(GetVideoLoaded(_videos));
    } catch (e) {
      emit(GetVideoError(e.toString()));
    }
  }

  Future<void> getReviewsInformation(String gtin) async {
    _reviews.clear();
    emit(GtinReviewsLoadingState());
    try {
      _reviews = await GTINController.getReviews(gtin);
      emit(GtinReviewsLoadedState());
    } catch (e) {
      emit(GtinReviewsErrorState(message: e.toString()));
    }
  }

  void getGtinData() {}
}
