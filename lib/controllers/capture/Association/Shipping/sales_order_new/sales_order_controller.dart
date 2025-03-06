// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/map_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sales_order_model.dart';
import 'package:gtrack_nartec/models/capture/Association/Receiving/sales_order/sub_sales_order_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';

final _logger = Logger();

class SalesOrderController {
  static Future<List<SalesOrderModel>> getSalesOrder() async {
    final subUser = await AppPreferences.getUserId();
    final token = await AppPreferences.getToken();

    final url =
        '${AppUrls.baseUrlWith7010}/api/salesInvoice/master?subUser_id=$subUser';

    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => SalesOrderModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  static Future<List<SubSalesOrderModel>> getSubSalesOrder(
      String salesOrderId) async {
    final token = await AppPreferences.getToken();

    final url =
        '${AppUrls.baseUrlWith7010}/api/salesInvoice/details/getSalesInvoiceDetails?salesInvoiceId=$salesOrderId&association=true';

    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body)['data'] as List;
      return data.map((e) => SubSalesOrderModel.fromJson(e)).toList();
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  static Future<List<MapModel>> getMapModel(String customerId) async {
    final token = await AppPreferences.getToken();

    final url = '${AppUrls.baseUrlWith7010}/api/member?id=$customerId';

    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body) as List;
      return data.map((e) => MapModel.fromJson(e)).toList();
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            "Something went wrong",
      );
    }
  }

  static Future<void> statusUpdate(String id, Map<String, dynamic> body) async {
    final token = await AppPreferences.getToken();

    final url = '${AppUrls.baseUrlWith7010}/api/salesInvoice/master/$id';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        jsonDecode(response.body)['message'] ??
            jsonDecode(response.body)['error'] ??
            "Something went wrong",
      );
    }
  }

  /// Uploads images to the server. If an image exceeds 5 MB, it is resized before uploading.
  static Future<String> uploadImage(File images, String id) async {
    var url = Uri.parse(
        "${AppUrls.baseUrlWith7010}/api/salesInvoice/addSalesInvoiceSignature/$id");

    final token = await AppPreferences.getToken();

    // headers
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', url);

    File resizedImage = images;

    _logger.d('Adding image: ${resizedImage.path}');

    var mimeType = getMediaType(resizedImage.path);

    var multipartFile = await http.MultipartFile.fromPath(
      'signature',
      resizedImage.path,
      contentType: mimeType,
      filename: 'signature.png',
    );

    request.files.add(multipartFile);

    request.headers.addAll(headers);

    var response = await request.send();

    var responseBody = await http.Response.fromStream(response);

    _logger.d('Response status code: ${response.statusCode}');
    _logger.d('Response body: ${responseBody.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Image uploaded successfully';
    } else {
      var msg = jsonDecode(responseBody.body);
      throw Exception(
          msg['message'] ?? msg['error'] ?? 'Failed to upload image');
    }
  }

  static Future<void> uploadImages(
      List<File> images, String id, String salesInvoiceId) async {
    final token = await AppPreferences.getToken();

    final url =
        '${AppUrls.baseUrlWith7010}/api/salesInvoice/addSalesInvoiceDetailImages/$id/$salesInvoiceId';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);

    // Add each image to the request
    for (var image in images) {
      try {
        var mimeType = getMediaType(image.path);

        _logger.d('Adding image: ${image.path}');

        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: mimeType,
        );

        request.files.add(multipartFile);
      } catch (e) {
        _logger.e('Error processing image: ${image.path}', error: e);
        throw Exception("Failed to process image. Please try again.");
      }
    }
    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    _logger.d('Response status code: ${response.statusCode}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      var msg = jsonDecode(responseBody.body);
      throw Exception(
          msg['message'] ?? msg['error'] ?? 'Failed to upload images');
    }
  }

  /// Helper function to get MIME type from file extension
  static MediaType getMediaType(String path) {
    final mimeType = lookupMimeType(path);
    if (mimeType != null) {
      final parts = mimeType.split('/');
      if (parts.length == 2) {
        return MediaType(parts[0], parts[1]);
      }
    }
    return MediaType('application', 'octet-stream');
  }
}
