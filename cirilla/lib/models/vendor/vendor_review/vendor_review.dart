import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/utils/data_format.dart' show toInt, toStr;

part 'vendor_review.g.dart';

@JsonSerializable()
class VendorReview {
  @JsonKey(name: 'ID', fromJson: toInt)
  final int id;

  @JsonKey(name: 'vendor_id', fromJson: toInt, defaultValue: 0)
  final int vendorId;

  @JsonKey(name: 'author_id', fromJson: toStr, defaultValue: '')
  final String authorId;

  @JsonKey(name: 'author_name', defaultValue: '')
  final String authorName;

  @JsonKey(name: 'author_email', defaultValue: '')
  final String authorEmail;

  @JsonKey(name: 'review_description', defaultValue: '')
  final String reviewDescription;

  @JsonKey(name: 'review_rating', defaultValue: '5')
  final String reviewRating;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String approved;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String created;

  @JsonKey(fromJson: _fromListMeta, toJson: _toListMeta)
  final List<VendorReviewMeta> meta;

  VendorReview({
    required this.id,
    required this.vendorId,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.approved,
    required this.created,
    required this.reviewDescription,
    required this.reviewRating,
    required this.meta,
  });

  factory VendorReview.fromJson(Map<String, dynamic> json) => _$VendorReviewFromJson(json);

  Map<String, dynamic> toJson() => _$VendorReviewToJson(this);

  static List<VendorReviewMeta> _fromListMeta(List<dynamic>? data) {
    List<VendorReviewMeta> newMeta = <VendorReviewMeta>[];

    if (data == null) return newMeta;

    newMeta = data.map((d) => VendorReviewMeta.fromJson(d)).toList().cast<VendorReviewMeta>();

    return newMeta;
  }

  static dynamic _toListMeta(List<VendorReviewMeta> data) {
    return data.map((d) => d.toJson()).toList();
  }
}

@JsonSerializable()
class VendorReviewMeta {
  @JsonKey(fromJson: toInt)
  final int id;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String name;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String description;

  final dynamic value;

  @JsonKey(name: 'default')
  final dynamic defaultValue;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String input;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String type;

  @JsonKey(fromJson: toStr, defaultValue: '')
  final String context;

  VendorReviewMeta({
    required this.id,
    required this.name,
    required this.description,
    required this.value,
    required this.defaultValue,
    required this.input,
    required this.type,
    required this.context,
  });

  factory VendorReviewMeta.fromJson(Map<String, dynamic> json) => _$VendorReviewMetaFromJson(json);

  Map<String, dynamic> toJson() => _$VendorReviewMetaToJson(this);
}
