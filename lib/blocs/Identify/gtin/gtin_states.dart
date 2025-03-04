import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/allergen_model.dart';

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
  final bool hasMore;

  GtinDigitalLinkViewDataLoadedState({
    required this.allergens,
    required this.hasMore,
  });
}

class GtinDigitalLinkViewDataErrorState extends GtinState {
  final String message;

  GtinDigitalLinkViewDataErrorState({required this.message});
}

// Add new state for loading more allergens
class GtinLoadingMoreAllergensState extends GtinState {
  final List<AllergenModel> currentData;

  GtinLoadingMoreAllergensState({required this.currentData});
}
