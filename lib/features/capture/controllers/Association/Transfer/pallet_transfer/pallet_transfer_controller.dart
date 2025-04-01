import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/Association/Receiving/purchase_order_receipt/purchase_order_receipt_model.dart';
import 'package:http/http.dart' as http;

class PalletTransferController {
  static Future<List<PurchaseOrderReceiptModel>> getPalletTransfer() async {
    final token = await AppPreferences.getToken();

    final url =
        Uri.parse('${AppUrls.baseUrlWith7010}/api/grnpurchaseorder/master');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 && response.statusCode == 201) {
      var res = data as List;
      return res.map((e) => PurchaseOrderReceiptModel.fromJson(e)).toList();
    } else {
      var error = data['message'];
      throw Exception(error);
    }
  }
}
