// To parse this JSON data, do
//
//     final labelModel = labelModelFromJson(jsonString);

import 'dart:convert';

LabelModel labelModelFromJson(String str) => LabelModel.fromJson(json.decode(str));

String labelModelToJson(LabelModel data) => json.encode(data.toJson());

class LabelModel {
    List<Datum>? data;
    bool? status;

    LabelModel({
        this.data,
        this.status,
    });

    factory LabelModel.fromJson(Map<String, dynamic> json) => LabelModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
    };
}

class Datum {
    int? id;
    String? title;
    String? bgColor;
    String? textColor;
    int? isPrivate;
    int? createdBy;
    DateTime? createdAt;
    CreatedUser? createdUser;

    Datum({
        this.id,
        this.title,
        this.bgColor,
        this.textColor,
        this.isPrivate,
        this.createdBy,
        this.createdAt,
        this.createdUser,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        bgColor: json["bg_color"],
        textColor: json["text_color"],
        isPrivate: json["is_private"],
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        createdUser: json["created_user"] == null ? null : CreatedUser.fromJson(json["created_user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "bg_color": bgColor,
        "text_color": textColor,
        "is_private": isPrivate,
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "created_user": createdUser?.toJson(),
    };
}

class CreatedUser {
    int? id;
    String? name;
    String? email;
    String? userType;
    int? managerId;
    dynamic emailVerifiedAt;
    int? status;
    int? createdBy;
    int? updatedBy;
    DateTime? createdAt;
    DateTime? updatedAt;

    CreatedUser({
        this.id,
        this.name,
        this.email,
        this.userType,
        this.managerId,
        this.emailVerifiedAt,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
    });

    factory CreatedUser.fromJson(Map<String, dynamic> json) => CreatedUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        userType: json["user_type"],
        managerId: json["manager_id"],
        emailVerifiedAt: json["email_verified_at"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "user_type": userType,
        "manager_id": managerId,
        "email_verified_at": emailVerifiedAt,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
