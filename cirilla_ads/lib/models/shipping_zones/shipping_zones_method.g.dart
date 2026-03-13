// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_zones_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingZonesMethod _$ShippingZonesMethodFromJson(Map<String, dynamic> json) =>
    ShippingZonesMethod(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      instanceId: (json['instance_id'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
      methodId: json['method_id'] as String?,
      methodTitle: json['method_title'] as String?,
      methodDescription: json['method_description'] as String?,
      enabled: json['enabled'] as bool?,
      settings: ShippingZonesMethod._settingsFromJson(json['settings']),
    );

Map<String, dynamic> _$ShippingZonesMethodToJson(
        ShippingZonesMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instance_id': instance.instanceId,
      'title': instance.title,
      'order': instance.order,
      'enabled': instance.enabled,
      'method_id': instance.methodId,
      'method_title': instance.methodTitle,
      'method_description': instance.methodDescription,
      'settings': instance.settings,
    };

ShippingSetting _$ShippingSettingFromJson(Map<String, dynamic> json) =>
    ShippingSetting(
      id: json['id'] as String?,
      label: json['label'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      value: json['value'] as String?,
      defaultValue: json['defaultValue'] as String?,
      tip: json['tip'] as String?,
      placeholder: json['placeholder'] as String?,
      options: (json['options'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ShippingSettingToJson(ShippingSetting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'description': instance.description,
      'type': instance.type,
      'value': instance.value,
      'defaultValue': instance.defaultValue,
      'tip': instance.tip,
      'placeholder': instance.placeholder,
      'options': instance.options,
    };
