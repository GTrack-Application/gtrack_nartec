import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/traceability/TraceabilityModel.dart';
import 'package:http/http.dart' as http;

class TraceabilityController {
  static Future<List<TraceabilityModel>> getReceivingTypes(String gtin) async {
    // String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url = Uri.parse(
        "${AppUrls.baseUrlWith7000}/api/getGtrackEPCISLogs?GTIN=$gtin");

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var response = await http.get(url, headers: headers);

    // log(response.body);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      return data.map((e) => TraceabilityModel.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }
}
