// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatusDto _$UserStatusDtoFromJson(Map<String, dynamic> json) =>
    UserStatusDto(
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => UserStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserStatusDtoToJson(UserStatusDto instance) =>
    <String, dynamic>{'users': instance.users};

UserStatus _$UserStatusFromJson(Map<String, dynamic> json) => UserStatus(
  userId: (json['user_id'] as num?)?.toInt(),
  username: json['username'] as String?,
  displayName: json['display_name'] as String?,
  isOnline: json['is_online'] as bool?,
  lastSeen: json['last_seen'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'is_online': instance.isOnline,
      'last_seen': instance.lastSeen,
      'avatar_url': instance.avatarUrl,
    };
