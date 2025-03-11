// To parse this JSON data, do
//
//     final leadTypeModel = leadTypeModelFromJson(jsonString);

import 'dart:convert';

LeadTypeModel leadTypeModelFromJson(String str) => LeadTypeModel.fromJson(json.decode(str));

String leadTypeModelToJson(LeadTypeModel data) => json.encode(data.toJson());

class LeadTypeModel {
    List<CrmLeadType>? crmLeadTypes;
    bool? status;

    LeadTypeModel({
        this.crmLeadTypes,
        this.status,
    });

    factory LeadTypeModel.fromJson(Map<String, dynamic> json) => LeadTypeModel(
        crmLeadTypes: json["crm_lead_types"] == null ? [] : List<CrmLeadType>.from(json["crm_lead_types"]!.map((x) => CrmLeadType.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "crm_lead_types": crmLeadTypes == null ? [] : List<dynamic>.from(crmLeadTypes!.map((x) => x.toJson())),
        "status": status,
    };
}

class CrmLeadType {
    int? id;
    String? name;

    CrmLeadType({
        this.id,
        this.name,
    });

    factory CrmLeadType.fromJson(Map<String, dynamic> json) => CrmLeadType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
