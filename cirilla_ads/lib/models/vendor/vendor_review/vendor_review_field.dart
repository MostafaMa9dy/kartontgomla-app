import 'package:json_annotation/json_annotation.dart';

part 'vendor_review_field.g.dart';

@JsonSerializable()
class VendorReviewField{
  final String id;

  final String name;

  final String type;

  final String input;

  final String description;

  final dynamic value;

  @JsonKey(defaultValue: false)
  final bool hidden;

  @JsonKey(fromJson: _fromItems, toJson: _toItems)
  final List<VendorReviewFieldItem>? items;

  final String context;

  VendorReviewField({
    required this.id,
    required this.name,
    required this.type,
    required this.input,
    required this.description,
    required this.hidden,
    required this.value,
    required this.context,
    this.items,
  });

  factory VendorReviewField.fromJson(Map<String, dynamic> json) => _$VendorReviewFieldFromJson(json);

  Map<String, dynamic> toJson() => _$VendorReviewFieldToJson(this);

  static List<VendorReviewFieldItem>? _fromItems(dynamic value) {
    if (value is List) {
      return value.map((item) => VendorReviewFieldItem.fromJson(item as Map<String, dynamic>)).toList();
    }

    return null;
  }

  static dynamic _toItems(List<VendorReviewFieldItem>? data) {
    return data?.map((item) => item.toJson());
  }
}

@JsonSerializable()
class VendorReviewFieldItem {
  final int id;

  final String name;

  final String description;

  final int value;

  @JsonKey(name: "default")
  final int defaultValue;

  final String input;

  final String type;

  final String context;

  VendorReviewFieldItem({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.defaultValue,
    required this.input,
    required this.type,
    required this.context,
  });

  factory VendorReviewFieldItem.fromJson(Map<String, dynamic> json) => _$VendorReviewFieldItemFromJson(json);

  Map<String, dynamic> toJson() => _$VendorReviewFieldItemToJson(this);
}