import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gln/gln_states.dart';
import 'package:gtrack_nartec/controllers/Identify/GLN/GLNController.dart';
import 'package:gtrack_nartec/models/identify/GLN/gln_model.dart';

class GlnCubit extends Cubit<GlnState> {
  GlnCubit() : super(GlnInitState());

  // Lists
  final List<GlnModel> _glnList = [];
  final List<GlnModel> selectedGlnList = [];

  // Getters
  List<GlnModel> get glnList => _glnList;

  void identifyGln() async {
    emit(GlnLoadingState());
    try {
      final response = await GLNController.getData();
      emit(GlnLoadedState(data: response));
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void getGlnData() async {
    emit(GlnLoadingState());
    try {
      final response = await GLNController.getGlnData();
      _glnList.clear();
      _glnList.addAll(response);
      emit(GlnV2LoadedState(data: response));
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }

  void selectGln(GlnModel gln) {
    if (selectedGlnList.contains(gln)) {
      selectedGlnList.remove(gln);
    } else {
      selectedGlnList.add(gln);
    }
    emit(GlnV2LoadedState(data: _glnList));
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

  void deleteGlnV2(String id) async {
    emit(GlnLoadingState());
    try {
      await GLNController.deleteGlnV2(id);
      emit(GlnDeleteState());
    } catch (e) {
      emit(GlnErrorState(message: e.toString()));
    }
  }
}
