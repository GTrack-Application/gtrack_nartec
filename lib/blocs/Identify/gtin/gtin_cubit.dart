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
  int _currentAllergenPage = 1;
  static const int _allergenPageSize = 20;

  List<RetailerModel> _retailers = [];
  bool _hasMoreRetailers = true;
  int _currentRetailerPage = 1;
  static const int _retailerPageSize = 10;

  List<IngredientModel> _ingredients = [];
  bool _hasMoreIngredients = true;
  int _currentIngredientPage = 1;
  static const int _ingredientPageSize = 10;

  List<PackagingModel> _packagings = [];
  bool _hasMorePackagings = true;
  int _currentPackagingPage = 1;
  static const int _packagingPageSize = 10;

  List<PromotionalOfferModel> _promotions = [];
  bool _hasMorePromotions = true;
  int _currentPromotionPage = 1;
  static const int _promotionPageSize = 10;

  List<RecipeModel> _recipes = [];
  bool _hasMoreRecipes = true;
  int _currentRecipePage = 1;
  static const int _recipePageSize = 10;

  List<LeafletModel> _leaflets = [];
  bool _hasMoreLeaflets = true;
  int _currentLeafletPage = 1;
  static const int _leafletPageSize = 10;

  List<ImageModel> _images = [];
  bool _hasMoreImages = true;
  int _currentImagePage = 1;
  static const int _imagePageSize = 10;

  List<InstructionModel> _instructions = [];
  bool _hasMoreInstructions = true;
  int _currentInstructionPage = 1;
  static const int _instructionPageSize = 10;

  List<VideoModel> _videos = [];
  bool _hasMoreVideos = true;
  int _currentVideoPage = 1;
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
        page: _currentVideoPage,
        limit: _videoPageSize,
      );

      // Fix: Handle allergens properly
      final allergens = response['allergens'] as List<AllergenModel>;
      final retailerResponse = response['retailers'] as RetailerResponse;
      final ingredientResponse = response['ingredients'] as IngredientResponse;
      final packagingResponse = response['packagings'] as PackagingResponse;
      final promotionalResponse =
          response['promotions'] as PromotionalOfferResponse;
      final recipeResponse = response['recipes'] as RecipeResponse;
      final leafletResponse = response['leaflets'] as LeafletResponse;
      final instructionResponse =
          response['instructions'] as InstructionResponse;

      // Fix: Assign allergens properly
      _allergens = allergens;
      _retailers = retailerResponse.retailers;
      _ingredients = ingredientResponse.ingredients;
      _packagings = packagingResponse.packagings;
      _promotions = promotionalResponse.offers;
      _recipes = recipeResponse.recipes;
      _leaflets = leafletResponse.leaflets;
      _instructions = instructionResponse.instructions;

      _hasMoreRetailers =
          _currentRetailerPage < retailerResponse.pagination.totalPages;
      _hasMoreIngredients =
          _currentIngredientPage < ingredientResponse.pagination.totalPages;
      _hasMorePackagings = _currentPackagingPage < packagingResponse.totalPages;
      _hasMorePromotions =
          _currentPromotionPage < promotionalResponse.totalPages;
      _hasMoreRecipes = _currentRecipePage < recipeResponse.totalPages;
      _hasMoreLeaflets = _currentLeafletPage < leafletResponse.totalPages;
      _hasMoreInstructions =
          _currentInstructionPage < instructionResponse.totalPages;

      final imageResponse = response['images'] as ImageResponse;
      _images = imageResponse.images;
      _hasMoreImages = _currentImagePage < imageResponse.totalPages;

      final videoResponse = response['videos'] as VideoResponse;
      _videos = videoResponse.videos;
      _hasMoreVideos = _currentVideoPage < videoResponse.totalPages;

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
    print('HI');
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

  // Use this method specifically for loading allergen information in the allergen tab
  Future<void> loadAllergenInformation(String barcode) async {
    emit(GetAllergenInformationLoading());
    try {
      _allergens = await GTINController.getAllergenInformation(barcode);
      emit(GetAllergenInformationLoaded(_allergens));
    } catch (e) {
      emit(GetAllergenInformationError(e.toString()));
    }
  }
}
