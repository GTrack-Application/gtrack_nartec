// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GenerateAndUpdatePalletIdController {
  static Future<List<dynamic>> generateAndUpdatePalletId(
    List<String> serialNoList,
    String dropdownValue,
  ) async {
    String? tokenNew;
    await AppPreferences.getToken().then((value) => tokenNew = value);
// convert list to one string
    String serialNoListString = serialNoList.join("&serialNumberList[]=");

    print(serialNoListString);

    String url =
        "${AppUrls.baseUrlWith7000}/api/generateAndUpdatePalletIds?serialNumberList[]=$serialNoListString&binLocation=$dropdownValue";

    print(url);

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");

        var data = json.decode(response.body);

        print("Data: $data");
        String message = data["message"];
        var PalletCode = data["PalletCode"];
        return [message, PalletCode];
      } else {
        var data = json.decode(response.body);
        print("Data: $data");
        String message = data["message"];

        throw Exception(message);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
