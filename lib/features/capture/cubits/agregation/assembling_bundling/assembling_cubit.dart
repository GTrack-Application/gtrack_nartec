import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/controllers/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/features/capture/cubits/agregation/assembling_bundling/assembling_state.dart';

class AssemblingCubit extends Cubit<AssemblingState> {
  AssemblingCubit() : super(AssemblingInitial());

  getAssemblyProductsByGtin(String gtin) async {
    emit(AssemblingLoading());
    try {
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
      final data =
          await AssemblingController.getAssemblingsByUserAndBarcode(gtin);
      emit(AssemblingLoaded(data));
    } catch (e) {
      emit(AssemblingError(e.toString()));
    }
  }
}
