import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/share/Similar_Records/record_states.dart';
import 'package:gtrack_mobile_app/controllers/share/product_information/search_gpc_for_codification_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class RecordCubit extends Cubit<RecordsState> {
  RecordCubit() : super(RecordsInitial());

  void getRecords(String gcpName) async {
    emit(RecordsLoading());

    bool networkStatus = await isNetworkAvailable();
    if (networkStatus) {
      try {
        List<dynamic> data =
            await SearchGpcForCodificationController.findSimilarRecords(
                gcpName);
        emit(RecordsLoaded(data: data));
      } catch (error) {
        emit(RecordsError(error: error.toString()));
      }
    } else {
      emit(RecordsError(error: 'No internet connection'));
    }
  }
}
