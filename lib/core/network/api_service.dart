import "dart:convert";
import "dart:developer";

import "package:http/http.dart" as http;

class ApiService {
  static const String basesUrl = "https://devapi.slatexpos.com";

  static Future<dynamic> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = Uri.parse('$basesUrl$endpoint');

      final defaultHeaders = {"Content-Type": "application/json", ...?headers};

      final response = await http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode(body),
      );

      return jsonDecode(response.body);
    } catch (e) {
      log("API Error: $e");
      rethrow;
    }
  }
}
