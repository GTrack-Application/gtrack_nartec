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
  }) async {
    // String? token;
    // await AppPreferences.getToken().then((value) => token = value.toString());

    final url = Uri.parse('${AppUrls.baseUrlWith7010}/api/insertEPCISEvent');

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
      "type": type,
      "action": action,
      "bizStep": bizStep,
      "disposition": disposition,
      "eventTime": eventTime,
      "eventTimeZoneOffset": eventTimeZoneOffSet,
      "epcList": ["urn:epc:id:sgtin:6285561.CV-100G SS220 PG.2268"],
      "readPoint": {"id": "urn:epc:id:sgln:6285561000063"},
      "bizLocation": {"id": "urn:epc:id:sgln:6285561000063"},
      "bizTransactionList": [
        {
          "type": "po",
          "bizTransaction":
              "http://transaction.acme.com/jo/cm6t2unxh0004eg3qjjt8m276"
        }
      ],
      "creationDate": createDate
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(body));

    log(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
