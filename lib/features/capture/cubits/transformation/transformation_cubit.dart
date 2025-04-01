import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/features/capture/controllers/transformation/transformation_controller.dart';
import 'package:gtrack_nartec/features/capture/cubits/transformation/transformation_states.dart';
import 'package:gtrack_nartec/features/capture/models/transformation/attribute_option_model.dart';
import 'package:gtrack_nartec/features/capture/models/transformation/event_station_model.dart';

class TransformationCubit extends Cubit<TransformationState> {
  TransformationCubit() : super(EventStationInitState());

  final transformationController = TransformationController();

  /* 
  ########################################################################## 
  ?  EVENT STATION START
  ##########################################################################
  */

  //  Lists
  List<EventStation> stations = [];
  List<StationAttributeMaster> attributes = [];

  // ! Selected
  EventStation? selectedStation;

  // Map to cache attribute options by field name
  Map<String, List<AttributeOption>> attributeOptions = {};

  Future<void> getEventStations() async {
    emit(EventStationLoadingState());
    try {
      final stations = await transformationController.getEventStations();
      this.stations = stations;
      emit(EventStationLoadedState());
    } catch (e) {
      emit(EventStationErrorState(message: e.toString()));
    }
  }

  Future<void> getStationAttributes(
    String eventStationId,
    EventStation station,
  ) async {
    emit(SelectedEventStationLoadingState());
    try {
      selectedStation = station;
      final attributes = await transformationController.getStationAttributes(
        eventStationId,
      );
      this.attributes = attributes;
      emit(SelectedEventStationLoadedState());
    } catch (e) {
      emit(SelectedEventStationErrorState(message: e.toString()));
    }
  }

  Future<void> saveTransaction(Map<String, dynamic> formValues,
      Map<String, List<String>> arrayValues) async {
    emit(TransactionSavingState());
    try {
      // Process form values if needed (e.g., formatting dates)
      final processedFormValues = Map<String, dynamic>.from(formValues);

      // Convert DateTime objects to ISO format strings if present
      processedFormValues.forEach((key, value) {
        if (value is DateTime) {
          processedFormValues[key] = value.toIso8601String();
        }
      });

      // Special handling for destinationList and bizTransactionList
      // (they're already in the correct format in the form values)

      final result = await transformationController.saveStationAttributeHistory(
        processedFormValues,
        arrayValues,
      );

      emit(TransactionSavedState(data: result));
    } catch (e) {
      emit(TransactionSaveErrorState(message: e.toString()));
    }
  }

  // Fetch attribute options based on field name
  Future<List<AttributeOption>> fetchAttributeOptions(String fieldName) async {
    emit(AttributeOptionsLoadingState());
    try {
      // Return cached options if available
      if (attributeOptions.containsKey(fieldName)) {
        return attributeOptions[fieldName]!;
      }

      String endpoint;

      switch (fieldName) {
        case 'action':
          endpoint = '/api/stationAttribute/getActions';
          break;
        case 'businessStep':
          endpoint = '/api/stationAttribute/getBusinessSteps';
          break;
        case 'disposition':
          endpoint = '/api/stationAttribute/getDispositions';
          break;
        case 'bizTransactionList':
          endpoint = '/api/stationAttribute/getBusinessTypes';
          break;
        case 'destinationList':
          endpoint = '/api/stationAttribute/getMasterLocations';
          break;
        default:
          return [];
      }

      final response =
          await transformationController.fetchAttributeOptions(endpoint);
      attributeOptions[fieldName] = response.data;
      emit(AttributeOptionsLoadedState());
      return response.data;
    } catch (e) {
      log(e.toString());
      emit(AttributeOptionsErrorState(message: e.toString()));
      return [];
    }
  }

  /* 
  ########################################################################## 
  !  EVENT STATION END
  ##########################################################################
  */
}
