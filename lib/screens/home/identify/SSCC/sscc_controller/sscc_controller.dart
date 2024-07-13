import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SsccController {
  static Future<void> postSsccBulk(String preDigit, int quantity) async {
    String? id = await AppPreferences.getUserId();
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}api/sscc/bulk');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body =
        jsonEncode({"preDigit": preDigit, "quantity": quantity, "user_id": id});

    final response = await http.post(url, headers: headers, body: body);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception(data['error']);
    }
  }

  static Future<void> addSsccByPallet(
    String ssccType,
    String vendorId,
    String vendorName,
    String productId,
    String productDesc,
    String serialNo,
    String itemCode,
    String qty,
    String useBy,
    String batchNo,
    String boxOf,
  ) async {
    String? id = await AppPreferences.getUserId();
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}api/sscc');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "sscc_type": ssccType,
      "VendorID": vendorId,
      "VendorName": vendorName,
      "productID": productId,
      "description": productDesc,
      "SerialNumber": serialNo,
      "ItemCode": itemCode,
      "Qty": qty,
      "UseBy": useBy,
      "BatchNo": batchNo,
      "Boxof": boxOf,
      "user_id": id
    });

    final response = await http.post(url, headers: headers, body: body);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception(data['error']);
    }
  }

  static Future<void> addSsccByLabel(
    String ssccType,
    String hsnSkuNo,
    String poNo,
    String expDate,
    String vendorId,
    String cartonQty,
    String shipTo,
    String shipDate,
    String vendorItemNo,
    String desc,
    String shortQtyCode,
    String carton,
    String origin,
  ) async {
    String? id = await AppPreferences.getUserId();
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}api/sscc');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "sscc_type": ssccType,
      "hsn_sku": hsnSkuNo,
      "po_no": poNo,
      "expiraton_date": expDate,
      "VendorID": vendorId,
      "Qty": cartonQty,
      "ship_to": shipTo,
      "ship_date": shipDate,
      "vendor_item_no": vendorItemNo,
      "description": desc,
      "short_qty_code": shortQtyCode,
      "carton": carton,
      "country_id": origin,
      "user_id": id
    });

    final response = await http.post(url, headers: headers, body: body);

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
    } else {
      throw Exception(data['error']);
    }
  }
}
