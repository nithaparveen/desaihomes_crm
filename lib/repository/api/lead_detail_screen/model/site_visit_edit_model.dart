// To parse this JSON data, do
//
//     final siteVisitEditModel = siteVisitEditModelFromJson(jsonString);

import 'dart:convert';

SiteVisitEditModel siteVisitEditModelFromJson(String str) => SiteVisitEditModel.fromJson(json.decode(str));

String siteVisitEditModelToJson(SiteVisitEditModel data) => json.encode(data.toJson());

class SiteVisitEditModel {
  Data? data;
  bool? status;

  SiteVisitEditModel({
    this.data,
    this.status,
  });

  factory SiteVisitEditModel.fromJson(Map<String, dynamic> json) => SiteVisitEditModel(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "status": status,
  };
}

class Data {
  int? id;
  int? leadId;
  DateTime? siteVisitDate;
  String? siteVisitRemarks;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.leadId,
    this.siteVisitDate,
    this.siteVisitRemarks,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    leadId: json["lead_id"],
    siteVisitDate: json["site_visit_date"] == null ? null : DateTime.parse(json["site_visit_date"]),
    siteVisitRemarks: json["site_visit_remarks"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lead_id": leadId,
    "site_visit_date": "${siteVisitDate!.year.toString().padLeft(4, '0')}-${siteVisitDate!.month.toString().padLeft(2, '0')}-${siteVisitDate!.day.toString().padLeft(2, '0')}",
    "site_visit_remarks": siteVisitRemarks,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
