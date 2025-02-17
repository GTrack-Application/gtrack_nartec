import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/pallet_number_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_details_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/purchase_order_receipt/purchase_order_receipt_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseOrderReceiptController {
  static Future<List<PurchaseOrderReceiptModel>>
      getPurchaseOrderReceipt() async {
    final url =
        Uri.parse("${AppUrls.baseUrlWith7010}/api/grnpurchaseorder/master");

    final response = await http.get(url);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => PurchaseOrderReceiptModel.fromJson(e)).toList();
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  static Future<List<PurchaseOrderDetailsModel>> handleRetrievePOs() async {
    final token = await AppPreferences.getToken();

    List<Map<String, dynamic>> filters = [
      {"field": "status", "operator": "neq", "value": "received"}
    ];

    final url = Uri.parse(
        "${AppUrls.baseUrlWith7010}/api/purchaseOrder/master/dynamicData?filters=${Uri.encodeComponent(jsonEncode(filters))}");

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => PurchaseOrderDetailsModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  static Future<List<PurchaseOrderDetailsModel>> handleSearch(
      String filter) async {
    final token = await AppPreferences.getToken();

    List<Map<String, dynamic>> filters = [
      {"field": "purchaseOrderNumber", "operator": "eq", "value": filter},
      {"field": "status", "operator": "neq", "value": "received"}
    ];

    final url = Uri.parse(
        "${AppUrls.baseUrlWith7010}/api/purchaseOrder/master/dynamicData?filters=${Uri.encodeComponent(jsonEncode(filters))}");

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;

      return data.map((e) => PurchaseOrderDetailsModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  static Future<List<PalletNumberDetailsModel>> searchPalletNumber(
      String palletNumber) async {
    final token = await AppPreferences.getToken();

    final url = Uri.parse(
        "${AppUrls.baseUrlWith7010}/api/expectedGoodsReceipt/details?palletNumber=$palletNumber");

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => PalletNumberDetailsModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  static Future<void> createExpectedGoodsReceipt(
    PurchaseOrderDetailsModel purchaseOrderDetails,
    String itemType,
    String palletNo,
    String batchNumber,
    String expiryDate,
    String netWeight,
    String sourceGln,
    String destinationGln,
    String shipmentDate,
    String expectedDeliveryDate,
  ) async {
    final token = await AppPreferences.getToken();

    final url = Uri.parse(
        "${AppUrls.baseUrlWith7010}/api/expectedGoodsReceipt/createExpectedGoodsReceipt");

    final body = jsonEncode({
      "palletCode": palletNo,
      "purchaseOrderNumber": purchaseOrderDetails.purchaseOrderNumber,
      "sourceGLN": sourceGln,
      "destinationGLN": destinationGln,
      "shipmentDate": shipmentDate,
      "expectedDelivery": expectedDeliveryDate,
      "itemType": itemType,
      "productId": purchaseOrderDetails.purchaseOrderDetails!.first.productId,
      "productName":
          purchaseOrderDetails.purchaseOrderDetails!.first.productName,
      "quantity": purchaseOrderDetails.purchaseOrderDetails!.first.quantity,
      "expiryDate": expiryDate,
      "batchNumber": batchNumber,
      "serialNumber": null,
      "netWeight": netWeight
    });

    print(body);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error']);
    }
  }
}
