// ignore_for_file: avoid_print, non_constant_identifier_names, file_names, unused_local_variable

import 'dart:developer';

import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/palletization/GetControlledSerialBySerialNoModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeneratePalletController {
  static Future<List<GetControlledSerialBySerialNoModel>> generatePallet(
    String serialNo,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);

    String url =
        "${AppUrls.baseUrlWith7010}/api/getControlledSerialBySerialNo?serialNo=$serialNo";
    final uri = Uri.parse(url);

    final headers = <String, String>{
      // "Authorization": tokenNew!,

      "Accept": "application/json",
    };

    try {
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body)["data"] as List;
        print("Status Code: ${response.statusCode}");
        print(response.body);
        List<GetControlledSerialBySerialNoModel> controlledSerials = data
            .map((e) => GetControlledSerialBySerialNoModel.fromJson(e))
            .toList();
        return controlledSerials;
      } else {
        var data = json.decode(response.body);
        String message = data["message"];
        throw Exception(message);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  // insert pallet
  static Future<void> insertPallet(
    String gtin,
    int noOfBoxes,
    int qtyPerBox,
    List<String> serialNo,
  ) async {
    String? userId;
    await AppPreferences.getUserId().then((value) => userId = value);

    String url = "${AppUrls.baseUrlWith7010}/api/insertPalletData";
    final uri = Uri.parse(url);

    log(uri.toString());

    final headers = <String, String>{
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "gtin": gtin,
      "user_id": userId,
      "no_of_boxes": noOfBoxes,
      "qty_per_box": qtyPerBox,
      "serial_numbers": serialNo
    });

    log(body);

    try {
      var response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = json.decode(response.body);
        String message = data["message"];
      } else {
        var data = json.decode(response.body);
        String message = data["message"];
        throw Exception(message);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
