import 'dart:convert';

import 'package:gtrack_mobile_app/domain/services/models/dispatch_management/gln_model.dart';
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
      final response = await http.get(Uri.parse(
          'http://gs1ksa.org:9000/api/getGlinIdByMemberId/$memberId'));
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List;
        return responseBody.map((e) => GlnModel.fromJson(e)).toList();
      } else if (response.statusCode == 404) {
        throw Exception('No GLN for this member ID found');
      } else {
        throw Exception('Failed to load Job Order Details');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
