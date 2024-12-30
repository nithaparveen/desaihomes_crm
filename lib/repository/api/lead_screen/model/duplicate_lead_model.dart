// To parse this JSON data, do
//
//     final duplicateLeadModel = duplicateLeadModelFromJson(jsonString);

import 'dart:convert';

List<DuplicateLeadModel> duplicateLeadModelFromJson(String str) => List<DuplicateLeadModel>.from(json.decode(str).map((x) => DuplicateLeadModel.fromJson(x)));

String duplicateLeadModelToJson(List<DuplicateLeadModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DuplicateLeadModel {
    Field? field;
    String? project;
    String? assignedTo;
    DateTime? logDate;
    OgLead? ogLead;

    DuplicateLeadModel({
        this.field,
        this.project,
        this.assignedTo,
        this.logDate,
        this.ogLead,
    });

    factory DuplicateLeadModel.fromJson(Map<String, dynamic> json) => DuplicateLeadModel(
        field: json["field"] == null ? null : Field.fromJson(json["field"]),
        project: json["project"],
        assignedTo: json["assigned_to"],
        logDate: json["log_date"] == null ? null : DateTime.parse(json["log_date"]),
        ogLead: json["og_lead"] == null ? null : OgLead.fromJson(json["og_lead"]),
    );

    Map<String, dynamic> toJson() => {
        "field": field?.toJson(),
        "project": project,
        "assigned_to": assignedTo,
        "log_date": logDate?.toIso8601String(),
        "og_lead": ogLead?.toJson(),
    };
}

class Field {
    String? email;
    String? phoneNumber;

    Field({
        this.email,
        this.phoneNumber,
    });

    factory Field.fromJson(Map<String, dynamic> json) => Field(
        email: json["email"],
        phoneNumber: json["phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "phone_number": phoneNumber,
    };
}

class OgLead {
    int? id;
    String? project;
    String? assignedTo;
    DateTime? createdAt;

    OgLead({
        this.id,
        this.project,
        this.assignedTo,
        this.createdAt,
    });

    factory OgLead.fromJson(Map<String, dynamic> json) => OgLead(
        id: json["id"],
        project: json["project"],
        assignedTo: json["assigned_to"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "project": project,
        "assigned_to": assignedTo,
        "created_at": createdAt?.toIso8601String(),
    };
}
