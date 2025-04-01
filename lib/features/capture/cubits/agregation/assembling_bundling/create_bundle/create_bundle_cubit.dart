import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/controllers/Aggregation/Assembling_Bundling/assembling_controller.dart';
import 'package:gtrack_nartec/features/capture/cubits/agregation/assembling_bundling/create_bundle/create_bundle_state.dart';

class CreateBundleCubit extends Cubit<CreateBundleState> {
  CreateBundleCubit() : super(CreateBundleInitial());

  void createBundle(
      List<String> field, String glnLocation, String bundleName) async {
    emit(CreateBundleLoading());

    try {
      await AssemblingController.createBundle(field, glnLocation, bundleName);
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
      await AssemblingController.createAssemble(field, glnLocation, bundleName);
      emit(CreateBundleLoaded());
    } catch (e) {
      emit(CreateBundleError(message: e.toString()));
    }
  }
}
