import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_state.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateBundleCubit extends Cubit<CreateBundleState> {
  CreateBundleCubit() : super(CreateBundleInitial());

  void createBundle(
      List<String> field, String glnLocation, String bundleName) async {
    emit(CreateBundleLoading());

    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(CreateBundleError(message: "No Internet Connection"));
      }
      await AssemblingController.createBundle(field, glnLocation, bundleName);
      emit(CreateBundleLoaded());
    } catch (e) {
      emit(CreateBundleError(message: e.toString()));
    }
  }

  void createAssemble(
      List<String> field, String glnLocation, String bundleName) async {
    emit(CreateBundleLoading());

    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(CreateBundleError(message: "No Internet Connection"));
      }
      await AssemblingController.createAssemble(field, glnLocation, bundleName);
      emit(CreateBundleLoaded());
    } catch (e) {
      emit(CreateBundleError(message: e.toString()));
    }
  }
}
