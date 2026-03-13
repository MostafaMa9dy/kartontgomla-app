// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorReviewField _$VendorReviewFieldFromJson(Map<String, dynamic> json) =>
    VendorReviewField(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      input: json['input'] as String,
      description: json['description'] as String,
      hidden: json['hidden'] as bool? ?? false,
      value: json['value'],
      context: json['context'] as String,
      items: VendorReviewField._fromItems(json['items']),
    );

Map<String, dynamic> _$VendorReviewFieldToJson(VendorReviewField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'input': instance.input,
      'description': instance.description,
      'value': instance.value,
      'hidden': instance.hidden,
      'items': VendorReviewField._toItems(instance.items),
      'context': instance.context,
    };

VendorReviewFieldItem _$VendorReviewFieldItemFromJson(
        Map<String, dynamic> json) =>
    VendorReviewFieldItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      value: (json['value'] as num).toInt(),
      defaultValue: (json['default'] as num).toInt(),
      input: json['input'] as String,
      type: json['type'] as String,
      context: json['context'] as String,
    );

Map<String, dynamic> _$VendorReviewFieldItemToJson(
        VendorReviewFieldItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'value': instance.value,
      'default': instance.defaultValue,
      'input': instance.input,
      'type': instance.type,
      'context': instance.context,
    };
