// To parse this JSON data, do
//
//     final leadSourceModel = leadSourceModelFromJson(jsonString);

import 'dart:convert';

LeadSourceModel leadSourceModelFromJson(String str) => LeadSourceModel.fromJson(json.decode(str));

String leadSourceModelToJson(LeadSourceModel data) => json.encode(data.toJson());

class LeadSourceModel {
    List<Datum>? data;
    String? message;
    bool? status;

    LeadSourceModel({
        this.data,
        this.message,
        this.status,
    });

    factory LeadSourceModel.fromJson(Map<String, dynamic> json) => LeadSourceModel(
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Datum {
    String? source;

    Datum({
        this.source,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        source: json["source"],
    );

    Map<String, dynamic> toJson() => {
        "source": source,
    };
}
