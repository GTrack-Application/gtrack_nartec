// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/share/models/product_information/gtin_information_model.dart';
import 'package:http/http.dart' as http;

class GtinInformationController {
  static Future<dynamic> getGtinInformation(String gtin) async {
    final url = Uri.parse(
      "${AppUrls.baseUrlWith3093}api/foreignGtin/getGtinProductDetails?barcode=$gtin",
    );

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print(response.body);

      if (data['ProductDataAvailable'] == true) {
        return GtinInformationDataModel.fromJson(data);
      } else {
        return GtinInformationModel.fromJson(data);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
