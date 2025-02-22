// ignore_for_file: unused_catch_clause

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtrack_nartec/constants/app_preferences.dart';
import 'package:gtrack_nartec/constants/app_urls.dart';
import 'package:http/http.dart' as http;

import 'logs_service.dart';

enum HttpMethod { get, post, put, delete, patch }

class HttpService {
  final String _baseUrl;
  final LogsService _logger = LogsService();

  HttpService({String? baseUrl})
      : _baseUrl = baseUrl ?? AppUrls.baseUrlWith7010;

  Future<Map<String, String>> _getHeaders() async {
    final accessToken = await AppPreferences.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };
  }

  Future<Response> request(
    String endpoint, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    BuildContext? context,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final requestHeaders = headers ?? await _getHeaders();
    final stopwatch = Stopwatch()..start();

    try {
      _logger.logRequest(
          url.toString(), method.toString(), requestHeaders, data);

      final response = await _performRequest(url, method,
          headers: requestHeaders, body: data);
      stopwatch.stop();
      _logger.logResponse(response, stopwatch.elapsed);

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return Response(
          body: response.body,
          statusCode: response.statusCode,
          headers: response.headers,
          success: true,
        );
      } else {
        throw HttpException(
          message: responseData['message'] ??
              responseData['error'] ??
              'Something went wrong',
          statusCode: response.statusCode,
          response: response.body,
          success: false,
        );
      }
    } on HttpException catch (e) {
      rethrow;
    } catch (e) {
      _logger.logError('Request failed: $url\nError: $e');
      throw HttpException(
        message: 'Something went wrong',
        statusCode: 500,
        response: e.toString(),
        success: false,
      );
    }
  }

  Future<http.Response> _performRequest(
    Uri url,
    HttpMethod method, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    switch (method) {
      case HttpMethod.get:
        return await http.get(url, headers: headers);
      case HttpMethod.post:
        return await http.post(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case HttpMethod.put:
        return await http.put(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
      case HttpMethod.delete:
        return await http.delete(url, headers: headers);
      case HttpMethod.patch:
        return await http.patch(
          url,
          headers: headers,
          body: body != null ? json.encode(body) : null,
        );
    }
  }
}

class Response {
  final String body;
  final int statusCode;
  final Map<String, String> headers;
  final bool success;

  Response({
    required this.body,
    required this.statusCode,
    required this.headers,
    this.success = false,
  });

  dynamic get data => json.decode(body);
  String get message =>
      data['message'] ?? data['error'] ?? 'Something went wrong';
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  final dynamic response;
  final bool? success;

  HttpException({
    required this.message,
    required this.statusCode,
    required this.response,
    this.success = false,
  });

  @override
  String toString() => message;
}
