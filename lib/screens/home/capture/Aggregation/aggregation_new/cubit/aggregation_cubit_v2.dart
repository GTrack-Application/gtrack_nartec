import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/global/services/http_service.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/cubit/aggregation_state_v2.dart';
import 'package:gtrack_nartec/screens/home/capture/Aggregation/aggregation_new/model/packaging_model.dart';

class AggregationCubit extends Cubit<AggregationState> {
  AggregationCubit() : super(AggregationInitial());

  final HttpService httpService = HttpService();

  List<PackagingModel> packaging = [];

  void getPackaging() async {
    try {
      emit(AggregationLoading());
      final response = await httpService.request(
        "/api/ssccPackaging?packagingType=box_carton&association=true",
        method: HttpMethod.get,
      );
      final res = response.data['data'] as List;
      log(res.toString());
      packaging = res.map((json) => PackagingModel.fromJson(json)).toList();
      emit(AggregationLoaded(packaging: packaging));
    } catch (e) {
      emit(AggregationError(message: e.toString()));
    }
  }
}
