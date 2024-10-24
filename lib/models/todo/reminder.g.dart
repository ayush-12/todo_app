// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderImpl _$$ReminderImplFromJson(Map<String, dynamic> json) =>
    _$ReminderImpl(
      enabled: json['enabled'] as bool? ?? false,
      reminderDate: const TimestampConverter()
          .fromJson(json['reminderDate'] as Timestamp?),
    );

Map<String, dynamic> _$$ReminderImplToJson(_$ReminderImpl instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'reminderDate': const TimestampConverter().toJson(instance.reminderDate),
    };
