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

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreData = true;
  final List<GTIN_Model> _allProducts = [];

  List<AllergenModel> _allergens = [];
  bool _hasMoreAllergens = true;
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
  bool get hasMoreData => _hasMoreData;
  List<GTIN_Model> get products => _allProducts;
  List<AllergenModel> get allergens => _allergens;
  bool get hasMoreAllergens => _hasMoreAllergens;
  List<RetailerModel> get retailers => _retailers;
  bool get hasMoreRetailers => _hasMoreRetailers;
  List<IngredientModel> get ingredients => _ingredients;
  bool get hasMoreIngredients => _hasMoreIngredients;
  List<PackagingModel> get packagings => _packagings;
  bool get hasMorePackagings => _hasMorePackagings;
  List<PromotionalOfferModel> get promotions => _promotions;
  bool get hasMorePromotions => _hasMorePromotions;
  List<RecipeModel> get recipes => _recipes;
  bool get hasMoreRecipes => _hasMoreRecipes;
  List<LeafletModel> get leaflets => _leaflets;
  bool get hasMoreLeaflets => _hasMoreLeaflets;
  List<ImageModel> get images => _images;
  bool get hasMoreImages => _hasMoreImages;
  List<InstructionModel> get instructions => _instructions;
  bool get hasMoreInstructions => _hasMoreInstructions;
  List<VideoModel> get videos => _videos;
  bool get hasMoreVideos => _hasMoreVideos;
  List<ReviewModel> get reviews => _reviews;
  TextEditingController get searchController => _searchController;

  TextEditingController _searchController = TextEditingController();

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

  Future<void> getDigitalLinkViewData(String gtin,
      {bool loadMore = false}) async {
    if (!loadMore) {
      emit(GtinDigitalLinkViewDataLoadingState());
      _allergens.clear();
      _retailers.clear();
      _ingredients.clear();
      _packagings.clear();
      _promotions.clear();
      _recipes.clear();
      _leaflets.clear();
      _images.clear();
      _instructions.clear();
      _videos.clear();
      _currentAllergenPage = 1;
      _currentRetailerPage = 1;
      _currentIngredientPage = 1;
      _currentPackagingPage = 1;
      _currentPromotionPage = 1;
      _currentRecipePage = 1;
      _currentLeafletPage = 1;
      _currentImagePage = 1;
      _currentInstructionPage = 1;
      _currentVideoPage = 1;
    } else {
      emit(GtinLoadingMoreDigitalLinkDataState(
        currentAllergens: _allergens,
        currentRetailers: _retailers,
        currentIngredients: _ingredients,
        currentPackagings: _packagings,
        currentPromotions: _promotions,
        currentRecipes: _recipes,
        currentLeaflets: _leaflets,
        currentImages: _images,
        currentInstructions: _instructions,
        currentVideos: _videos,
      ));
    }

    try {
      final response = await GTINController.getDigitalLinkViewData(
        gtin,
        page: _currentVideoPage,
        limit: _videoPageSize,
      );

      final allergenResponse = response['allergens'] as AllergenResponse;
      final retailerResponse = response['retailers'] as RetailerResponse;
      final ingredientResponse = response['ingredients'] as IngredientResponse;
      final packagingResponse = response['packagings'] as PackagingResponse;
      final promotionalResponse =
          response['promotions'] as PromotionalOfferResponse;
      final recipeResponse = response['recipes'] as RecipeResponse;
      final leafletResponse = response['leaflets'] as LeafletResponse;
      final instructionResponse =
          response['instructions'] as InstructionResponse;

      if (loadMore) {
        _allergens.addAll(allergenResponse.allergens);
        _retailers.addAll(retailerResponse.retailers);
        _ingredients.addAll(ingredientResponse.ingredients);
        _packagings.addAll(packagingResponse.packagings);
        _promotions.addAll(promotionalResponse.offers);
        _recipes.addAll(recipeResponse.recipes);
        _leaflets.addAll(leafletResponse.leaflets);
        _instructions.addAll(instructionResponse.instructions);
      } else {
        _allergens = allergenResponse.allergens;
        _retailers = retailerResponse.retailers;
        _ingredients = ingredientResponse.ingredients;
        _packagings = packagingResponse.packagings;
        _promotions = promotionalResponse.offers;
        _recipes = recipeResponse.recipes;
        _leaflets = leafletResponse.leaflets;
        _instructions = instructionResponse.instructions;
      }

      _hasMoreAllergens =
          _currentAllergenPage < allergenResponse.pagination.totalPages;
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

      if (loadMore) {
        _images.addAll(imageResponse.images);
      } else {
        _images = imageResponse.images;
      }

      _hasMoreImages = _currentImagePage < imageResponse.totalPages;

      final videoResponse = response['videos'] as VideoResponse;

      if (loadMore) {
        _videos.addAll(videoResponse.videos);
      } else {
        _videos = videoResponse.videos;
      }

      _hasMoreVideos = _currentVideoPage < videoResponse.totalPages;

      emit(GtinDigitalLinkViewDataLoadedState(
        allergens: _allergens,
        retailers: _retailers,
        ingredients: _ingredients,
        packagings: _packagings,
        promotions: _promotions,
        recipes: _recipes,
        hasMoreAllergens: _hasMoreAllergens,
        hasMoreRetailers: _hasMoreRetailers,
        hasMoreIngredients: _hasMoreIngredients,
        hasMorePackagings: _hasMorePackagings,
        hasMorePromotions: _hasMorePromotions,
        hasMoreRecipes: _hasMoreRecipes,
        leaflets: _leaflets,
        hasMoreLeaflets: _hasMoreLeaflets,
        images: _images,
        hasMoreImages: _hasMoreImages,
        instructions: _instructions,
        hasMoreInstructions: _hasMoreInstructions,
        videos: _videos,
        hasMoreVideos: _hasMoreVideos,
      ));
    } catch (e) {
      emit(GtinDigitalLinkViewDataErrorState(message: e.toString()));
    }
  }

  void loadMoreData(String gtin) {
    if (_hasMoreAllergens ||
        _hasMoreRetailers ||
        _hasMoreIngredients ||
        _hasMorePackagings ||
        _hasMorePromotions ||
        _hasMoreRecipes ||
        _hasMoreLeaflets ||
        _hasMoreImages ||
        _hasMoreInstructions ||
        _hasMoreVideos) {
      _currentAllergenPage++;
      _currentRetailerPage++;
      _currentIngredientPage++;
      _currentPackagingPage++;
      _currentPromotionPage++;
      _currentRecipePage++;
      _currentLeafletPage++;
      _currentImagePage++;
      _currentInstructionPage++;
      _currentVideoPage++;
      getDigitalLinkViewData(gtin, loadMore: true);
    }
  }

  // * Reviews
  void getReviews(String gtin) async {
    try {
      final reviews = await GTINController.getReviews(gtin);
      _reviews = reviews;
      emit(GtinReviewsLoadedState());
    } catch (e) {
      emit(GtinReviewsErrorState(message: e.toString()));
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
}
