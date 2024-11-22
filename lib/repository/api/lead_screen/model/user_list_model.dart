// To parse this JSON data, do
//
//     final userListModel = userListModelFromJson(jsonString);

import 'dart:convert';

UserListModel userListModelFromJson(String str) => UserListModel.fromJson(json.decode(str));

String userListModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  List<User>? users;
  bool? status;

  UserListModel({
    this.users,
    this.status,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
    users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    "status": status,
  };
}

class User {
  String? name;
  int? id;
  String? email;

  User({
    this.name,
    this.id,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "email": email,
  };
}
