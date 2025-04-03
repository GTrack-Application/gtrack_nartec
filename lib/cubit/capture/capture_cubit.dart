import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_icons.dart';
import 'package:gtrack_nartec/controllers/capture/capture_controller.dart';
import 'package:gtrack_nartec/global/common/utils/app_navigator.dart';
import 'package:gtrack_nartec/models/IDENTIFY/GTIN/gtin_model.dart';
import 'package:gtrack_nartec/models/capture/mapping/mapped_barcode_request_model.dart';
import 'package:gtrack_nartec/models/capture/mapping/stock_master_model.dart';
import 'package:gtrack_nartec/models/capture/serialization/serialization_model.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Association/association_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Mapping_Barcode/barcode_mapping_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Serialization/serialization_screen.dart';
import 'package:gtrack_nartec/screens/home/capture/Transformation/transformation_screen.dart';
import 'package:intl/intl.dart';

part 'capture_states.dart';

class CaptureCubit extends Cubit<CaptureState> {
  CaptureCubit() : super(CaptureInitial());

  static CaptureCubit get(context) => BlocProvider.of<CaptureCubit>(context);

  // Lists
  List<SerializationModel> scannedBarcodes = [];
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
              context: context, screen: const BarcodeMappingScreen()),
        },
        {
          "text": "MAPPING RFID",
          "icon": AppIcons.mappingRFID,
          "onTap": () {
            // AppNavigator.goToPage(
            //     context: context, screen: const MappingRFIDScreen());
          },
        },
      ];

  TextEditingController gtin = TextEditingController();

  // Lists
  List<SerializationModel> serializationData = [];
  List<GTINModell> gtinProducts = [];

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
      emit(CaptureSerializationLoading());
      final data = await CaptureController().getSerializationData(barcode);
      if (data.isEmpty) {
        emit(CaptureSerializationEmpty());
      } else {
        scannedBarcodes = data;

        emit(CaptureSerializationSuccess(data));
      }
    } catch (error) {
      emit(CaptureSerializationError(error.toString()));
    }
  }

  createNewSerial(String gtin) async {
    try {
      emit(CaptureCreateSerializationLoading());
      final data = await CaptureController().createNewSerial(
        gtin: gtin,
        quantity: quantity!,
        batchNumber: batchNumber.toString(),
        expiryDate: expiryDate.text,
        manufacturingDate: manufacturingDate.text,
      );
      emit(CaptureCreateSerializationSuccess(data));
    } catch (error) {
      emit(CaptureCreateSerializationError(error.toString()));
    }
  }

  // * GTIN ***
  getGtinProducts() async {
    try {
      emit(CaptureGetGtinProductsLoading());
      final data =
          await CaptureController().getProducts(gtin: gtin.text.trim());
      emit(CaptureGetGtinProductsSuccess(data));
    } catch (error) {
      emit(CaptureGetGtinProductsError(error.toString()));
    }
  }

  /*
  ?
  ##############################################################################
  ?
    Barcode Mapping Start
  ? 
  ##############################################################################
  ?
  */

  List<StockMasterModel> stockMasterData = [];

  Future<void> getStockMasterByItemName(String? itemName) async {
    emit(CaptureStockMasterLoading());
    try {
      final data = await CaptureController().getStockMasterByItemName(itemName);
      stockMasterData = data;
      if (stockMasterData.isEmpty) {
        emit(CaptureStockMasterEmpty());
      } else {
        emit(CaptureStockMasterSuccess(stockMasterData));
      }
    } catch (e) {
      emit(CaptureStockMasterError(e.toString()));
    }
  }

  Future<void> createMappedBarcode(MappedBarcodeRequestModel data) async {
    emit(CaptureCreateMappedBarcodeLoading());
    try {
      final result = await CaptureController().createMappedBarcode(data);
      emit(CaptureCreateMappedBarcodeSuccess(result));
    } catch (e) {
      emit(CaptureCreateMappedBarcodeError(e.toString()));
    }
  }

  /*
  ?
  ##############################################################################
  ?
    Barcode Mapping End
  ? 
  ##############################################################################
  ?
  */
}
