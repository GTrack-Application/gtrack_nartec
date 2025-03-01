import 'package:gtrack_nartec/models/capture/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/models/identify/GLN/gln_model.dart';

abstract class GlnState {}

class GlnInitState extends GlnState {}

class GlnLoadingState extends GlnState {}

class GlnLoadedState extends GlnState {
  List<PackedItemsModel> data = [];

  GlnLoadedState({required this.data});
}

class GlnV2LoadedState extends GlnState {
  List<GlnModel> data = [];

  GlnV2LoadedState({required this.data});
}

class GlnDeleteState extends GlnState {}

class GlnErrorState extends GlnState {
  final String message;

  GlnErrorState({required this.message});
}
