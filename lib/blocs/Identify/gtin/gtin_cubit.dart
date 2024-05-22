import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/blocs/Identify/gtin/gtin_states.dart';
import 'package:gtrack_mobile_app/controllers/Identify/gtin/gtin_controller.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:nb_utils/nb_utils.dart';

class GtinCubit extends Cubit<GtinState> {
  GtinCubit() : super(GtinInitState());

  static GtinCubit get(context) => BlocProvider.of<GtinCubit>(context);

  // * Lists
  List<GTIN_Model> data = [];

  void getGtinData() async {
    emit(GtinLoadingState());

    bool networkStatus = await isNetworkAvailable();
    if (networkStatus) {
      try {
        final data = await GTINController.getProducts();
        emit(GtinLoadedState(data: data));
      } catch (e) {
        emit(GtinErrorState(message: e.toString()));
      }
    } else {
      emit(GtinErrorState(message: 'No Internet Connection'));
    }
  }

  void deleteGtinProductById(String productId) async {
    emit(GtinDeleteProductLoadingState());

    bool networkStatus = await isNetworkAvailable();
    if (networkStatus) {
      try {
        await GTINController.deleteProductById(productId);
        emit(GtinDeleteProductLoadedState());
      } catch (e) {
        emit(GtinErrorState(message: e.toString()));
      }
    } else {
      emit(GtinErrorState(message: 'No Internet Connection'));
    }
  }
}
