import 'dart:convert';
import 'package:flutter/foundation.dart';

class FriendRequestModel {
  final String name;
  final String avatar;

  FriendRequestModel({
    required this.name,
    required this.avatar,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      name: json['username'] ?? 'Unknown User',
      avatar: json['avatarIcon'] ?? "👾",
    );
  }
}