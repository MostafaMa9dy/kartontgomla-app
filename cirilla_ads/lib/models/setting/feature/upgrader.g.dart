// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upgrader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Upgrader _$UpgraderFromJson(Map<String, dynamic> json) => Upgrader(
      status: json['status'] == null ? false : toBool(json['status']),
      applicationId:
          json['application_id'] == null ? '' : toStr(json['application_id']),
      bundleId: json['bundle_id'] == null ? '' : toStr(json['bundle_id']),
      enableAutoUpdate: json['enable_auto_update'] == null
          ? false
          : toBool(json['enable_auto_update']),
      autoUpdateInterval: json['auto_update_interval'] == null
          ? 60
          : toInt(json['auto_update_interval']),
      autoUpdateIntervalBy: json['auto_update_interval_by'] == null
          ? TimeUnit.minutes
          : Upgrader._autoUpdateIntervalBy(json['auto_update_interval_by']),
    );

Map<String, dynamic> _$UpgraderToJson(Upgrader instance) => <String, dynamic>{
      'status': instance.status,
      'application_id': instance.applicationId,
      'bundle_id': instance.bundleId,
      'enable_auto_update': instance.enableAutoUpdate,
      'auto_update_interval': instance.autoUpdateInterval,
      'auto_update_interval_by':
          _$TimeUnitEnumMap[instance.autoUpdateIntervalBy]!,
    };

const _$TimeUnitEnumMap = {
  TimeUnit.minutes: 'minutes',
  TimeUnit.hours: 'hours',
  TimeUnit.days: 'days',
  TimeUnit.weeks: 'weeks',
  TimeUnit.months: 'months',
};
