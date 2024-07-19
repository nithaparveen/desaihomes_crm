// To parse this JSON data, do
//
//     final statusListModel = statusListModelFromJson(jsonString);

import 'dart:convert';

StatusListModel statusListModelFromJson(String str) => StatusListModel.fromJson(json.decode(str));

String statusListModelToJson(StatusListModel data) => json.encode(data.toJson());

class StatusListModel {
  List<CrmStatus>? crmStatus;
  bool? status;

  StatusListModel({
    this.crmStatus,
    this.status,
  });

  factory StatusListModel.fromJson(Map<String, dynamic> json) => StatusListModel(
    crmStatus: json["crm_status"] == null ? [] : List<CrmStatus>.from(json["crm_status"]!.map((x) => CrmStatus.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "crm_status": crmStatus == null ? [] : List<dynamic>.from(crmStatus!.map((x) => x.toJson())),
    "status": status,
  };
}

class CrmStatus {
  int? id;
  String? name;
  String? slug;
  int? dispalyOrder;
  String? type;
  String? textColor;
  String? bgColor;
  int? status;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  CrmStatus({
    this.id,
    this.name,
    this.slug,
    this.dispalyOrder,
    this.type,
    this.textColor,
    this.bgColor,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CrmStatus.fromJson(Map<String, dynamic> json) => CrmStatus(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    dispalyOrder: json["dispaly_order"],
    type: json["type"],
    textColor: json["text_color"],
    bgColor: json["bg_color"],
    status: json["status"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "dispaly_order": dispalyOrder,
    "type": type,
    "text_color": textColor,
    "bg_color": bgColor,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
