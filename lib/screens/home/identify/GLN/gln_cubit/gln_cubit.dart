import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/screens/home/identify/GLN/gln_controller/gln_controller.dart';
import 'package:gtrack_mobile_app/screens/home/identify/GLN/gln_cubit/gln_state.dart';
import 'package:nb_utils/nb_utils.dart';

class GLNCubit extends Cubit<GLNState> {
  GLNCubit() : super(GLNInitial());

  void postGln(
    String locationNameEn,
    String addressEn,
    String addressAr,
    String pobox,
    String postalCode,
    String longitude,
    String latitude,
    String status,
    File? glnImage,
    String physicalLocation,
    String glnLocation,
  ) async {
    emit(GLNLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(GLNError(message: "No Internet Connection"));
      }
      await GlnController.postGln(
        locationNameEn,
        addressEn,
        addressAr,
        pobox,
        postalCode,
        longitude,
        latitude,
        status,
        glnImage,
        physicalLocation,
        glnLocation,
      );
      emit(GLNLoaded());
    } catch (e) {
      emit(GLNError(message: e.toString()));
    }
  }
}
