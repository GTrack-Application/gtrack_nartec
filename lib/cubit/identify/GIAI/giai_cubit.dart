import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/Identify/GIAI/giai_controller.dart';
import 'package:gtrack_nartec/cubit/identify/GIAI/giai_state.dart';

class GIAICubit extends Cubit<GIAIState> {
  GIAICubit() : super(GIAIInitial());

  void getGIAI() async {
    emit(GIAIGetGIAILoading());
    try {
      final giai = await GIAIController.getGIAI();
      emit(GIAIGetGIAISuccess(giai: giai));
    } catch (e) {
      emit(GIAIGetGIAIError(message: e.toString()));
    }
  }

  void deleteGIAI(String id) async {
    emit(GIAIDeleteGIAILoading());
    try {
      await GIAIController.deleteGIAI(id);
      emit(GIAIDeleteGIAISuccess());
    } catch (e) {
      emit(GIAIDeleteGIAIError(message: e.toString()));
    }
  }
}
