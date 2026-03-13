// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_zones.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingZones _$ShippingZonesFromJson(Map<String, dynamic> json) =>
    ShippingZones(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShippingZonesToJson(ShippingZones instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
    };
