import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/reveiving/supplier_receipt/GetTblStockMasterByItemIdModel.dart'
    show GetTblStockMasterByItemIdModel;
import 'package:http/http.dart' as http;

class GetTblStockMasterByItemIdController {
  static Future<List<GetTblStockMasterByItemIdModel>> getData(
      String itemId) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/getTblStockMasterByItemId?itemid=$itemId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<GetTblStockMasterByItemIdModel> shipmentData = data
            .map((e) => GetTblStockMasterByItemIdModel.fromJson(e))
            .toList();
        return shipmentData;
      } else {
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
