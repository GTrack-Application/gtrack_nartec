import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_mobile_app/cubit/capture/agregation/assembling_bundling/create_bundle/create_bundle_state.dart';
import 'package:nb_utils/nb_utils.dart';

class CreateBundleCubit extends Cubit<CreateBundleState> {
  CreateBundleCubit() : super(CreateBundleInitial());

  void createBundle(List<String> field) async {
    emit(CreateBundleLoading());

    try {
      var network = await isNetworkAvailable();
      if (!network) {
        emit(CreateBundleError(message: "No Internet Connection"));
      }
      await AssemblingController.createBundle(field);
      emit(CreateBundleLoaded());
    } catch (e) {
      emit(CreateBundleError(message: e.toString()));
    }
  }
}
