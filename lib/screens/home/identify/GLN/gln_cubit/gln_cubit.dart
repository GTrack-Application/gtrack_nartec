import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/gln_controller/gln_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/GLN/gln_cubit/gln_state.dart';

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
    String locationNameAr,
  ) async {
    if (state is GLNLoading) return;
    emit(GLNLoading());
    try {
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
        locationNameAr,
      );
      emit(GLNLoaded());
    } catch (e) {
      emit(GLNError(message: e.toString()));
    }
  }
}
