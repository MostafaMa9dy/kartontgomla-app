import 'package:json_annotation/json_annotation.dart';

part 'media.g.dart';

@JsonSerializable(explicitToJson: true)
class MediaModel {
  final int? id;
  final String? date;
  @JsonKey(name: 'date_gmt')
  final String? dateGmt;
  final MediaGuid? guid;
  final String? modified;
  @JsonKey(name: 'modified_gmt')
  final String? modifiedGmt;
  final String? slug;
  final String? status;
  final String? type;
  final String? link;
  final MediaTitle? title;
  final int? author;
  @JsonKey(name: 'featured_media')
  final int? featuredMedia;
  @JsonKey(name: 'comment_status')
  final String? commentStatus;
  @JsonKey(name: 'ping_status')
  final String? pingStatus;
  final String? template;
  @JsonKey(fromJson: _metaFromJson)
  final MediaMeta? meta;
  @JsonKey(name: 'class_list')
  final List<String>? classList;
  final MediaDescription? description;
  final MediaCaption? caption;
  @JsonKey(name: 'alt_text')
  final String? altText;
  @JsonKey(name: 'media_type')
  final String? mediaType;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  @JsonKey(name: 'media_details')
  final MediaDetails? mediaDetails;
  final dynamic post;
  @JsonKey(name: 'source_url')
  final String? sourceUrl;
  @JsonKey(name: '_links')
  final MediaLinks? links;

  MediaModel({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.template,
    this.meta,
    this.classList,
    this.description,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.post,
    this.sourceUrl,
    this.links,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) => _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  static MediaMeta? _metaFromJson(dynamic json) {
    if (json == null || json is List) {
      return null;
    }
    if (json is Map<String, dynamic>) {
      return MediaMeta.fromJson(json);
    }
    return null;
  }
}

@JsonSerializable()
class MediaGuid {
  final String? rendered;

  MediaGuid({this.rendered});

  factory MediaGuid.fromJson(Map<String, dynamic> json) => _$MediaGuidFromJson(json);

  Map<String, dynamic> toJson() => _$MediaGuidToJson(this);
}

@JsonSerializable()
class MediaTitle {
  final String? rendered;

  MediaTitle({this.rendered});

  factory MediaTitle.fromJson(Map<String, dynamic> json) => _$MediaTitleFromJson(json);

  Map<String, dynamic> toJson() => _$MediaTitleToJson(this);
}

@JsonSerializable()
class MediaMeta {
  @JsonKey(name: '_acf_changed')
  final bool? acfChanged;

  MediaMeta({this.acfChanged});

  factory MediaMeta.fromJson(Map<String, dynamic> json) => _$MediaMetaFromJson(json);

  Map<String, dynamic> toJson() => _$MediaMetaToJson(this);
}

@JsonSerializable()
class MediaDescription {
  final String? rendered;

  MediaDescription({this.rendered});

  factory MediaDescription.fromJson(Map<String, dynamic> json) => _$MediaDescriptionFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDescriptionToJson(this);
}

@JsonSerializable()
class MediaCaption {
  final String? rendered;

  MediaCaption({this.rendered});

  factory MediaCaption.fromJson(Map<String, dynamic> json) => _$MediaCaptionFromJson(json);

  Map<String, dynamic> toJson() => _$MediaCaptionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class MediaDetails {
  final int? width;
  final int? height;
  final String? file;
  final int? filesize;
  final Map<String, MediaSize>? sizes;
  @JsonKey(name: 'image_meta')
  final ImageMeta? imageMeta;
  @JsonKey(name: 'original_image')
  final String? originalImage;

  MediaDetails({
    this.width,
    this.height,
    this.file,
    this.filesize,
    this.sizes,
    this.imageMeta,
    this.originalImage,
  });

  factory MediaDetails.fromJson(Map<String, dynamic> json) => _$MediaDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDetailsToJson(this);
}

@JsonSerializable()
class MediaSize {
  final String? file;
  final int? width;
  final int? height;
  final int? filesize;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  @JsonKey(name: 'source_url')
  final String? sourceUrl;
  final bool? uncropped;

  MediaSize({
    this.file,
    this.width,
    this.height,
    this.filesize,
    this.mimeType,
    this.sourceUrl,
    this.uncropped,
  });

  factory MediaSize.fromJson(Map<String, dynamic> json) => _$MediaSizeFromJson(json);

  Map<String, dynamic> toJson() => _$MediaSizeToJson(this);
}

@JsonSerializable()
class ImageMeta {
  final String? aperture;
  final String? credit;
  final String? camera;
  final String? caption;
  @JsonKey(name: 'created_timestamp', fromJson: _stringFromDynamic)
  final String? createdTimestamp;
  final String? copyright;
  @JsonKey(name: 'focal_length')
  final String? focalLength;
  final String? iso;
  @JsonKey(name: 'shutter_speed')
  final String? shutterSpeed;
  final String? title;
  @JsonKey(fromJson: _intFromDynamic)
  final int? orientation;
  final List<dynamic>? keywords;

  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  factory ImageMeta.fromJson(Map<String, dynamic> json) => _$ImageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ImageMetaToJson(this);

  static String? _stringFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString();
    return null;
  }

  static int? _intFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}

@JsonSerializable(explicitToJson: true)
class MediaLinks {
  final List<MediaLink>? self;
  final List<MediaLink>? collection;
  final List<MediaLink>? about;
  final List<MediaLinkAuthor>? author;
  final List<MediaLinkReplies>? replies;

  MediaLinks({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
  });

  factory MediaLinks.fromJson(Map<String, dynamic> json) => _$MediaLinksFromJson(json);

  Map<String, dynamic> toJson() => _$MediaLinksToJson(this);
}

@JsonSerializable()
class MediaLink {
  final String? href;
  final MediaTargetHints? targetHints;

  MediaLink({this.href, this.targetHints});

  factory MediaLink.fromJson(Map<String, dynamic> json) => _$MediaLinkFromJson(json);

  Map<String, dynamic> toJson() => _$MediaLinkToJson(this);
}

@JsonSerializable()
class MediaTargetHints {
  final List<String>? allow;

  MediaTargetHints({this.allow});

  factory MediaTargetHints.fromJson(Map<String, dynamic> json) => _$MediaTargetHintsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaTargetHintsToJson(this);
}

@JsonSerializable()
class MediaLinkAuthor {
  final bool? embeddable;
  final String? href;

  MediaLinkAuthor({this.embeddable, this.href});

  factory MediaLinkAuthor.fromJson(Map<String, dynamic> json) => _$MediaLinkAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$MediaLinkAuthorToJson(this);
}

@JsonSerializable()
class MediaLinkReplies {
  final bool? embeddable;
  final String? href;

  MediaLinkReplies({this.embeddable, this.href});

  factory MediaLinkReplies.fromJson(Map<String, dynamic> json) => _$MediaLinkRepliesFromJson(json);

  Map<String, dynamic> toJson() => _$MediaLinkRepliesToJson(this);
}