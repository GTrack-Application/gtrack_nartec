import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/controllers/Identify/GLN/GLNController.dart';
import 'package:gtrack_nartec/models/identify/GLN/gln_model.dart';

class GlnCubit extends Cubit<GlnState> {
  GlnCubit() : super(GlnInitState());

  // Lists
  final List<GlnModel> _glnList = [];
  final List<GlnModel> selectedGlnList = [];
  Set<Marker> _markers = {};

  // Getters
  List<GlnModel> get glnList => _glnList;
  Set<Marker> get markers => _markers;

  void identifyGln() async {
    emit(GlnLoadingState());
    try {
      final response = await GLNController.getData();
      emit(GlnLoadedState(data: response));
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void getGlnData() async {
    emit(GlnLoadingState());
    try {
      final response = await GLNController.getGlnData();
      _glnList.clear();
      _glnList.addAll(response);
      emit(GlnV2LoadedState(data: response));
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void selectGln(GlnModel gln) {
    if (selectedGlnList.contains(gln)) {
      selectedGlnList.remove(gln);
    } else {
      selectedGlnList.add(gln);
    }
    emit(GlnV2LoadedState(data: _glnList));
    // Update markers when selection changes
    updateMapMarkers();
  }

  void updateMapMarkers() {
    final glnListToShow = selectedGlnList;
    Set<Marker> markers = {};

    for (var gln in glnListToShow) {
      try {
        final lat = double.parse(gln.latitude);
        final lng = double.parse(gln.longitude);

        markers.add(
          Marker(
            markerId: MarkerId(gln.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: gln.locationNameEn,
              snippet: gln.glnBarcodeNumber,
            ),
          ),
        );
      } catch (e) {
        // Skip invalid coordinates
        print(e);
      }
    }

    _markers = markers;
    emit(GlnMapMarkersState(markers: markers));
  }

  void deleteGln(String id) async {
    emit(GlnLoadingState());
    try {
      await GLNController.deleteData(id);
      emit(GlnDeleteState());
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void deleteGlnV2(String id) async {
    emit(GlnLoadingState());
    try {
      await GLNController.deleteGlnV2(id);
      emit(GlnDeleteState());
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }
}
