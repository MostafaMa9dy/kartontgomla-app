import 'package:json_annotation/json_annotation.dart';
import 'package:cirilla/utils/data_format.dart' show toBool, toInt, toStr;

part 'upgrader.g.dart';

enum TimeUnit {
  minutes,
  hours,
  days,
  weeks,
  months,
}

@JsonSerializable()
class Upgrader {
  @JsonKey(fromJson: toBool, defaultValue: false)
  final bool status;

  @JsonKey(name: 'application_id', fromJson: toStr, defaultValue: '')
  final String applicationId;

  @JsonKey(name: 'bundle_id', fromJson: toStr, defaultValue: '')
  final String bundleId;

  @JsonKey(name: 'enable_auto_update', fromJson: toBool, defaultValue: false)
  final bool enableAutoUpdate;

  @JsonKey(name: 'auto_update_interval', fromJson: toInt, defaultValue: 60)
  final int autoUpdateInterval;

  @JsonKey(name: 'auto_update_interval_by', fromJson: _autoUpdateIntervalBy, defaultValue: TimeUnit.minutes)
  final TimeUnit autoUpdateIntervalBy;

  const Upgrader({
    required this.status,
    required this.applicationId,
    required this.bundleId,
    required this.enableAutoUpdate,
    required this.autoUpdateInterval,
    required this.autoUpdateIntervalBy,
  });

  static const defaultData = Upgrader(
    status: false,
    applicationId: '',
    bundleId: '',
    enableAutoUpdate: false,
    autoUpdateInterval: 60,
    autoUpdateIntervalBy: TimeUnit.minutes,
  );

  factory Upgrader.fromJson(Map<String, dynamic> json) => _$UpgraderFromJson(json);

  Map<String, dynamic> toJson() => _$UpgraderToJson(this);

  static TimeUnit _autoUpdateIntervalBy(dynamic value) {
    if (value is String) {
      switch (value) {
        case 'minutes':
          return TimeUnit.minutes;
        case 'hours':
          return TimeUnit.hours;
        case 'days':
          return TimeUnit.days;
        case 'weeks':
          return TimeUnit.weeks;
        case 'months':
          return TimeUnit.months;
        default:
          return TimeUnit.minutes;
      }
    }
    return TimeUnit.minutes;
  }
}
