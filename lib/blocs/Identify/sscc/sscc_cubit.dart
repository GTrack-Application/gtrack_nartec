import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/sscc/sscc_states.dart';
import 'package:gtrack_nartec/controllers/Identify/SSCC/SsccController.dart';

class SsccCubit extends Cubit<SsccState> {
  SsccCubit() : super(SsccInitState());

  void getSsccData() async {
    emit(SsccLoadingState());

    try {
      final data = await SsccController.getProducts();
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
