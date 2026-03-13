import 'package:json_annotation/json_annotation.dart';

part 'shipping_zones_method.g.dart';

@JsonSerializable()
class ShippingZonesMethod {
  final int? id;

  @JsonKey(name: 'instance_id')
  final int? instanceId;

  final String? title;

  final int? order;

  final bool? enabled;

  @JsonKey(name: 'method_id')
  final String? methodId;

  @JsonKey(name: 'method_title')
  final String? methodTitle;

  @JsonKey(name: 'method_description')
  final String? methodDescription;

  @JsonKey(fromJson: _settingsFromJson)
  final Map<String, ShippingSetting>? settings;

  ShippingZonesMethod({
    this.id,
    this.title,
    this.instanceId,
    this.order,
    this.methodId,
    this.methodTitle,
    this.methodDescription,
    this.enabled,
    this.settings,
  });

  factory ShippingZonesMethod.fromJson(Map<String, dynamic> json) => _$ShippingZonesMethodFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingZonesMethodToJson(this);

  static Map<String, ShippingSetting>? _settingsFromJson(dynamic json) {
    if (json == null) return null;
    if (json is List) return {}; // Return empty map if settings is a list
    if (json is Map<String, dynamic>) {
      return json.map(
        (k, e) => MapEntry(k, ShippingSetting.fromJson(e as Map<String, dynamic>)),
      );
    }
    return null;
  }
}

@JsonSerializable()
class ShippingSetting {
  final String? id;
  final String? label;
  final String? description;
  final String? type;
  final String? value;
  final String? defaultValue;
  final String? tip;
  final String? placeholder;
  final Map<String, String>? options;

  ShippingSetting({
    this.id,
    this.label,
    this.description,
    this.type,
    this.value,
    this.defaultValue,
    this.tip,
    this.placeholder,
    this.options,
  });

  factory ShippingSetting.fromJson(Map<String, dynamic> json) => _$ShippingSettingFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingSettingToJson(this);
}