import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_mobile_app/constants/app_icons.dart';
import 'package:gtrack_mobile_app/controllers/capture/capture_controller.dart';
import 'package:gtrack_mobile_app/global/common/utils/app_navigator.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/GTINModel.dart';
import 'package:gtrack_mobile_app/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Aggregation/aggregation_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Association/association_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/MappingRFID/mapping_rfid_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Mapping_Barcode/BarcodeMappingScreen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Serialization/serialization_screen.dart';
import 'package:gtrack_mobile_app/screens/home/capture/Transformation/transformation_screen.dart';
import 'package:intl/intl.dart';
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
              context: context,
              screen: BlocProvider<CaptureCubit>(
                create: (context) => CaptureCubit(),
                child: const SerializationScreen(),
              )),
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

  TextEditingController gtin = TextEditingController();

  // Lists
  List<SerializationModel> serializationData = [];
  List<GTIN_Model> gtinProducts = [];

  // Create serials variables
  int? quantity;
  String? batchNumber;
  var expiryDate = TextEditingController();
  var manufacturingDate = TextEditingController();

  // Create serials helper functions
  Future<void> setExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      expiryDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> setManufacturingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      manufacturingDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  // * Serialization ***
  getSerializationData(String barcode) async {
    try {
      var network = await isNetworkAvailable();
      if (network) {
        emit(CaptureSerializationLoading());
        final data = await CaptureController().getSerializationData(barcode);
        if (data.isEmpty) {
          emit(CaptureSerializationEmpty());
        } else {
          emit(CaptureSerializationSuccess(data));
        }
      } else {
        emit(CaptureSerializationError('No Internet Connection'));
      }
    } catch (error) {
      emit(CaptureSerializationError(error.toString()));
    }
  }

  createNewSerial(String gtin) async {
    try {
      var network = await isNetworkAvailable();
      if (network) {
        emit(CaptureCreateSerializationLoading());
        final data = await CaptureController().createNewSerial(
          gtin: gtin,
          quantity: quantity!,
          batchNumber: batchNumber.toString(),
          expiryDate: expiryDate.text,
          manufacturingDate: manufacturingDate.text,
        );
        emit(CaptureCreateSerializationSuccess(data));
      } else {
        emit(CaptureCreateSerializationError('No Internet Connection'));
      }
    } catch (error) {
      emit(CaptureCreateSerializationError(error.toString()));
    }
  }

  // * GTIN ***
  getGtinProducts() async {
    try {
      var network = await isNetworkAvailable();
      if (network) {
        emit(CaptureGetGtinProductsLoading());
        final data =
            await CaptureController().getProducts(gtin: gtin.text.trim());
        if (data.isEmpty) {
          emit(CaptureGetGtinProductsEmpty());
        } else {
          emit(CaptureGetGtinProductsSuccess(data));
        }
      } else {
        emit(CaptureGetGtinProductsError('No Internet Connection'));
      }
    } catch (error) {
      emit(CaptureGetGtinProductsError(error.toString()));
    }
  }
}
