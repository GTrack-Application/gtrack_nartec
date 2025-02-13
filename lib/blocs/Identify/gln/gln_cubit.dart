import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/controllers/Identify/GLN/GLNController.dart';

class GlnCubit extends Cubit<GlnState> {
  GlnCubit() : super(GlnInitState());

  void identifyGln() async {
    emit(GlnLoadingState());
    try {
      final response = await GLNController.getData();
      emit(GlnLoadedState(data: response));
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void deleteGln(String id) async {
    emit(GlnLoadingState());
    try {
      await GLNController.deleteData(id);
      emit(GlnDeleteState());
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }
}
