import 'package:json_annotation/json_annotation.dart';

part 'user_status.g.dart';

@JsonSerializable()
class UserStatusDto {
  @JsonKey(name: "users")
  List<UserStatus>? users;

  UserStatusDto({this.users});

  factory UserStatusDto.fromJson(Map<String, dynamic> json) =>
      _$UserStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatusDtoToJson(this);
}

@JsonSerializable()
class UserStatus {
  @JsonKey(name: "user_id")
  int? userId;
  @JsonKey(name: "username")
  String? username;
  @JsonKey(name: "display_name")
  String? displayName;
  @JsonKey(name: "is_online")
  bool? isOnline;
  @JsonKey(name: "last_seen")
  String? lastSeen;
  @JsonKey(name: "avatar_url")
  String? avatarUrl;

  UserStatus({
    this.userId,
    this.username,
    this.displayName,
    this.isOnline,
    this.lastSeen,
    this.avatarUrl,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatusToJson(this);
}
