// ignore_for_file: unnecessary_string_interpolations, avoid_print, file_names, non_constant_identifier_names

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
    print(userId);
    print(vendorId);
    final url = Uri.parse(
        '${AppUrls.baseUrlWith7000}getSalesPickingListCLRMByAssignToUserAndVendor?assign_to_user_id=$userId&vendor_id=$vendorId');
    print(url);
    String? token;
    await AppPreferences.getToken().then((value) => token = value);
    final headers = <String, String>{
      'Authorization': '$token',
      'Content-Type': 'application/json',
      'Host': AppUrls.host,
    };
    print(headers);
    try {
      var response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
        var jsonString = jsonDecode(response.body) as List;
        return jsonString
            .map((item) =>
                GetSalesPickingListCLRMByAssignToUserAndVendorModel.fromJson(
                    item))
            .toList();
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

  static Future<GetMappedBarcodesRMByItemIdAndQtyModel>
      getMappedBarcodesRMByItemIdAndQtyController(
    String itemId,
    int qty,
  ) async {
    String? token;
    await AppPreferences.getToken().then((value) => token = value.toString());
    final url = Uri.parse(
        '${AppUrls.baseUrlWith7000}getMappedBarcodesRMByItemIdAndQty?item_id=$itemId&qty=$qty');
    print(url);
    final headers = <String, String>{
      'Host': AppUrls.host,
      'Authorization': token!,
    };
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
    List<int> pickedQtyList,
    List<GetMappedBarcodesRMByItemIdAndQtyModel> items,
    int availableQuantity,
    String itemGroupId,
    String locations,
  ) async {
    String? token;
    await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('${AppUrls.baseUrlWith7000}insertItemsLnWIP');
    final headers = {
      'Host': AppUrls.host,
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };
    print(headers);

    // send some extra feilds with every item of the list
    var bodyData = items.map((e) {
      return {
        "item_id": e.itemId,
        "item_name": e.itemName,
        "available_quantity": pickedQtyList[items.indexOf(e)],
        "item_group_id": e.itemGroupId,
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

  static Future<void> insertEPCISEvent(
    String EventAction,
    int totalRows,
    String eventAction,
    String disposition,
    String bizStep,
    String readPoint,
    String bizTransactionList,
    String parentId,
  ) async {
    String? token;

    await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('${AppUrls.baseUrlWith7000}insertEPCISEvent');

    final headers = {
      'Host': AppUrls.host,
      'Authorization': '$token',
      'Content-Type': 'application/json',
    };

    print(headers);

    String eventTime = DateTime.now().toIso8601String();
    String eventTimeZoneOffSet = DateTime.now().timeZoneOffset.toString();
    String createDate = DateTime.now().toIso8601String();

    // Globally unique ID of the event, used for deduplication and event retrieval. EPCIS2.0 specifies a hashing algorithm to construct a worldwide-unique ID for an event.
    String uniqueEventID = DateTime.now().toIso8601String();

    String? userId;
    await AppPreferences.getUserId().then((value) => userId = value.toString());

    final body = {
      "EventType": "$eventAction",
      "EventAction": "$EventAction", // observe, add, or delete
      "EventTime": "$eventTime",
      "EventTimeZoneOffSet": "$eventTimeZoneOffSet",
      "epcList": ["urn:epc:id:sgtin:0614141.107346.2018"],
      // "bizLocation": "urn:epcglobal:cbv:loc:0614141.00001.0",
      "bizStep": "$bizStep",
      "disposition": "$disposition",
      "bizTransactionList": "$bizTransactionList",
      "readPoint": {
        "id":
            "urn:epc:id:sgln:6285084.00002.1", // "readPoint" will be pass here...
      },
      "sourceList":
          "urn:epcglobal:cbv:sdt:owning_party", // "urn:epcglobal:cbv:sdt:owning_party",
      "destinationList": "urn:epcglobal:cbv:sdt:possessing_party",
      "sensorElementList": "temperature, humidity",
      "childQuantityList": [
        {"epcClass": "urn:epc:class:lgtin:4012345.012345", "quantity": 1200}
      ],
      "childEPCs": ["urn:epc:id:sgtin:0614141.107346.2017"],
      "parentID": "urn:epc:id:sscc:0614141.1234567890",
      "inputEPCList": "urn:epc:id:sgtin:0614141.107346.2016",
      "inputQuantityList": [
        {
          "epcClass": "urn:epc:class:lgtin:4012345.012345",
          "quantity": 200,
          "uom": "kg"
        }
      ],
      "outputEPCList": "urn:epc:id:sgtin:0614141.107346.2015",
      "ilmd": "",
      "errorDeclaration": "",
      "quantityList": "$totalRows",
      "persistentDisposition": "urn:epcglobal:cbv:disp:in_progress",
      "creationDate": "$createDate",
      "sender": "$userId",
      "receiver": "$userId",
      "instanceIdentifer": "$uniqueEventID"
    };

    print("Hello......");

    try {
      var response =
          await http.post(url, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
      } else {
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");
        var jsonString = jsonDecode(response.body);

        var msg = jsonString['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
