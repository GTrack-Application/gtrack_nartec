import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/controllers/Identify/gtin/gtin_controller.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  static GtinCubit get(context) => BlocProvider.of<GtinCubit>(context);

  // * Lists
  final List<GTIN_Model> data = [];

  int _currentPage = 1;
  final int _pageSize = 8;
  bool _hasMoreData = true;
  final List<GTIN_Model> _allProducts = [];

  // * Getters
  int get page => _currentPage;
  int get pageSize => _pageSize;
  bool get hasMoreData => _hasMoreData;
  List<GTIN_Model> get products => _allProducts;

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

  void getGtinData() async {
    emit(GtinLoadingState());

    try {
      final data = await GTINController.getProducts();
      emit(GtinLoadedState(
        data: data,
        currentPage: 1,
        totalPages: 1,
        hasMoreData: false,
      ));
    } catch (e) {
      emit(GtinErrorState(message: e.toString()));
    }
  }

  void deleteGtinProductById(String productId) async {
    emit(GtinDeleteProductLoadingState());

    try {
      await GTINController.deleteProductById(productId);
      emit(GtinDeleteProductLoadedState());
    } catch (e) {
      emit(GtinErrorState(message: e.toString()));
    }
  }
}
