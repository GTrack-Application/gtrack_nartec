import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/sales_order_new/sales_order_controller.dart';
import 'package:gtrack_nartec/controllers/epcis_controller.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';

class SalesOrderCubit extends Cubit<SalesOrderState> {
  SalesOrderCubit() : super(SalesOrderInitial());

  // Location tracking state
  LatLng? currentLocation;
  final Set<Marker> markers = {};
  bool hasArrived = false;

  Future<void> getSalesOrder() async {
    try {
      emit(SalesOrderLoading());
      final salesOrder = await SalesOrderController.getSalesOrder();
      emit(SalesOrderLoaded(salesOrder));
    } catch (e) {
      emit(SalesOrderError(e.toString()));
    }
  }

  Future<void> getSubSalesOrder(String salesOrderId) async {
    try {
      emit(SubSalesOrderLoading());
      final subSalesOrder =
          await SalesOrderController.getSubSalesOrder(salesOrderId);
      emit(SubSalesOrderLoaded(subSalesOrder));
    } catch (e) {
      emit(SubSalesOrderError(e.toString()));
    }
  }

  Future<void> getMapModel(String customerId) async {
    try {
      emit(MapModelLoading());

      final mapModel = await SalesOrderController.getMapModel(customerId);
      emit(MapModelLoaded(mapModel));
    } catch (e) {
      emit(MapModelError(e.toString()));
    }
  }

  Future<void> statusUpdate(
    String id,
    Map<String, dynamic> body,
    String? latitude,
    String? longitude,
  ) async {
    try {
      emit(StatusUpdateLoading());
      await SalesOrderController.statusUpdate(id, body);
      await EPCISController.insertNewEPCISEvent(
        eventType: "ObjectEvent",
        gln: "gln",
        latitude: latitude ?? "0.0",
        longitude: longitude ?? "0.0",
      );
      emit(StatusUpdateLoaded("Status updated successfully"));
    } catch (e) {
      emit(StatusUpdateError(e.toString()));
    }
  }

  Future<void> uploadSignature(File image, String id) async {
    try {
      emit(SignatureUploadLoading());
      await SalesOrderController.uploadImage(image, id);
      emit(SignatureUploadLoaded("Signature uploaded successfully"));
    } catch (e) {
      emit(SignatureUploadError(e.toString()));
    }
  }

  Future<void> uploadImages(
      List<File> images, String id, String salesInvoiceId) async {
    try {
      emit(ImageUploadLoading());
      await SalesOrderController.uploadImages(images, id, salesInvoiceId);
      emit(ImageUploadLoaded("Images uploaded successfully"));
    } catch (e) {
      emit(ImageUploadError(e.toString()));
    }
  }

  // Initialize location tracking
  Future<void> initializeLocation(LatLng destinationLocation) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentLocation = LatLng(position.latitude, position.longitude);

      // Add current location marker
      markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );

      // Add destination marker
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destination'),
        ),
      );

      emit(LocationInitialized(currentLocation!, markers));
      startLocationUpdates(destinationLocation);
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  void startLocationUpdates(LatLng destinationLocation) {
    Geolocator.getPositionStream().listen((position) {
      currentLocation = LatLng(position.latitude, position.longitude);
      updateCurrentLocationMarker();
      checkArrival(destinationLocation);
      emit(LocationUpdated(currentLocation!, markers, hasArrived));
    });
  }

  void updateCurrentLocationMarker() {
    markers.removeWhere(
        (marker) => marker.markerId == const MarkerId('current_location'));
    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  void checkArrival(LatLng destinationLocation) {
    if (currentLocation != null) {
      final distance = Geolocator.distanceBetween(
        currentLocation!.latitude,
        currentLocation!.longitude,
        destinationLocation.latitude,
        destinationLocation.longitude,
      );
      // Consider arrived if within 50 meters
      hasArrived = distance <= 50;
    }
  }
}
