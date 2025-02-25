import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';

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
