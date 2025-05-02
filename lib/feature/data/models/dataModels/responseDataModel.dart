import '../../../../core/error.dart';

class ResponseData<T> {
  bool isSuccess;
  T? data;
  Exception? error;
  Exception? exception;
  Failure? failure;
  String? message;

  ResponseData({
    this.isSuccess = false,
    this.data,
    this.error,
    this.exception,
    this.failure,
    this.message,  // Include message in constructor
  });

  Exception? get getError => this.failure ?? this.exception ?? this.error;

  factory ResponseData.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ResponseData<T>(
      isSuccess: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] is String ? Exception(json['error']) : null,
      exception: json['exception'] is String ? Exception(json['exception']) : null,
      message: json['message'],  // Extract message from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'data': data is Map<String, dynamic> ? data : data?.toString(),
      'error': error?.toString(),
      'exception': exception?.toString(),
      'message': message,
      // 'failure': failure?.toJson(),
    };
  }
}
