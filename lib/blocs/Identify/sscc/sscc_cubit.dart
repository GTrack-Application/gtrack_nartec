import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/sscc/sscc_states.dart';
import 'package:gtrack_nartec/controllers/Identify/SSCC/SsccController.dart';
import 'package:gtrack_nartec/models/IDENTIFY/SSCC/SsccModel.dart';

class SsccCubit extends Cubit<SsccState> {
  SsccCubit() : super(SsccInitState());

  static SsccCubit get(BuildContext context) => BlocProvider.of(context);

  // Lists
  List<SsccModel> ssccList = [];

  void getSsccData() async {
    emit(SsccLoadingState());

    try {
      final data = await SsccController.getProducts();
      ssccList = data;
      emit(SsccLoadedState(data: data));
    } catch (e) {
      emit(SsccErrorState(message: e.toString()));
    }
  }

  void deleteSscc(String sscc) async {
    emit(SsccLoadingState());
    try {
      await SsccController.deleteSscc(sscc);
      emit(SsccDeletedState());
    } catch (e) {
      emit(SsccErrorState(message: e.toString()));
    }
  }
}
