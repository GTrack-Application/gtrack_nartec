import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling/assembling_state.dart';
import 'package:nb_utils/nb_utils.dart';

class AssembleCubit extends Cubit<AssemblingState> {
  AssembleCubit() : super(AssemblingInitial());

  getProductsByGtin(String gtin) async {
    emit(AssemblingLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(AssemblingError("No Internet Connection"));
      }
      final data = await AssemblingController.getProductsByGtin(gtin);
      emit(AssemblingLoaded(data));
    } catch (e) {
      emit(AssemblingError(e.toString()));
    }
  }
}
