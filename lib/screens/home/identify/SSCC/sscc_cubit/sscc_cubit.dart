import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_controller/sscc_controller.dart';
import 'package:gtrack_nartec/screens/home/identify/SSCC/sscc_cubit/sscc_state.dart';

class SSCCCubit extends Cubit<SSCCState> {
  SSCCCubit() : super(SsccInitial());

  void postSsccBulk(String preDigit, int quantity) async {
    emit(SsccLoading());
    try {
      await SsccController.postSsccBulk(preDigit, quantity);
      emit(SsccLoaded());
    } catch (e) {
      emit(SsccError(error: e.toString()));
    }
  }
}
