import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_nartec/controllers/Identify/gtin/gtin_controller.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/GTINModel.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  static GtinCubit get(context) => BlocProvider.of<GtinCubit>(context);

  // * Lists
  List<GTIN_Model> data = [];

  void getGtinData() async {
    emit(GtinLoadingState());

    try {
      final data = await GTINController.getProducts();
      emit(GtinLoadedState(data: data));
    } catch (e) {
      emit(GtinErrorState(message: e.toString()));
    }
  }

  void deleteGtinProductById(String productId) async {
    emit(GtinDeleteProductLoadingState());

    try {
      await GTINController.deleteProductById(productId);
      emit(GtinDeleteProductLoadedState());
    } catch (e) {
      emit(GtinErrorState(message: e.toString()));
    }
  }
}
