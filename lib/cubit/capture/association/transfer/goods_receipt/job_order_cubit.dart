import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/goods_receipt/job_order/job_order_model.dart';

part 'job_order_state.dart';

class JobOrderCubit extends Cubit<JobOrderState> {
  JobOrderCubit() : super(JobOrderInitial());

  static JobOrderCubit get(BuildContext context) =>
      BlocProvider.of<JobOrderCubit>(context);

  final HttpService _httpService = HttpService();

  // Lists
  final List<JobOrderBillOfMaterial> _selectedItems = [];
  List<JobOrderModel> orders = [];

  get items => _selectedItems;

  Future<void> getJobOrders() async {
    emit(JobOrderLoading());
    try {
      final token = await AppPreferences.getToken();
      final response = await _httpService.request(
        '/api/workInProgress/items',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final List<dynamic> data = response.data;
        orders = data.map((e) => JobOrderModel.fromJson(e)).toList();

        emit(JobOrderLoaded(orders: orders));
      } else {
        emit(JobOrderError(message: 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(JobOrderError(message: e.toString()));
    }
  }

  Future<void> getJobOrderBomDetails(String wipItemId) async {
    emit(JobOrderDetailsLoading());
    try {
      final token = await AppPreferences.getToken();
      final url = '/api/workInProgress/wipBom?wipItemId=$wipItemId';
      final response = await _httpService.request(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.success) {
        final List<dynamic> data = response.data;
        final bomDetails =
            data.map((e) => JobOrderBillOfMaterial.fromJson(e)).toList();

        _selectedItems.clear();
        _selectedItems.addAll(bomDetails);

        emit(JobOrderDetailsLoaded(bomDetails: bomDetails));
      } else {
        emit(JobOrderDetailsError(message: 'Failed to fetch BOM details'));
      }
    } catch (e) {
      emit(JobOrderDetailsError(message: e.toString()));
    }
  }

  void selectJobOrderItem(int index) {
    // unselect all items
    for (var element in _selectedItems) {
      element.isSelected = -1;
    }
    final item = _selectedItems[index];
    item.isSelected = item.isSelected == -1 ? 1 : -1;
    emit(JobOrderDetailsLoaded(bomDetails: _selectedItems));
  }

  void addToProduction() {
    try {
// get selected item
      final selectedItems =
          _selectedItems.where((element) => element.isSelected == 1).toList();
      if (selectedItems.isEmpty) {
        throw Exception("No items selected");
      }
      for (var item in selectedItems) {
        if (item.status == "picked") {
          throw Exception("Item is already picked");
        }
      }

      final selectedItem = selectedItems.first;
      // TODO: Add to production
    } catch (error) {
      emit(AddToProductionError(message: error.toString()));
    }
  }
}
