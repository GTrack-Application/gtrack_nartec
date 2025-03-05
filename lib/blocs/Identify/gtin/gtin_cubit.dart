import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/controllers/Identify/gtin/gtin_controller.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/ingredient_model.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/retailer_model.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  static GtinCubit get(context) => BlocProvider.of<GtinCubit>(context);
  final HttpService upcHubService = HttpService(baseUrl: AppUrls.upcHub);

  // * Lists
  final List<GTIN_Model> data = [];

  int _currentPage = 1;
  final int _pageSize = 8;
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

  void getProducts() async {
    if (state is GtinLoadingState) return;

    if (_currentPage == 1) {
      emit(GtinLoadingState());
      _allProducts.clear();
    }

    try {
      final response = await GTINController.getPaginatedProducts(
        page: _currentPage,
        pageSize: _pageSize,
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

  void loadMore() {
    if (state is GtinLoadedState) {
      final currentState = state as GtinLoadedState;
      if (currentState.hasMoreData) {
        emit(GtinLoadingMoreState(
          currentData: _allProducts,
          hasMoreData: true,
        ));
        _currentPage++;
        getProducts();
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
      _currentAllergenPage = 1;
      _currentRetailerPage = 1;
      _currentIngredientPage = 1;
    } else {
      emit(GtinLoadingMoreDigitalLinkDataState(
        currentAllergens: _allergens,
        currentRetailers: _retailers,
        currentIngredients: _ingredients,
      ));
    }

    try {
      final response = await GTINController.getDigitalLinkViewData(
        gtin,
        page: _currentAllergenPage,
        limit: _allergenPageSize,
      );

      final allergenResponse = response['allergens'] as AllergenResponse;
      final retailerResponse = response['retailers'] as RetailerResponse;
      final ingredientResponse = response['ingredients'] as IngredientResponse;

      if (loadMore) {
        _allergens.addAll(allergenResponse.allergens);
        _retailers.addAll(retailerResponse.retailers);
        _ingredients.addAll(ingredientResponse.ingredients);
      } else {
        _allergens = allergenResponse.allergens;
        _retailers = retailerResponse.retailers;
        _ingredients = ingredientResponse.ingredients;
      }

      _hasMoreAllergens =
          _currentAllergenPage < allergenResponse.pagination.totalPages;
      _hasMoreRetailers =
          _currentRetailerPage < retailerResponse.pagination.totalPages;
      _hasMoreIngredients =
          _currentIngredientPage < ingredientResponse.pagination.totalPages;

      emit(GtinDigitalLinkViewDataLoadedState(
        allergens: _allergens,
        retailers: _retailers,
        ingredients: _ingredients,
        hasMoreAllergens: _hasMoreAllergens,
        hasMoreRetailers: _hasMoreRetailers,
        hasMoreIngredients: _hasMoreIngredients,
      ));
    } catch (e) {
      emit(GtinDigitalLinkViewDataErrorState(message: e.toString()));
    }
  }

  void loadMoreData(String gtin) {
    if (_hasMoreAllergens || _hasMoreRetailers || _hasMoreIngredients) {
      _currentAllergenPage++;
      _currentRetailerPage++;
      _currentIngredientPage++;
      getDigitalLinkViewData(gtin, loadMore: true);
    }
  }
}
