import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/share/traceability/traceability_controller.dart';
import 'package:gtrack_mobile_app/models/share/traceability/TraceabilityModel.dart';
import 'package:nb_utils/nb_utils.dart';

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
      var network = await isNetworkAvailable();
      if (!network) {
        throw "No internet connection";
      }
      traceabilityData = await TraceabilityController.getReceivingTypes(
        gtinController.text.trim(),
      );

      print(traceabilityData.length);
      emit(ShareTraceabilitySuccess(traceabilityData));
    } catch (e) {
      emit(ShareTraceabilityError(e.toString()));
    }
  }
}
