import 'dart:convert';
import 'dart:developer';
import "package:http/http.dart" as http;
import 'package:slate_x_reports/core/models/api_response.dart';

class ApiService {
  static const String basesUrl = "https://devapi.slatexpos.com";

  //* Generic method to handle all API calls
  static Future<ApiAuthResponse<T>> post<T>(
    String endpoint, {
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$basesUrl$endpoint');

      final defaultHeaders = {'Content-Type': 'application/json', ...?headers};

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiAuthResponse.fromJson(data, fromJson);
      } else {
        return ApiAuthResponse.error(
          'HTTP Error: ${response.statusCode}',
          status: response.statusCode.toString(),
        );
      }
    } catch (e) {
      log("API Error: $e");
      return ApiAuthResponse.error(
        'Network Error: ${e.toString()}',
        status: "0",
      );
    }
  }

  static Future<ApiAuthResponse<T>> get<T>(
    String endpoint, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      var url = Uri.parse('$basesUrl$endpoint');

      if (queryParameters != null && queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }

      final defaultHeaders = {'Content-Type': 'application/json', ...?headers};

      final response = await http.get(url, headers: defaultHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ApiAuthResponse.fromJson(data, fromJson);
      } else {
        return ApiAuthResponse.error(
          'HTTP Error: ${response.statusCode}',
          status: response.statusCode.toString(),
        );
      }
    } catch (e) {
      log("API Error: $e");
      return ApiAuthResponse.error(
        'Network Error: ${e.toString()}',
        status: "0",
      );
    }
  }
}
