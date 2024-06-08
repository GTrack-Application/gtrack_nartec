import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/assembling_state.dart';
import 'package:nb_utils/nb_utils.dart';

class AssemblingCubit extends Cubit<AssemblingState> {
  AssemblingCubit() : super(AssemblingInitial());

  getAssemblyProductsByGtin(String gtin) async {
    emit(AssemblingLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(AssemblingError("No Internet Connection"));
      }
      final data =
          await AssemblingController.getAssemblingsByUserAndBarcode(gtin);
      emit(AssemblingLoaded(data));
    } catch (e) {
      emit(AssemblingError(e.toString()));
    }
  }

  getBundlingProductsByGtin(String gtin) async {
    emit(AssemblingLoading());
    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(AssemblingError("No Internet Connection"));
      }
      final data =
          await AssemblingController.getAssemblingsByUserAndBarcode(gtin);
      emit(AssemblingLoaded(data));
    } catch (e) {
      emit(AssemblingError(e.toString()));
    }
  }
}
