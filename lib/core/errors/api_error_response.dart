class ApiErrorResponse {
  final bool success;
  final String message;
  final Map<String, List<String>> errors;

  const ApiErrorResponse({
    required this.success,
    required this.message,
    required this.errors,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? 'Unknown error',
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
            (errorKey, errorValue) =>
                MapEntry(errorKey, List<String>.from(errorValue)),
          ) ??
          {},
    );
  }
}
