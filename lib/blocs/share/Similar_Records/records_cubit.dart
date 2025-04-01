import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/share/Similar_Records/record_states.dart';
import 'package:gtrack_nartec/features/share/controllers/product_information/search_gpc_for_codification_controller.dart';

class RecordCubit extends Cubit<RecordsState> {
  RecordCubit() : super(RecordsInitial());

  void getRecords(String gcpName) async {
    emit(RecordsLoading());

    try {
      List<dynamic> data =
          await SearchGpcForCodificationController.findSimilarRecords(gcpName);
      emit(RecordsLoaded(data: data));
    } catch (error) {
      emit(RecordsError(error: error.toString()));
    }
  }
}
