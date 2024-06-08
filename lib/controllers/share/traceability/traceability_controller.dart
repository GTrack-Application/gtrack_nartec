import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/share/traceability/TraceabilityModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      return data.map((e) => TraceabilityModel.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)["error"]);
    }
  }
}
