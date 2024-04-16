import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_mobile_app/controllers/Identify/gtin/gtin_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  void getGtinData() async {
    emit(GtinLoadingState());

    bool networkStatus = await isNetworkAvailable();
    if (networkStatus) {
      try {
        final data = await GTINController.getProducts();
        emit(GtinLoadedState(data: data));
      } catch (e) {
        emit(GtinErrorState(message: e.toString()));
      }
    } else {
      emit(GtinErrorState(message: 'No Internet Connection'));
    }
  }
}
