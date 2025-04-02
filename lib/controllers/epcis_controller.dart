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

    final body = {
      "type": type,
      "action": action,
      "bizStep": bizStep,
      "disposition": disposition,
      "eventTime": eventTime,
      "eventTimeZoneOffset": eventTimeZoneOffSet,
      "epcList": epcList ?? ["urn:epc:id:sgtin:6285561.CV-100G SS220 PG.2268"],
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
}
