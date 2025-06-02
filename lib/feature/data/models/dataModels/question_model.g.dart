// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionModelImpl _$$QuestionModelImplFromJson(Map<String, dynamic> json) =>
    _$QuestionModelImpl(
      id: json['_id'] as String?,
      question: json['question'] as String?,
      pricePoll: json['pricePoll'] as String?,
      count: (json['count'] as num?)?.toInt(),
      isSubmitted: json['isSubmitted'] as bool?,
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      v: (json['__v'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuestionModelImplToJson(_$QuestionModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'question': instance.question,
      'pricePoll': instance.pricePoll,
      'count': instance.count,
      'isSubmitted': instance.isSubmitted,
      'options': instance.options,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      '__v': instance.v,
    };
