import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/cubit/capture/agregation/assembling_bundling/get_bundle_by_userId/bundle_state.dart';

class BundleCubit extends Cubit<BundleState> {
  BundleCubit() : super(BundleInitial());

  void getBundleByUserId() async {
    emit(BundleLoading());

    try {
      final products = await AssemblingController.getBundlingByUserId();
      emit(BundleLoaded(products: products));
    } catch (e) {
      emit(BundleError(message: e.toString()));
    }
  }
}
