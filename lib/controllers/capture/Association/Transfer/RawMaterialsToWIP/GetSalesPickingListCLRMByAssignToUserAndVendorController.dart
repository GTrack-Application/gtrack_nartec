// ignore_for_file: unnecessary_string_interpolations, avoid_print, file_names, non_constant_identifier_names

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/RawMaterialsToWIP/GetMappedBarcodesRMByItemIdAndQtyModel.dart';
import 'package:gtrack_nartec/models/capture/Association/Transfer/RawMaterialsToWIP/GetSalesPickingListCLRMByAssignToUserAndVendorModel.dart';
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
        '${AppUrls.baseUrlWith7010}/api/getSalesPickingListCLRMByAssignToUserAndVendor?assign_to_user_id=$userId&vendor_id=$vendorId');
    print(url);
    String? token;
    await AppPreferences.getToken().then((value) => token = value);
    final headers = <String, String>{
      'Authorization': '$token',
      'Content-Type': 'application/json',
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
        '${AppUrls.baseUrlWith7010}getMappedBarcodesRMByItemIdAndQty?item_id=$itemId&qty=$qty');
    print(url);
    final headers = <String, String>{
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

    final url = Uri.parse('${AppUrls.baseUrlWith7010}insertItemsLnWIP');
    final headers = {
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
    String EventAction, // OBSERVE
    int totalRows,
    String eventAction,
    String disposition, // // Internal Transfer
    String bizStep,
    String readPoint,
    String bizTransactionList,
    String parentId,
  ) async {
    // String? token;
    // await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('${AppUrls.baseUrlWith7010}insertEPCISEvent');

    print(url);

    final headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    String eventTime = DateTime.now().toIso8601String();
    String eventTimeZoneOffSet = DateTime.now().timeZoneOffset.toString();
    String createDate = DateTime.now().toIso8601String();

    // Globally unique ID of the event, used for deduplication and event retrieval. EPCIS2.0 specifies a hashing algorithm to construct a worldwide-unique ID for an event.
    String uniqueEventID = DateTime.now().toIso8601String();

    String? userId;
    await AppPreferences.getUserId().then((value) => userId = value.toString());

    final body = {
      "EventType": eventAction,
      "EventAction": EventAction,
      "EventTime": eventTime,
      "EventTimeZoneOffSet": eventTimeZoneOffSet,
      "epcList": ["urn:epc:id:sgtin:6287.028930005"],
      "bizStep": bizStep,
      "disposition": disposition,
      "bizTransactionList": bizTransactionList,
      "readPoint": {"id": "urn:epc:id:sgln:6285084.00002.1"},
      "sourceList": "urn:epcglobal:cbv:sdt:owning_party",
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
      "creationDate": createDate,
      "sender": userId,
      "receiver": userId,
      "instanceIdentifer": uniqueEventID
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      var msg = data['error'];
      throw Exception(msg);
    }
  }

  static Future<void> insertGtrackEPCISLog(
    String transactionType,
    String gtin,
    String glnFrom,
    String glnTo,
    String industryType,
  ) async {
    String? userId = await AppPreferences.getUserId();
    final url =
        Uri.parse('${AppUrls.baseUrlWith7010}/api/insertGtrackEPCISLog');

    print(url);

    final headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "gs1UserId": userId.toString(),
      "TransactionType": transactionType,
      "GTIN": gtin,
      "GLNFrom": glnFrom,
      "GLNTo": glnTo,
      "IndustryType": industryType
    });
    var response = await http.post(url, headers: headers, body: body);

    var data = jsonDecode(response.body);

    print(data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      var msg = data['error'];
      throw Exception(msg);
    }
  }
}
