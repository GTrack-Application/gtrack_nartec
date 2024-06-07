import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Receiving/raw_materials/direct_receipt/ShipmentDataModel.dart';

import 'package:http/http.dart' as http;

class DirectReceiptController {
  static Future<List<Map<String, dynamic>>> getReceivingTypes() async {
    // String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    const url = "${AppUrls.baseUrlWith7000}/api/getReceivingTypes";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }

  static Future<ShipmentDataModel> getShipmentData(
    String receivingTypeId,
    String shipmentIdNo,
  ) async {
    // String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getShipmentData?receivingType=$receivingTypeId&id=$shipmentIdNo";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return ShipmentDataModel.fromJson(data);
    } else {
      throw Exception(jsonDecode(response.body)["message"]);
    }
  }
}
