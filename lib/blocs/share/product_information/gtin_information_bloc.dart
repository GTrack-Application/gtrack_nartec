import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/global/global_states_events.dart';
import 'package:gtrack_nartec/controllers/share/product_information/gtin_information_controller.dart';

class GtinInformationBloc extends Bloc<GlobalEvent, GlobalState> {
  GtinInformationBloc() : super(GlobalInitState()) {
    on<GlobalDataEvent>((event, emit) async {
      emit(GlobalLoadingState());
      try {
        final data = await GtinInformationController.getGtinInformation(
            event.data.toString());
        emit(GlobalLoadedState(data: data));
      } catch (error) {
        emit(GlobalErrorState(message: error.toString()));
      }
    });
  }
}
