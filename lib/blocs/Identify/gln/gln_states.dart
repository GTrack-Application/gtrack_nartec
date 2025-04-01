import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/PackedItemsModel.dart';
import 'package:gtrack_nartec/features/identify/models/IDENTIFY/GLN/gln_model.dart'
    show GlnModel;

abstract class GlnState {}

class GlnInitState extends GlnState {}

class GlnLoadingState extends GlnState {}

class GlnLoadedState extends GlnState {
  List<PackedItemsModel> data = [];

  GlnLoadedState({required this.data});
}

class GlnV2LoadedState extends GlnState {
  final List<GlnModel> data;

  GlnV2LoadedState({required this.data});
}

class GlnMapMarkersState extends GlnState {
  final Set<Marker> markers;

  GlnMapMarkersState({required this.markers});
}

class GlnDeleteState extends GlnState {}

class GlnErrorState extends GlnState {
  final String message;

  GlnErrorState({required this.message});
}

class GlnAddedState extends GlnState {}
