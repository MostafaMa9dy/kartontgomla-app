// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String?,
      dateGmt: json['date_gmt'] as String?,
      guid: json['guid'] == null
          ? null
          : MediaGuid.fromJson(json['guid'] as Map<String, dynamic>),
      modified: json['modified'] as String?,
      modifiedGmt: json['modified_gmt'] as String?,
      slug: json['slug'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
      link: json['link'] as String?,
      title: json['title'] == null
          ? null
          : MediaTitle.fromJson(json['title'] as Map<String, dynamic>),
      author: (json['author'] as num?)?.toInt(),
      featuredMedia: (json['featured_media'] as num?)?.toInt(),
      commentStatus: json['comment_status'] as String?,
      pingStatus: json['ping_status'] as String?,
      template: json['template'] as String?,
      meta: MediaModel._metaFromJson(json['meta']),
      classList: (json['class_list'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] == null
          ? null
          : MediaDescription.fromJson(
              json['description'] as Map<String, dynamic>),
      caption: json['caption'] == null
          ? null
          : MediaCaption.fromJson(json['caption'] as Map<String, dynamic>),
      altText: json['alt_text'] as String?,
      mediaType: json['media_type'] as String?,
      mimeType: json['mime_type'] as String?,
      mediaDetails: json['media_details'] == null
          ? null
          : MediaDetails.fromJson(
              json['media_details'] as Map<String, dynamic>),
      post: json['post'],
      sourceUrl: json['source_url'] as String?,
      links: json['_links'] == null
          ? null
          : MediaLinks.fromJson(json['_links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'date_gmt': instance.dateGmt,
      'guid': instance.guid?.toJson(),
      'modified': instance.modified,
      'modified_gmt': instance.modifiedGmt,
      'slug': instance.slug,
      'status': instance.status,
      'type': instance.type,
      'link': instance.link,
      'title': instance.title?.toJson(),
      'author': instance.author,
      'featured_media': instance.featuredMedia,
      'comment_status': instance.commentStatus,
      'ping_status': instance.pingStatus,
      'template': instance.template,
      'meta': instance.meta?.toJson(),
      'class_list': instance.classList,
      'description': instance.description?.toJson(),
      'caption': instance.caption?.toJson(),
      'alt_text': instance.altText,
      'media_type': instance.mediaType,
      'mime_type': instance.mimeType,
      'media_details': instance.mediaDetails?.toJson(),
      'post': instance.post,
      'source_url': instance.sourceUrl,
      '_links': instance.links?.toJson(),
    };

MediaGuid _$MediaGuidFromJson(Map<String, dynamic> json) => MediaGuid(
      rendered: json['rendered'] as String?,
    );

Map<String, dynamic> _$MediaGuidToJson(MediaGuid instance) => <String, dynamic>{
      'rendered': instance.rendered,
    };

MediaTitle _$MediaTitleFromJson(Map<String, dynamic> json) => MediaTitle(
      rendered: json['rendered'] as String?,
    );

Map<String, dynamic> _$MediaTitleToJson(MediaTitle instance) =>
    <String, dynamic>{
      'rendered': instance.rendered,
    };

MediaMeta _$MediaMetaFromJson(Map<String, dynamic> json) => MediaMeta(
      acfChanged: json['_acf_changed'] as bool?,
    );

Map<String, dynamic> _$MediaMetaToJson(MediaMeta instance) => <String, dynamic>{
      '_acf_changed': instance.acfChanged,
    };

MediaDescription _$MediaDescriptionFromJson(Map<String, dynamic> json) =>
    MediaDescription(
      rendered: json['rendered'] as String?,
    );

Map<String, dynamic> _$MediaDescriptionToJson(MediaDescription instance) =>
    <String, dynamic>{
      'rendered': instance.rendered,
    };

MediaCaption _$MediaCaptionFromJson(Map<String, dynamic> json) => MediaCaption(
      rendered: json['rendered'] as String?,
    );

Map<String, dynamic> _$MediaCaptionToJson(MediaCaption instance) =>
    <String, dynamic>{
      'rendered': instance.rendered,
    };

MediaDetails _$MediaDetailsFromJson(Map<String, dynamic> json) => MediaDetails(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      file: json['file'] as String?,
      filesize: (json['filesize'] as num?)?.toInt(),
      sizes: (json['sizes'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, MediaSize.fromJson(e as Map<String, dynamic>)),
      ),
      imageMeta: json['image_meta'] == null
          ? null
          : ImageMeta.fromJson(json['image_meta'] as Map<String, dynamic>),
      originalImage: json['original_image'] as String?,
    );

Map<String, dynamic> _$MediaDetailsToJson(MediaDetails instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'file': instance.file,
      'filesize': instance.filesize,
      'sizes': instance.sizes?.map((k, e) => MapEntry(k, e.toJson())),
      'image_meta': instance.imageMeta?.toJson(),
      'original_image': instance.originalImage,
    };

MediaSize _$MediaSizeFromJson(Map<String, dynamic> json) => MediaSize(
      file: json['file'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      filesize: (json['filesize'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
      sourceUrl: json['source_url'] as String?,
      uncropped: json['uncropped'] as bool?,
    );

Map<String, dynamic> _$MediaSizeToJson(MediaSize instance) => <String, dynamic>{
      'file': instance.file,
      'width': instance.width,
      'height': instance.height,
      'filesize': instance.filesize,
      'mime_type': instance.mimeType,
      'source_url': instance.sourceUrl,
      'uncropped': instance.uncropped,
    };

ImageMeta _$ImageMetaFromJson(Map<String, dynamic> json) => ImageMeta(
      aperture: json['aperture'] as String?,
      credit: json['credit'] as String?,
      camera: json['camera'] as String?,
      caption: json['caption'] as String?,
      createdTimestamp: ImageMeta._stringFromDynamic(json['created_timestamp']),
      copyright: json['copyright'] as String?,
      focalLength: json['focal_length'] as String?,
      iso: json['iso'] as String?,
      shutterSpeed: json['shutter_speed'] as String?,
      title: json['title'] as String?,
      orientation: ImageMeta._intFromDynamic(json['orientation']),
      keywords: json['keywords'] as List<dynamic>?,
    );

Map<String, dynamic> _$ImageMetaToJson(ImageMeta instance) => <String, dynamic>{
      'aperture': instance.aperture,
      'credit': instance.credit,
      'camera': instance.camera,
      'caption': instance.caption,
      'created_timestamp': instance.createdTimestamp,
      'copyright': instance.copyright,
      'focal_length': instance.focalLength,
      'iso': instance.iso,
      'shutter_speed': instance.shutterSpeed,
      'title': instance.title,
      'orientation': instance.orientation,
      'keywords': instance.keywords,
    };

MediaLinks _$MediaLinksFromJson(Map<String, dynamic> json) => MediaLinks(
      self: (json['self'] as List<dynamic>?)
          ?.map((e) => MediaLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      collection: (json['collection'] as List<dynamic>?)
          ?.map((e) => MediaLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      about: (json['about'] as List<dynamic>?)
          ?.map((e) => MediaLink.fromJson(e as Map<String, dynamic>))
          .toList(),
      author: (json['author'] as List<dynamic>?)
          ?.map((e) => MediaLinkAuthor.fromJson(e as Map<String, dynamic>))
          .toList(),
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => MediaLinkReplies.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaLinksToJson(MediaLinks instance) =>
    <String, dynamic>{
      'self': instance.self?.map((e) => e.toJson()).toList(),
      'collection': instance.collection?.map((e) => e.toJson()).toList(),
      'about': instance.about?.map((e) => e.toJson()).toList(),
      'author': instance.author?.map((e) => e.toJson()).toList(),
      'replies': instance.replies?.map((e) => e.toJson()).toList(),
    };

MediaLink _$MediaLinkFromJson(Map<String, dynamic> json) => MediaLink(
      href: json['href'] as String?,
      targetHints: json['targetHints'] == null
          ? null
          : MediaTargetHints.fromJson(
              json['targetHints'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MediaLinkToJson(MediaLink instance) => <String, dynamic>{
      'href': instance.href,
      'targetHints': instance.targetHints,
    };

MediaTargetHints _$MediaTargetHintsFromJson(Map<String, dynamic> json) =>
    MediaTargetHints(
      allow:
          (json['allow'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MediaTargetHintsToJson(MediaTargetHints instance) =>
    <String, dynamic>{
      'allow': instance.allow,
    };

MediaLinkAuthor _$MediaLinkAuthorFromJson(Map<String, dynamic> json) =>
    MediaLinkAuthor(
      embeddable: json['embeddable'] as bool?,
      href: json['href'] as String?,
    );

Map<String, dynamic> _$MediaLinkAuthorToJson(MediaLinkAuthor instance) =>
    <String, dynamic>{
      'embeddable': instance.embeddable,
      'href': instance.href,
    };

MediaLinkReplies _$MediaLinkRepliesFromJson(Map<String, dynamic> json) =>
    MediaLinkReplies(
      embeddable: json['embeddable'] as bool?,
      href: json['href'] as String?,
    );

Map<String, dynamic> _$MediaLinkRepliesToJson(MediaLinkReplies instance) =>
    <String, dynamic>{
      'embeddable': instance.embeddable,
      'href': instance.href,
    };
