import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/controllers/capture/capture_controller.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/aggregation_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/association_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/MappingRFID/mapping_rfid_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Mapping_Barcode/BarcodeMappingScreen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/serialization_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Transformation/transformation_screen.dart';
import 'package:nb_utils/nb_utils.dart';

part 'capture_states.dart';

class CaptureCubit extends Cubit<CaptureState> {
  CaptureCubit() : super(CaptureInitial());

  static CaptureCubit get(context) => BlocProvider.of<CaptureCubit>(context);

  List mainScreens(context) => [
        {
          "text": "ASSOCIATION",
          "icon": AppIcons.association,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: const AssociationScreen()),
        },
        {
          "text": "TRANSFORMATION",
          "icon": AppIcons.transformation,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: const TransformationScreen()),
        },
        {
          "text": "AGGREGATION",
          "icon": AppIcons.aggregation,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: const AggregationScreen()),
        },
        {
          "text": "SERIALIZATION",
          "icon": AppIcons.serialization,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: const SerializationScreen()),
        },
        {
          "text": "MAPPING BARCODE",
          "icon": AppIcons.mapping,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: BarcodeMappingScreen()),
        },
        {
          "text": "MAPPING RFID",
          "icon": AppIcons.mappingRFID,
          "onTap": () => AppNavigator.goToPage(
              context: context, screen: const MappingRFIDScreen()),
        },
      ];

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
