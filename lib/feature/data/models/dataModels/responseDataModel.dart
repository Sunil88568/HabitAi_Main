

import '../../../../core/error.dart';

class ResponseData<T> {
  T? data;
  Exception? error;
  Exception? exception;
  Failure? failure;
  String? message;
  int? statusCode;

  ResponseData({
    this.data,
    this.error,
    this.exception,
    this.failure,
    this.message,
    this.statusCode,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;

  // Exception? get getError => failure ?? exception ?? error;
  String get getError => message ?? 'Unknown error';


  factory ResponseData.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return ResponseData<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'] is String ? Exception(json['error']) : null,
      exception: json['exception'] is String ? Exception(json['exception']) : null,
      failure: json['failure'] != null ? Failure.fromJson(json['failure']) : null,
      message: json['message'] as String?,
      statusCode: json['statusCode'] is int ? json['statusCode'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': isSuccess,
      'data': data,
      'error': error?.toString(),
      'exception': exception?.toString(),
      'message': message,
      'statusCode': statusCode,
    };
  }
}
