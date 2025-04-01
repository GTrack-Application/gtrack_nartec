import 'dart:convert';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/GtinProductDetailsModel.dart';
import 'package:http/http.dart' as http;

class GtinProductDetailsController {
  static Future<GtinProductDetailsModel> getGtinProductDetails(
      String barcode) async {
    // String? token = await AppPreferences.getToken();
    // String? userId = await AppPreferences.getUserId();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith3091}api/foreignGtin/getGtinProductDetails?barcode=$barcode";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",

      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return GtinProductDetailsModel.fromJson(data);
    } else {
      throw Exception(data['error']);
    }
  }

  static Future<void> completePacking(
    String gtin,
    String batchNo,
    String manufacturingDate,
    String expiryDate,
    int quantity,
    String gln,
    double netWeight,
    String unitOfMeasure,
    String itemImage,
    String itemName,
  ) async {
    // String? token = await AppPreferences.getToken();
    String? userId = await AppPreferences.getUserId();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    const url = "${AppUrls.baseUrlWith7010}/api/insertPackedItem";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",

      // "Authorization": "Bearer $token",
    };

    var body = jsonEncode({
      "GTIN": gtin,
      "BATCH": batchNo,
      "ManufacturingDate": manufacturingDate,
      "User_id": userId,
      "Quantity": quantity,
      "GLN": gln,
      "NetWeight": netWeight,
      "UnitOfMeasure": unitOfMeasure,
      "ExpiryDate": expiryDate,
      "ItemImage": itemImage,
      "ItemName": itemName
    });

    var response = await http.post(uri, body: body, headers: headers);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error']);
    }
  }
}
