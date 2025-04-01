import 'dart:convert';
import 'dart:developer';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/assembling_bundling/BundleItemsModel.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/assembling_bundling/products_model.dart';
import 'package:gtrack_nartec/features/capture/models/aggregation/packing/PackedItemsModel.dart';
import 'package:http/http.dart' as http;

class AssemblingController {
  static Future<List<ProductsModel>> getAssemblingsByUserAndBarcode(
      String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7010}/api/getAssemblingsByUserAndBarcode?user_id=$userId&field=$gtin";

    final uri = Uri.parse(url);

    print(uri);

    final headers = <String, String>{
      "Content-Type": "application/json",

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
        "${AppUrls.baseUrlWith7010}/api/getAssemblingsByUserAndBarcode?user_id=$userId&field=$gtin";

    print(url);

    final uri = Uri.parse(url);

    print(userId);

    final headers = <String, String>{
      "Content-Type": "application/json",

      // "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<ProductsModel> products =
          data.map((e) => ProductsModel.fromJson(e)).toList();
      return products;
    } else {
      var msg = jsonDecode(response.body)['error'];
      throw Exception(msg);
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

    const url = "${AppUrls.baseUrlWith7010}/api/createnewbundling";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",

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

  static Future<void> createAssemble(
    List<String> field,
    String glnLocation,
    String name,
  ) async {
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";
    String? userId = await AppPreferences.getUserId();

    const url = "${AppUrls.baseUrlWith7010}/api/createnewassembling";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",

      // "Authorization": "Bearer $token",
    };

    jsonEncode(field);

    final body = jsonEncode({
      "user_id": userId,
      "field": field,
      "location": glnLocation,
      "assembling_name": name
    });

    var response = await http.post(uri, body: body, headers: headers);

    var data = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error']);
    }
  }

  static Future<List<PackedItemsModel>> getPackedItems() async {
    String? token = await AppPreferences.getToken();
    // String? userId = await AppPreferences.getUserId();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url = "${AppUrls.baseUrlWith7010}/api/getAllPackedItems";

    final uri = Uri.parse(url);

    // log(uri.toString());

    final headers = <String, String>{
      "Authorization": "Bearer $token",
    };

    var response = await http.get(uri, headers: headers);

    // print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = json.decode(response.body) as List;
      List<PackedItemsModel> products =
          data.map((e) => PackedItemsModel.fromJson(e)).toList();
      return products;
    } else {
      var msg = "No Packed Items Found for This Location";
      throw Exception(msg);
    }
  }

  // get bundling by userid
  static Future<List<ProductsModel>> getBundlingByUserId() async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7010}/api/getBundlingByUserId?user_id=$userId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",

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
        "${AppUrls.baseUrlWith7010}/api/getadd_bundlingByuser_id?user_id=$userId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
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

  static Future<List<AssembleItemsModel>> getAssembleItems() async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7010}/api/getadd_assemblingByuser_id?user_id=$userId";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
    };

    var response = await http.get(uri, headers: headers);

    log(jsonDecode(response.body).toString());

    var data = json.decode(response.body) as List;

    if (response.statusCode == 200) {
      List<AssembleItemsModel> products =
          data.map((e) => AssembleItemsModel.fromJson(e)).toList();
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
        "${AppUrls.baseUrlWith7010}/api/getBundlingByUserId?user_id=$userId&GTIN=$gtin";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
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

  static Future<List<ProductsModel>> getSubAssembleItems(String gtin) async {
    String? userId = await AppPreferences.getUserId();
    // String? token = await AppPreferences.getToken();
    // String url = "${AppUrls.baseUrlWith3091}api/products";

    final url =
        "${AppUrls.baseUrlWith7010}/api/get_assembling_By_UserId_list?user_id=$userId&GTIN=$gtin";

    final uri = Uri.parse(url);

    final headers = <String, String>{
      "Content-Type": "application/json",
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
