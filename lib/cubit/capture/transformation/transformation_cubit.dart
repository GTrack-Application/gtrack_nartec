import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/transformation/transformation_controller.dart';
import 'package:gtrack_nartec/cubit/capture/transformation/transformation_states.dart';
import 'package:gtrack_nartec/models/capture/transformation/event_station_model.dart';

class EventStationCubit extends Cubit<EventStationState> {
  EventStationCubit() : super(EventStationInitState());

  final transformationController = TransformationController();

  // Lists
  List<EventStation> stations = [];

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
}

class SelectedEventStationCubit extends Cubit<SelectedEventStationState> {
  SelectedEventStationCubit() : super(SelectedEventStationInitState());

  final transformationController = TransformationController();

  // Data
  List<StationAttributeMaster> attributes = [];
  EventStation? selectedStation;

  Future<void> getStationAttributes(
      String eventStationId, EventStation station) async {
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
}
