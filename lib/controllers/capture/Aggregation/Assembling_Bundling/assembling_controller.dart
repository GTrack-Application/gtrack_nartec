import 'dart:convert';
import 'dart:developer';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/BundleItemsModel.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_mobile_app/models/capture/aggregation/packing/PackedItemsModel.dart';
import 'package:http/http.dart' as http;

class AssemblingController {
  static Future<List<ProductsModel>> getAssemblingsByUserAndBarcode(
      String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getAssemblingsByUserAndBarcode?user_id=$userId&field=$gtin";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<List<ProductsModel>> getBundlingByUserAndBarcode(
      String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getAssemblingsByUserAndBarcode?user_id=$userId&field=$gtin";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<void> createBundle(
    List<String> field,
    String glnLocation,
    String name,
  ) async {
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";
    String? userId = await AppPreferences.getUserId();

    const url = "${AppUrls.baseUrlWith7000}/api/createnewbundling";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    jsonEncode(field);

    final body = jsonEncode({
      "user_id": userId,
      "field": field,
      "location": glnLocation,
      "bundling_name": name
    });

    var response = await http.post(uri, body: body, headers: headers);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error']);
    }
  }

  static Future<List<PackedItemsModel>> getPackedItems(String gln) async {
    // String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url = "${AppUrls.baseUrlWith7000}/api/getPackedItemsByGLN?GLN=$gln";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<PackedItemsModel> products =
          data.map((e) => PackedItemsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }

  // get bundling by userid
  static Future<List<ProductsModel>> getBundlingByUserId() async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getBundlingByUserId?user_id=$userId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    log(jsonDecode(response.body).toString());

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<List<BundleItemsModel>> getBundleItems() async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getadd_bundlingByuser_id?user_id=$userId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var response = await http.get(uri, headers: headers);

    log(jsonDecode(response.body).toString());

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<BundleItemsModel> products =
          data.map((e) => BundleItemsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }

  static Future<List<ProductsModel>> getSubBundleItems(String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7000}/api/getBundlingByUserId?user_id=$userId&GTIN=$gtin";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Host": AppUrls.host,
    };

    var response = await http.get(uri, headers: headers);

    log(jsonDecode(response.body).toString());

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      return [];
    }
  }
}
