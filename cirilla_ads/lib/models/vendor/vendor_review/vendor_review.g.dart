// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorReview _$VendorReviewFromJson(Map<String, dynamic> json) => VendorReview(
      id: toInt(json['ID']),
      vendorId: json['vendor_id'] == null ? 0 : toInt(json['vendor_id']),
      authorId: json['author_id'] == null ? '' : toStr(json['author_id']),
      authorName: json['author_name'] as String? ?? '',
      authorEmail: json['author_email'] as String? ?? '',
      approved: json['approved'] == null ? '' : toStr(json['approved']),
      created: json['created'] == null ? '' : toStr(json['created']),
      reviewDescription: json['review_description'] as String? ?? '',
      reviewRating: json['review_rating'] as String? ?? '5',
      meta: VendorReview._fromListMeta(json['meta'] as List?),
    );

Map<String, dynamic> _$VendorReviewToJson(VendorReview instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'vendor_id': instance.vendorId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_email': instance.authorEmail,
      'review_description': instance.reviewDescription,
      'review_rating': instance.reviewRating,
      'approved': instance.approved,
      'created': instance.created,
      'meta': VendorReview._toListMeta(instance.meta),
    };

VendorReviewMeta _$VendorReviewMetaFromJson(Map<String, dynamic> json) =>
    VendorReviewMeta(
      id: toInt(json['id']),
      name: json['name'] == null ? '' : toStr(json['name']),
      description:
          json['description'] == null ? '' : toStr(json['description']),
      value: json['value'],
      defaultValue: json['default'],
      input: json['input'] == null ? '' : toStr(json['input']),
      type: json['type'] == null ? '' : toStr(json['type']),
      context: json['context'] == null ? '' : toStr(json['context']),
    );

Map<String, dynamic> _$VendorReviewMetaToJson(VendorReviewMeta instance) =>
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
