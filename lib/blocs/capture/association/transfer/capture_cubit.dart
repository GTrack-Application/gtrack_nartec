import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/controllers/capture/capture_controller.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:nb_utils/nb_utils.dart';

part 'capture_states.dart';

class CaptureCubit extends Cubit<CaptureState> {
  CaptureCubit() : super(CaptureInitial());

  static CaptureCubit get(context) => BlocProvider.of<CaptureCubit>(context);

  String gtin = '';

  // Lists
  List<SerializationModel> serializationData = [];

  // * Serialization ***
  getSerializationData() async {
    try {
      var network = await isNetworkAvailable();
      if (network) {
        emit(CaptureSerializationLoading());
        final data = await CaptureController().getSerializationData(gtin);
        emit(CaptureSerializationSuccess(data));
      } else {
        emit(CaptureSerializationError('No Internet Connection'));
      }
    } catch (error) {
      emit(CaptureSerializationError(error.toString()));
    }
  }
}
