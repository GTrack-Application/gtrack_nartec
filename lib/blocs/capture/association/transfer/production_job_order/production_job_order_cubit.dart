import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/blocs/capture/association/transfer/production_job_order/production_job_order_state.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/ProductionJobOrder/production_job_order.dart';
import 'package:http/http.dart' as http;

class ProductionJobOrderCubit extends Cubit<ProductionJobOrderState> {
  ProductionJobOrderCubit() : super(ProductionJobOrderInitial());

  Future<void> getProductionJobOrders() async {
    emit(ProductionJobOrderLoading());
    try {
      final memberId = await AppPreferences.getUserId();
      final token = await AppPreferences.getToken();

      final response = await http.get(
        Uri.parse(
            '${AppUrls.baseUrlWith7000}/api/jobOrder/details?memberId=$memberId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final orders = data.map((e) => ProductionJobOrder.fromJson(e)).toList();
        emit(ProductionJobOrderLoaded(orders: orders));
      } else {
        emit(ProductionJobOrderError(message: 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(ProductionJobOrderError(message: e.toString()));
    }
  }
}
