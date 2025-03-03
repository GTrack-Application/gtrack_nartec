import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:http/http.dart' as http;

class SalesOrderController {
  static Future<List<SalesOrderModel>> getSalesOrder() async {
    final subUser = await AppPreferences.getMemberId();
    final token = await AppPreferences.getToken();

    final url =
        '${AppUrls.baseUrlWith7010}/api/salesInvoice/master?subUser_id=$subUser';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data.map((e) => SalesOrderModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
