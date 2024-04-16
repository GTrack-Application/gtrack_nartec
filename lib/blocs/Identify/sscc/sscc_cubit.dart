import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/sscc/sscc_states.dart';
import 'package:gtrack_mobile_app/controllers/Identify/SSCC/SsccController.dart';
import 'package:nb_utils/nb_utils.dart';

class SsccCubit extends Cubit<SsccState> {
  SsccCubit() : super(SsccInitState());

  void getSsccData() async {
    emit(SsccLoadingState());

    bool networkStatus = await isNetworkAvailable();
    if (networkStatus) {
      try {
        final data = await SsccController.getProducts();
        emit(SsccLoadedState(data: data));
      } catch (e) {
        emit(SsccErrorState(message: e.toString()));
      }
    } else {
      emit(SsccErrorState(message: 'No Internet Connection'));
    }
  }
}
