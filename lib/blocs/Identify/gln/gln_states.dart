import 'package:google_maps_flutter/google_maps_flutter.dart';
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
