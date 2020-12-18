// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    id: json['uid'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    picture: json['picture'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.id,
      'name': instance.name,
      'email': instance.email,
      'picture': instance.picture,
    };
