import 'package:json_annotation/json_annotation.dart';

part 'shipping_zones.g.dart';

@JsonSerializable()
class ShippingZones{
  final int? id;
  final String? name;
  final int? order;

  ShippingZones({
    this.id,
    this.name,
    this.order,
  });

  factory ShippingZones.fromJson(Map<String, dynamic> json) => _$ShippingZonesFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingZonesToJson(this);
}