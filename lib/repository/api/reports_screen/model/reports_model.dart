// To parse this JSON data, do
//
//     final reportsModel = reportsModelFromJson(jsonString);

import 'dart:convert';

ReportsModel reportsModelFromJson(String str) => ReportsModel.fromJson(json.decode(str));

String reportsModelToJson(ReportsModel data) => json.encode(data.toJson());

class ReportsModel {
    Data? data;
    bool? status;

    ReportsModel({
        this.data,
        this.status,
    });

    factory ReportsModel.fromJson(Map<String, dynamic> json) => ReportsModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "status": status,
    };
}

class Data {
    int? totalLeads;
    List<StatusLeadDatum>? statusLeadData;

    Data({
        this.totalLeads,
        this.statusLeadData,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalLeads: json["total_leads"],
        statusLeadData: json["status_lead_data"] == null ? [] : List<StatusLeadDatum>.from(json["status_lead_data"]!.map((x) => StatusLeadDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "total_leads": totalLeads,
        "status_lead_data": statusLeadData == null ? [] : List<dynamic>.from(statusLeadData!.map((x) => x.toJson())),
    };
}

class StatusLeadDatum {
    String? statusName;
    int? leadCount;

    StatusLeadDatum({
        this.statusName,
        this.leadCount,
    });

    factory StatusLeadDatum.fromJson(Map<String, dynamic> json) => StatusLeadDatum(
        statusName: json["status_name"],
        leadCount: json["lead_count"],
    );

    Map<String, dynamic> toJson() => {
        "status_name": statusName,
        "lead_count": leadCount,
    };
}
