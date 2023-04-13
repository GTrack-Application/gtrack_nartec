import 'dart:convert';

import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/gln_model.dart';
import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/job_details_model.dart';
import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/job_order_details_model.dart';
import 'package:http/http.dart' as http;

class DispatchManagementServices {
  static Future<List<JobOrderDetailsModel>> getJobOrderDetails(
      String jobOrder) async {
    try {
      final response = await http.get(
          Uri.parse('http://gs1ksa.org:9000/api/getJobOrderDetails/$jobOrder'));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List;
        return responseBody
            .map((e) => JobOrderDetailsModel.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load Job Order Details');
      }
    } catch (e) {
      throw Exception('Failed to load Job Order Details');
    }
  }

  static Future<List<GlnModel>> getGlnByMemberId(String memberId) async {
    try {
      final response = await http
          .get(Uri.parse('http://gs1ksa.org:9000/api/getGlinIdByMemberId/386'));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List;
        return responseBody.map((e) => GlnModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Data not found for this member id');
      } else {
        throw Exception('Failed to load Job Order Details');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<JobDetailsModel>> getJobDetailsByReferenceNo(
      String refNo) async {
    try {
      final response = await http.get(Uri.parse(
          'http://gs1ksa.org:9000/api/getJobOrderDetailsByItemRefNo/$refNo'));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List;
        return responseBody.map((e) => JobDetailsModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('Data not found for this reference number');
      } else {
        throw Exception('Data not found for this reference number');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> postTable({
    String? batch,
    String? serial,
    String? gpc,
    String? qty,
  }) async {
    const String url = "http://gs1ksa.org:9000/api/postTblGLNTagIDEvents";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            // "TrxTypeId": "1",
            // "MemberID": "100",
            // "TrxRefNo": "ABC123",
            // "TrxRefDescription": "Sample description",
            // "TrxEventId": "EVT001",
            // "TrxDateCreated": "2023-04-11T00:00:00",
            // "TrxDateLastUpdate": "2023-04-11T00:00:00",
            // "TrxGLNCodeDocId": "GLN001",
            // "TrxGLNIDFrom": "GLNFROM",
            // "TrxGLNIDTo": "GLNTO",
            // "ItemRefNo": "ITEM001",
            // "ItemRefLinkInfo": "LINKINFO",
            // "ItemGPSOnGoLat": 37.7749,
            // "ItemGPSOnGoLon": -122.4194,
            // "Expiry": "2024-04-11",
            // "ManufacturingDate": "2022-04-11",
            "Batch": "$batch",
            "Serial": "$serial",
            "Quantity": "$qty"
          }));
      if (response.statusCode == 201) {
        final body = json.decode(response.body);
        final String message = body['message'];
        return message;
      } else {
        throw Exception('Failed to insert data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
