class ApiAuthResponse<T> {
  final String status;
  final String message;
  final T? result;
  final bool isSuccess;

  ApiAuthResponse({required this.status, required this.message, this.result})
    : isSuccess = status == "1";

  factory ApiAuthResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    return ApiAuthResponse<T>(
      status: json['STATUS'] ?? "0",
      message: json['MESSAGE'] ?? "",
      result: json['RESULT'] != null && fromJsonT != null
          ? fromJsonT(json["RESULT"])
          : null,
    );
  }

  factory ApiAuthResponse.success(T result, {String message = "Success"}) {
    return ApiAuthResponse(status: "1", message: message, result: result);
  }

  factory ApiAuthResponse.error(String message, {String status = "0"}) {
    return ApiAuthResponse(status: status, message: message, result: null);
  }

  @override
  String toString() {
    return 'ApiAuthResponse(status: $status, message: $message, isSuccess: $isSuccess, result:$result)';
  }
}
