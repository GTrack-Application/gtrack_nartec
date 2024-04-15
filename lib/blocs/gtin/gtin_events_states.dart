import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';

abstract class GtinEvent {}

class GtinDataEvent extends GtinEvent {}

abstract class GtinState {}

class GtinInitState extends GtinState {}

class GtinLoadingState extends GtinState {}

class GtinLoadedState extends GtinState {
  List<GTIN_Model> data = [];

  GtinLoadedState({required this.data});
}

class GtinErrorState extends GtinState {
  final String message;

  GtinErrorState({required this.message});
}
