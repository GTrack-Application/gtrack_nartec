// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/brands_name_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/gpc_by_search_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/gpc_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/origin_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/package_type_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/product_description_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/product_type_model.dart';
import 'package:gtrack_mobile_app/models/IDENTIFY/GTIN/unit_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

class AddGtinController {
  static Future<List<BrandsNameModel>> fetchBrandsName() async {
    String? userId = await AppPreferences.getUserId();
    String? token = await AppPreferences.getToken();

    final url =
        Uri.parse('${AppUrls.baseUrlWith3093}/api/brands?user_id=$userId');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => BrandsNameModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<UnitModel>> fetchUnit() async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}/api/getAllunit');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => UnitModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<OriginModel>> fetchOrigin() async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}/api/getAllcountryofsale');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => OriginModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<ProductDescriptionModel>>
      fetchProductDescLanguage() async {
    String? token = await AppPreferences.getToken();

    final url =
        Uri.parse('${AppUrls.baseUrlWith3093}/api/getAllprod_desc_languages');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data
          .map((item) => ProductDescriptionModel.fromJson(item))
          .toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<ProductTypeModel>> fetchProductType() async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}/api/productTypes');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => ProductTypeModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<PackageTypeModel>> fetchPackageType() async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse('${AppUrls.baseUrlWith3093}/api/getAllproductPackag');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => PackageTypeModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<GPCModel>> fetchGpc(String productNameEng) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse(
        '${AppUrls.baseUrlWith4044}api/findSimilarRecords?text=$productNameEng&tableName=gpc_bricks');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => GPCModel.fromJson(item[0])).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<GPCBySearchModel>> fetchGPCBySearch(String search) async {
    String? token = await AppPreferences.getToken();

    final url =
        Uri.parse('${AppUrls.baseUrlWith3093}api/gpc/search?term=$search');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((item) => GPCBySearchModel.fromJson(item)).toList();
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<List<dynamic>> fetchHsCode(String gpc) async {
    String? token = await AppPreferences.getToken();

    final url = Uri.parse(
        '${AppUrls.baseUrlWith4044}api/findSimilarRecords?text=$gpc&tableName=hs_codes');

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);

      List<dynamic> fetchedNames = data.map((item) {
        return item[0]['metadata']
            ['الصنف باللغة الانجليزية \r\n Item English Name'];
      }).toList();

      return fetchedNames;
    } else {
      var data = jsonDecode(response.body);
      var msg = data['message'];
      throw Exception(msg);
    }
  }

  static Future<void> postProduct(
    String productnameenglish,
    String productnamearabic,
    String BrandName,
    String ProductType,
    String Origin,
    String PackagingType,
    String unit,
    String size,
    String gpc,
    String gpc_type,
    String gpc_code,
    String countrySale,
    String HsDescription,
    String HSCODES,
    String details_page,
    String details_page_ar,
    String product_url,
    String BrandNameAr,
    String product_type,
    File? front_image,
    File? back_image,
    List<File?> optionalImages,
  ) async {
    try {
      String? id = await AppPreferences.getUserId();
      String? gln = await AppPreferences.getGln();
      String? gcp_type = await AppPreferences.getGcpType();
      String? token = await AppPreferences.getToken();

      final url = Uri.parse('${AppUrls.baseUrlWith3091}api/products');
      print('URL: $url');

      final request = http.MultipartRequest('POST', url);

      // Bearer token
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Host': 'gs1ksa.org:3091',
      });

      // Adding fields
      request.fields['user_id'] = id ?? '';
      request.fields['productnameenglish'] = productnameenglish;
      request.fields['productnamearabic'] = productnamearabic;
      request.fields['BrandName'] = BrandName;
      request.fields['ProductType'] = ProductType;
      request.fields['Origin'] = Origin;
      request.fields['PackagingType'] = PackagingType;
      request.fields['ProvGLN'] = gln ?? '';
      request.fields['unit'] = unit;
      request.fields['size'] = size;
      request.fields['gpc'] = gpc;
      request.fields['gpc_type'] = gpc_type;
      request.fields['gpc_code'] = gpc_code;
      request.fields['countrySale'] = countrySale;
      request.fields['HSCODES'] = HSCODES;
      request.fields['HsDescription'] = HsDescription;
      request.fields['gcp_type'] = gcp_type ?? "GCP";
      request.fields['prod_lang'] = "en";
      request.fields['details_page'] = details_page;
      request.fields['details_page_ar'] = details_page_ar;
      request.fields['memberID'] = id ?? '';
      request.fields['product_url'] = product_url;
      request.fields['BrandNameAr'] = BrandNameAr;
      request.fields['product_type'] = "finished_goods";

      // Helper function to get MIME type from file extension
      MediaType? getMediaType(String path) {
        final mimeType = lookupMimeType(path);
        if (mimeType != null) {
          final parts = mimeType.split('/');
          if (parts.length == 2) {
            return MediaType(parts[0], parts[1]);
          }
        }
        return MediaType('application', 'octet-stream');
      }

      // Adding images
      if (front_image != null) {
        print('Adding front image: ${front_image.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'front_image',
            front_image.path,
            filename: front_image.path.split('/').last,
            contentType: getMediaType(front_image.path),
          ),
        );
      }

      if (back_image != null) {
        print('Adding back image: ${back_image.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'back_image',
            back_image.path,
            filename: back_image.path.split('/').last,
            contentType: getMediaType(back_image.path),
          ),
        );
      }

      for (var i = 0; i < optionalImages.length; i++) {
        if (optionalImages[i] != null) {
          print('Adding optional image $i: ${optionalImages[i]!.path}');
          request.files.add(
            await http.MultipartFile.fromPath(
              'image_${i + 1}',
              optionalImages[i]!.path,
              filename: optionalImages[i]!.path.split('/').last,
              contentType: getMediaType(optionalImages[i]!.path),
            ),
          );
        }
      }

      final response = await request.send();
      final responseStr = await response.stream.bytesToString();

      print(responseStr);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Product added successfully');
      } else {
        var data = jsonDecode(responseStr);
        var msg = data['message'];
        throw Exception('Failed to add product: $msg');
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
}
