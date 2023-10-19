// ignore_for_file: unnecessary_string_interpolations, avoid_print

import 'dart:convert';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/RawMaterialsToWIP/GetMappedBarcodesRMByItemIdAndQtyModel.dart';
import 'package:gtrack_mobile_app/models/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorModel.dart';
import 'package:http/http.dart' as http;

class RawMaterialsToWIPController {
  static Future<List<GetSalesPickingListCLRMByAssignToUserAndVendorModel>>
      getSalesPickingListCLRMByAssignToUserAndVendorController(
    int userId,
    int vendorId,
  ) async {
    try {
      var response = await http.get(
          Uri.parse(
              '${AppUrls.baseUrlWithPort}getSalesPickingListCLRMByAssignToUserAndVendor?assign_to_user_id=$userId&vendor_id=$vendorId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '${AppUrls.token}'
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonString = jsonDecode(response.body) as List;
        return jsonString
            .map((item) =>
                GetSalesPickingListCLRMByAssignToUserAndVendorModel.fromJson(
                    item))
            .toList();
      } else {
        var jsonString = jsonDecode(response.body);
        var msg = jsonString['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<GetMappedBarcodesRMByItemIdAndQtyModel>
      getMappedBarcodesRMByItemIdAndQtyController(
    String itemId,
    int qty,
  ) async {
    final url = Uri.parse(
        '${AppUrls.baseUrlWithPort}getMappedBarcodesRMByItemIdAndQty?item_id=$itemId&qty=$qty');
    print(url);
    final headers = {'Host': AppUrls.host, 'Authorization': '${AppUrls.token}'};
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonString = jsonDecode(response.body);
        return GetMappedBarcodesRMByItemIdAndQtyModel.fromJson(jsonString);
      } else {
        var jsonString = jsonDecode(response.body);
        var msg = jsonString['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> insertItemsLnWIP(
    List<GetMappedBarcodesRMByItemIdAndQtyModel> items,
    String itemId,
    String itemName,
    int availableQuantity,
    String itemGroupId,
    String locations,
  ) async {
    String token = await AppPreferences.getToken().toString();
    final url = Uri.parse('${AppUrls.baseUrlWithPort}insertItemsLnWIP');
    final headers = {
      'Host': AppUrls.host,
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    // send some extra feilds with every item of the list
    var bodyData = items.map((e) {
      return {
        "item_id": itemId,
        "item_name": itemName,
        "available_quantity": availableQuantity,
        "item_group_id": itemGroupId,
        "locations": locations
      };
    }).toList();

    // convert the list to jsonQuery
    var body = jsonEncode(bodyData);

    print("$body");

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        var jsonString = jsonDecode(response.body);
        var msg = jsonString['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
