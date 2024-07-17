// To parse this JSON data, do
//
//     final siteVisitModel = siteVisitModelFromJson(jsonString);

import 'dart:convert';

SiteVisitModel siteVisitModelFromJson(String str) => SiteVisitModel.fromJson(json.decode(str));

String siteVisitModelToJson(SiteVisitModel data) => json.encode(data.toJson());

class SiteVisitModel {
  List<Datum>? data;
  bool? status;

  SiteVisitModel({
    this.data,
    this.status,
  });

  factory SiteVisitModel.fromJson(Map<String, dynamic> json) => SiteVisitModel(
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
  int? leadId;
  DateTime? siteVisitDate;
  String? siteVisitRemarks;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.leadId,
    this.siteVisitDate,
    this.siteVisitRemarks,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
