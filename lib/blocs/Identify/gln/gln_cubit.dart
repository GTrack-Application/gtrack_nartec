import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_mobile_app/controllers/Identify/GLN/GLNController.dart';
import 'package:nb_utils/nb_utils.dart';

class GlnCubit extends Cubit<GlnState> {
  GlnCubit() : super(GlnInitState());

  void identifyGln() async {
    emit(GlnLoadingState());
    try {
      bool networkStatus = await isNetworkAvailable();
      if (!networkStatus) {
        emit(GlnErrorState(message: 'No Internet Connection'));
        return;
      } else {
        var response = await GLNController.getData();
        emit(GlnLoadedState(data: response));
      }
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void deleteGln(String id) async {
    emit(GlnLoadingState());
    try {
      bool networkStatus = await isNetworkAvailable();
      if (!networkStatus) {
        emit(GlnErrorState(message: 'No Internet Connection'));
        return;
      } else {
        await GLNController.deleteData(id);
        emit(GlnDeleteState());
      }
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }
}
