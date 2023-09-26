// ignore_for_file: file_names, depend_on_referenced_packages, avoid_print

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';


class InsertManyIntoMappedBarcodeController {
  static Future<void> getData(
    String itemCode,
    String name,
    String newBarcodeValue,
    String selectedValue,
    String mainLocation,
    String config,
    String user,
    String gtin,
    String remarks,
  ) async {
    String? tokenNew = await AppPreferences.getToken();


    String url = "${AppUrls.baseUrlWithPort}insertManyIntoMappedBarcode";
    print("url: $url");
    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": tokenNew!,
      "Host": AppUrls.host,
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    try {
      var response = await http.post(uri,
          headers: headers,
          body: jsonEncode({
            "records": [
              {
                "mainlocation": mainLocation,
                "classification": config,
                "itemdesc": name,
                // "itemcode": itemCode,
                "itemcode": "",
                "itemserialno": newBarcodeValue,
                "mapdate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
                "palletcode": "",
                "binlocation": selectedValue,
                "user": user,
                "gtin": gtin,
                "remarks": remarks,
                "reference": "",
                "sid": "",
                "cid": "",
                "po": ""
              }
            ]
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        var msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
