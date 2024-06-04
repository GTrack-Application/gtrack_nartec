import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/get_bundle_by_userId/bundle_state.dart';
import 'package:nb_utils/nb_utils.dart';

class BundleCubit extends Cubit<BundleState> {
  BundleCubit() : super(BundleInitial());

  void getBundleByUserId() async {
    emit(BundleLoading());

    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(BundleError(message: "No Internet Connection"));
      }
      var products = await AssemblingController.getBundlingByUserId();
      emit(BundleLoaded(products: products));
    } catch (e) {
      emit(BundleError(message: e.toString()));
    }
  }
}
