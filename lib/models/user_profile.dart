import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  static const ID_KEY = "uid";
  static const NAME_KEY = "name";
  static const EMAIL_KEY = "email";
  static const PICTURE_KEY = "picture";

  @JsonKey(name: ID_KEY)
  final String id;

  @JsonKey(name: NAME_KEY)
  final String name;

  @JsonKey(name: EMAIL_KEY)
  final String email;

  @JsonKey(name: PICTURE_KEY, nullable: true)
  final String picture;

  UserProfile({@required this.id, @required this.name, @required this.email, this.picture})
      : assert(id != null),
        assert(name != null),
        assert(email != null);

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
