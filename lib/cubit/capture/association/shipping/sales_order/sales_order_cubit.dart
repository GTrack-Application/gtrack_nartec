import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtrack_nartec/controllers/capture/Association/Shipping/sales_order_new/sales_order_controller.dart';
import 'package:gtrack_nartec/cubit/capture/association/shipping/sales_order/sales_order_state.dart';

class SalesOrderCubit extends Cubit<SalesOrderState> {
  SalesOrderCubit() : super(SalesOrderInitial());

  Future<void> getSalesOrder() async {
    try {
      emit(SalesOrderLoading());
      final salesOrder = await SalesOrderController.getSalesOrder();
      emit(SalesOrderLoaded(salesOrder));
    } catch (e) {
      emit(SalesOrderError(e.toString()));
    }
  }
}
