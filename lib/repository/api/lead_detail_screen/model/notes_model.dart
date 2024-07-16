// To parse this JSON data, do
//
//     final notesModel = notesModelFromJson(jsonString);

import 'dart:convert';

NotesModel notesModelFromJson(String str) => NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
  List<Datum>? data;
  String? leadId;
  bool? status;

  NotesModel({
    this.data,
    this.leadId,
    this.status,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    leadId: json["lead_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "lead_id": leadId,
    "status": status,
  };
}

class Datum {
  int? id;
  String? notes;
  DateTime? noteDate;
  int? leadId;
  int? createdBy;
  DateTime? createdAt;
  CreatedUser? createdUser;

  Datum({
    this.id,
    this.notes,
    this.noteDate,
    this.leadId,
    this.createdBy,
    this.createdAt,
    this.createdUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    notes: json["notes"],
    noteDate: json["note_date"] == null ? null : DateTime.parse(json["note_date"]),
    leadId: json["lead_id"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    createdUser: json["created_user"] == null ? null : CreatedUser.fromJson(json["created_user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "notes": notes,
    "note_date": "${noteDate!.year.toString().padLeft(4, '0')}-${noteDate!.month.toString().padLeft(2, '0')}-${noteDate!.day.toString().padLeft(2, '0')}",
    "lead_id": leadId,
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
  dynamic managerId;
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
