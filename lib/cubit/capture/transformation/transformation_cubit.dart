import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/transformation/transformation_controller.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_states.dart';
import 'package:gtrack_nartec/models/capture/transformation/event_station_model.dart';

class TransformationCubit extends Cubit<EventStationState> {
  TransformationCubit() : super(EventStationInitState());

  final transformationController = TransformationController();

  /* 
  ########################################################################## 
    EVENT STATION START
  ##########################################################################
  */

  // ? Lists
  List<EventStation> stations = [];
  List<StationAttributeMaster> attributes = [];

  // ! Selected
  EventStation? selectedStation;

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

      log(processedFormValues.toString());
      log(arrayValues.toString());

      final result = await transformationController.saveStationAttributeHistory(
        processedFormValues,
        arrayValues,
      );

      emit(TransactionSavedState(data: result));
    } catch (e) {
      emit(TransactionSaveErrorState(message: e.toString()));
    }
  }

  /* 
  ########################################################################## 
    EVENT STATION END
  ##########################################################################
  */
}
