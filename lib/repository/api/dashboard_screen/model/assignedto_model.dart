// To parse this JSON data, do
//
//     final assignedtoModel = assignedtoModelFromJson(jsonString);

import 'dart:convert';

AssignedtoModel assignedtoModelFromJson(String str) => AssignedtoModel.fromJson(json.decode(str));

String assignedtoModelToJson(AssignedtoModel data) => json.encode(data.toJson());

class AssignedtoModel {
  String? message;
  bool? status;

  AssignedtoModel({
    this.message,
    this.status,
  });

  factory AssignedtoModel.fromJson(Map<String, dynamic> json) => AssignedtoModel(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}
