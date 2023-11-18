import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/global/global_states_events.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/gtin_information_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class GtinInformationBloc extends Bloc<GlobalEvent, GlobalState> {
  GtinInformationBloc() : super(GlobalInitState()) {
    on<GlobalDataEvent>((event, emit) async {
      emit(GlobalLoadingState());
      bool networkStatus = await isNetworkAvailable();
      if (networkStatus) {
        try {
          final data = await GtinInformationController.getGtinInformation(
              event.data.toString());
          emit(GlobalLoadedState(data: data));
        } catch (error) {
          emit(GlobalErrorState(message: error.toString()));
        }
      } else {}
    });
  }
}
