// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtrack_mobile_app/constants/app_preferences.dart';
import 'package:gtrack_mobile_app/constants/app_urls.dart';
import 'package:gtrack_mobile_app/models/Member/member_data_model.dart';
import 'package:gtrack_mobile_app/models/activities/email_activities_model.dart';
import 'package:http/http.dart' as http;

class LoginServices {
  static Future<void> confirmation(
    BuildContext context,
    String email,
    String activity,
    String activityId,
    String password,
    String generatedOTP,
    String memberOtp,
  ) async {
    MemberDataModel member = MemberDataModel();
    const baseUrl = '${AppUrls.baseUrl}/api/otp/confirmation';
    final uri = Uri.parse(baseUrl);
    return http.post(
      uri,
      body: json.encode(
        {
          // body should include email
          'email': email,
          'activity': activity,
          'activityID': activityId,
          'password': password,
          'generated_otp': generatedOTP,
          'member_otp': memberOtp,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Host': 'gs1ksa.org',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // Setting preferences
        final data = json.decode(response.body);
        member = MemberDataModel.fromJson(data['memberData']);

        AppPreferences.setUserId(member.user!.id.toString()).then((_) {});
        AppPreferences.setGcp(member.user!.gcpGLNID.toString()).then((_) {});
        AppPreferences.setMemberCategoryDescription(
                member.memberCategory!.memberCategoryDescription.toString())
            .then((_) {});
      } else {
        throw Exception('Invalid OTP, Please try again');
      }
    }).onError(
      (error, stackTrace) => throw Exception(
        'Invalid OTP, Please try again',
      ),
    );
  }

  static Future<Map<String, dynamic>> sendOTP(String email, String activity) {
    const baseUrl = '${AppUrls.baseUrl}/api/send/otp';
    final uri = Uri.parse(baseUrl);
    return http.post(
      uri,
      body: json.encode(
        {
          'email': email,
          'activity': activity,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Host': 'gs1ksa.org',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IklyZmFuIiwiaWF0IjoxNTE2MjM5MDIyfQ.vx1SEIP27zyDm9NoNbJRrKo-r6kRaVHNagsMVTToU6A',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        return responseBody;
      } else {
        throw Exception('Error happended while sending OTP');
      }
    });
  }

  static Future<Map<String, dynamic>> loginWithPassword(
    String email,
    String activity,
    String password,
    String activityId,
  ) {
    const baseUrl = '${AppUrls.baseUrl}/api/member/login';
    final uri = Uri.parse(baseUrl);
    return http.post(
      uri,
      body: json.encode(
        {
          // body should include email
          'email': email,
          'activity': activity,
          'activityID': activityId,
          'password': password,
        },
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Host': 'gs1ksa.org',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // handle successful response
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        return responseBody;
      } else if (response.statusCode == 422) {
        throw Exception('Please Wait For Admin Approval');
      } else {
        throw Exception('Error happended while logging in');
      }
    });
  }

  static Future<List<EmailActivitiesModel>> login({String? email}) async {
    const baseUrl = '${AppUrls.baseUrl}/api/email/verification';

    final uri = Uri.parse(baseUrl);
    try {
      final response =
          await http.post(uri, body: json.encode({'email': email}), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Host': AppUrls.host,
      });

      if (response.statusCode == 200) {
        // handle successful response
        final responseBody = json.decode(response.body);
        final data = responseBody['activities'] as List;
        final List<EmailActivitiesModel> emailActivities = [];
        for (final item in data) {
          emailActivities.add(EmailActivitiesModel.fromJson(item));
        }
        return emailActivities;
      } else if (response.statusCode == 404) {
        // print('responseBody: ${json.decode(response.body)}');

        // return {
        //   "message": "Email doesn't exist",
        // };
        throw Exception('Email doesn\'t exist');
      } else {
        // print('responseBody: ${json.decode(response.body)}');

        // handle error response
        throw Exception('Error happended while loading data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> normalUserLogin(String email, String pass) async {
    const baseUrl = '${AppUrls.baseUrlWithPort}loginUser';
    final uri = Uri.parse(baseUrl);

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Host': AppUrls.host,
    };

    final body = jsonEncode(
      {
        'Email': email,
        'UserPassword': pass,
      },
    );

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        print("Status Code: ${response.statusCode}");
        final responseBody = json.decode(response.body);
        print("responseBody: $responseBody");
      } else {
        print("Status Code: ${response.statusCode}");
        var data = json.decode(response.body);
        String msg = data['message'];
        throw Exception(msg);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
