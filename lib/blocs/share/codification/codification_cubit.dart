import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/share/codification/codification_states.dart';
import 'package:gtrack_nartec/features/share/controllers/product_information/search_gpc_for_codification_controller.dart';

class CodificationCubit extends Cubit<CodificationState> {
  CodificationCubit() : super(CodificationInitial());

  void getGpcInformation(String gpc) async {
    emit(CodificationLoading());
    try {
      final data =
          await SearchGpcForCodificationController.searchGpcForCodification(
              gpc);
      emit(CodificationLoaded(data: data));
    } catch (error) {
      emit(CodificationError(error: error.toString()));
    }
  }
}
