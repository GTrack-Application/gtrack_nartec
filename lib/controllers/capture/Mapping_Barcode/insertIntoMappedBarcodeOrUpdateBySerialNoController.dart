// ignore_for_file: camel_case_types

import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class insertIntoMappedBarcodeOrUpdateBySerialNoController {
  static Future<void> insert(
    String itemId,
    String itemName,
    String reference,
    String gtin,
    String binlocation,
    String itemserialno,
    String cid,
    String qrCode,
    double length,
    double width,
    double height,
    double weight,
    String manufacturingDate,
  ) async {
    String url = "${AppUrls.base}insertIntoMappedBarcodeOrUpdateBySerialNo";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Authorization": AppUrls.token,
      "Host": AppUrls.host,
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    final body = {
      "itemcode": itemId,
      "itemdesc": itemName,
      "gtin": gtin,
      "binlocation": binlocation,
      "itemserialno": itemserialno,
      "reference": reference,
      "classification": cid,
      "qrcode": qrCode,
      "length": length,
      "width": width,
      "height": height,
      "weight": weight,
      "trxdate": manufacturingDate
    };

    print("Body: ${jsonEncode(body)}");

    try {
      var response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        print("Data: $data");
      } else {
        print("Status Code: ${response.statusCode}");
        throw Exception('Failed to insert data');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
