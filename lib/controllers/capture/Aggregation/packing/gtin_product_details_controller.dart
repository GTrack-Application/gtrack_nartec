import 'dart:convert';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/packing/GtinProductDetailsModel.dart';
import 'package:http/http.dart' as http;

class GtinProductDetailsController {
  static Future<GtinProductDetailsModel> getGtinProductDetails(
      String barcode) async {
    String? token = await AppPreferences.getToken();
    // String? userId = await AppPreferences.getUserId();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith3091}api/foreignGtin/getGtinProductDetails?barcode=$barcode";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body);
    print(data);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error']);
    }
  }
}
