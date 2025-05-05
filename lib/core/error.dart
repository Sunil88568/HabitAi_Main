import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  const Failure();

  static fromJson(json) {}
}

// General failures
class ServerFailure extends Failure implements Exception{
  final String error;

  const ServerFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class InternetFailure extends Failure{
  final String error;
  const InternetFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class CacheFailure extends Failure implements Exception{
  @override
  List<Object?> get props => [];
}

class ErrorFailure extends Failure implements Exception{
  final String error;

  const ErrorFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class FormValidationFailure extends Failure implements Exception{
  final String? error;
  const FormValidationFailure({this.error});
  @override
  List<Object?> get props => [];
}