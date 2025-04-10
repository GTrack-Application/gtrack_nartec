// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;

class EPCISController {
  static Future<bool> insertEPCISEvent({
    required String type,
    required String action,
    required String bizStep,
    required String disposition,
    Map<String, dynamic>? payload,
    String? gln,
    List? epcList,
    List? bizTransactionList,
  }) async {
    // String? token;
    // await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('${AppUrls.baseUrlWith7010}/api/insertEPCISEvent');

    final headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    String eventTime = DateTime.now().toIso8601String();
    // Format timezone offset to ±HH:MM format
    Duration offset = DateTime.now().timeZoneOffset;
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = (offset.inMinutes.abs() % 60);
    String eventTimeZoneOffSet =
        '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    String createDate = DateTime.now().toIso8601String();

    // Globally unique ID of the event, used for deduplication and event retrieval. EPCIS2.0 specifies a hashing algorithm to construct a worldwide-unique ID for an event.
    String uniqueEventID = DateTime.now().toIso8601String();

    String? userId;
    await AppPreferences.getUserId().then((value) => userId = value.toString());

    final body = payload ??
        {
          "type": type,
          "action": action,
          "bizStep": bizStep,
          "disposition": disposition,
          "eventTime": eventTime,
          "eventTimeZoneOffset": eventTimeZoneOffSet,
          "epcList":
              epcList ?? ["urn:epc:id:sgtin:6285561.CV-100G SS220 PG.2268"],
          "readPoint": {"id": "urn:epc:id:sgln:$gln"},
          "bizLocation": {"id": "urn:epc:id:sgln:$gln"},
          "bizTransactionList": bizTransactionList ??
              [
                {
                  "type": "po",
                  "bizTransaction":
                      "http://transaction.acme.com/jo/cm6t2unxh0004eg3qjjt8m276"
                }
              ],
          "creationDate": createDate,
        };

    log("EPCIS Body: ${jsonEncode(body)}");

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    log("EPCIS Response: ${response.body}");
    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(result['message'] ??
          result['error'] ??
          'Failed to insert EPCIS event');
      // return false;
    }
  }

  static Future<bool> insertNewEPCISEvent({
    required String eventType,
    String? gln,
    String? latitude,
    String? longitude,
    List? epcList,
    List? bizTransactionList,
    List? childEPCs,
    List? childQuantityList,
  }) async {
    // String? token;
    // await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('https://epcis.gtrack.online/api/epcis/events');

    final headers = {
      'Authorization': 'Bearer token',
      'Content-Type': 'application/json',
    };

    String eventTime = DateTime.now().toIso8601String();
    // Format timezone offset to ±HH:MM format
    Duration offset = DateTime.now().timeZoneOffset;
    String sign = offset.isNegative ? '-' : '+';
    int hours = offset.inHours.abs();
    int minutes = (offset.inMinutes.abs() % 60);
    String eventTimeZoneOffSet =
        '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

    final gs1CompanyPrefix = await AppPreferences.getGs1Prefix();
    final memberId = await AppPreferences.getMemberId();

    Map<String, dynamic> payload = {};

    if (eventType == 'TransactionEvent') {
      payload = {
        "type": "TransactionEvent",
        "action": "ADD",
        "bizStep": "selling",
        "disposition": "sold",
        "epcList": epcList ?? ["urn:epc:id:sgtin:$gln"],
        "parentID": "urn:epc:id:gdti:$gln",
        "eventTime": eventTime,
        "eventTimeZoneOffset": eventTimeZoneOffSet,
        "readPoint": {"id": "urn:epc:id:sgln:$gln"},
        "bizLocation": {"id": "urn:epc:id:sgln:$gln"},
        // "quantityList": [
        //   {
        //     "epcClass": "urn:epc:class:sgtin:$gln",
        //     "quantity": 1,
        //     "uom": "EA"
        //   }
        // ],
        "gs1CompanyPrefix": "$gs1CompanyPrefix",
        "longitude": "$longitude",
        "latitude": "$latitude"
      };
    } else if (eventType == "AggregationEvent") {
      payload = {
        "type": eventType,
        "action": "ADD",
        "bizStep": "packing",
        "disposition": "packed",
        "parentID": "urn:epc:id:sscc:$gs1CompanyPrefix.0000000001",
        "childEPCs": childEPCs ??
            [
              "urn:epc:id:sgtin:$gs1CompanyPrefix.00001.1234",
              "urn:epc:id:sgtin:$gs1CompanyPrefix.00001.5678"
            ],
        "eventTime": eventTime,
        "eventTimeZoneOffset": eventTimeZoneOffSet,
        "readPoint": {"id": "urn:epc:id:sgln:$gln"},
        "bizLocation": {"id": "urn:epc:id:sgln:$gln"},
        "childQuantityList": childQuantityList ??
            [
              {
                "epcClass": "urn:epc:class:sgtin:$gs1CompanyPrefix.00001.*",
                "quantity": 5
              },
              {
                "epcClass": "urn:epc:class:sgtin:$gs1CompanyPrefix.00001.*",
                "quantity": 5
              }
            ],
        "gs1CompanyPrefix": "$gs1CompanyPrefix",
        "longitude": "$longitude",
        "latitude": "$latitude"
      };
    } else if (eventType == "TransactionEvent") {
      payload = {
        "type": "TransactionEvent",
        "action": "ADD",
        "bizStep": "selling",
        "disposition": "sold",
        "epcList": ["urn:epc:id:sgtin:$gs1CompanyPrefix.00001.1234"],
        "parentID": "urn:epc:id:gdti:$gs1CompanyPrefix.00003.1234",
        "eventTime": "2023-04-01T16:00:00Z",
        "eventTimeZoneOffset": "+00:00",
        "readPoint": {"id": "urn:epc:id:sgln:$gs1CompanyPrefix.07346.1234"},
        "bizLocation": {"id": "urn:epc:id:sgln:$gs1CompanyPrefix.07346.1234"},
        // "quantityList": [
        //   {
        //     "epcClass": "urn:epc:class:sgtin:$gs1CompanyPrefix.00001.*",
        //     "quantity": 1,
        //     "uom": "EA"
        //   }
        // ],
        "gs1CompanyPrefix": "$gs1CompanyPrefix",
        "longitude": "-122.4194",
        "latitude": "37.7749"
      };
    }

    // add createdBy
    payload['createdBy'] = memberId.toString();

    log("EPCIS Body: ${jsonEncode(payload)}");

    var response =
        await http.post(url, headers: headers, body: jsonEncode(payload));

    log("EPCIS Response: ${response.body}");
    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(result['message'] ??
          result['error'] ??
          'Failed to insert EPCIS event');
      // return false;
    }
  }
}
