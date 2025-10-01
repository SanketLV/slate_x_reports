import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:slate_x_reports/core/models/api_auth_response.dart';
import 'package:slate_x_reports/core/network/api_service.dart';
import 'package:slate_x_reports/features/auth/data/auth_service.dart';

class InvoiceService {
  final AuthService _authService = AuthService();

  Future<dynamic> fetchInvoiceReport({
    required DateTime startDate,
    required DateTime endDate,
    String orderType = "",
    String paymentMode = "",
    String paymentStatus = "",
    int branchId = 1,
    int start = 0,
    int length = 10,
    String value = "",
  }) async {
    final token = await _authService.getToken();

    // log("$token");

    if (token == null || token.isEmpty) {
      return ApiAuthResponse.error("No Authentication token found");
    }

    final df = DateFormat("yyyy-MM-dd");
    final body = {
      "start_date": df.format(startDate),
      "end_date": df.format(endDate),
      "order_type": (orderType).toString(),
      "payment_mode": (paymentMode).toString(),
      "payment_status": (paymentStatus).toString(),
      "start": start,
      "length": length,
      "search": {"value": value.trim().isEmpty ? "" : value.trim()},
      "search_data": {"branch_id": branchId},
    };

    log("InvoiceService - POST /InvoiceReport: $body");

    return ApiService.post(
      "/InvoiceReport",
      body: body,
      headers: {"Authorization": "Bearer $token"},
      // fromJson: (json) => json,
    );
  }
}
