import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/share/traceability/traceability_controller.dart';
import 'package:gtrack_nartec/models/share/traceability/TraceabilityModel.dart';

part 'share_states.dart';

class ShareCubit extends Cubit<ShareState> {
  ShareCubit() : super(ShareInitial());

  static ShareCubit get(context) => BlocProvider.of(context);

  // * Traceability
  var gtinController = TextEditingController();
  List<TraceabilityModel> traceabilityData = [];

  void getTraceabilityData() async {
    emit(ShareTraceabilityLoading());

    try {
      traceabilityData = await TraceabilityController.getReceivingTypes(
        gtinController.text.trim(),
      );

      emit(ShareTraceabilitySuccess(traceabilityData));
    } catch (e) {
      emit(ShareTraceabilityError(e.toString()));
    }
  }

  void clearTraceabilityData() {
    traceabilityData = [];
    emit(ShareInitial());
  }
}
