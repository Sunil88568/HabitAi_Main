import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

/// For decoding from JSON string
QuestionModel questionModelFromJson(String str) =>
    QuestionModel.fromJson(json.decode(str));

/// For encoding to JSON string
String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

@freezed
class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    @JsonKey(name: "_id") String? id,
    String? question,
    List<String>? options,
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(name: "__v") int? v,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}
