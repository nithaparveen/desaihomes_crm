// To parse this JSON data, do
//
//     final campaignListModel = campaignListModelFromJson(jsonString);

import 'dart:convert';

CampaignListModel campaignListModelFromJson(String str) => CampaignListModel.fromJson(json.decode(str));

String campaignListModelToJson(CampaignListModel data) => json.encode(data.toJson());

class CampaignListModel {
    List<Datum>? data;
    bool? status;

    CampaignListModel({
        this.data,
        this.status,
    });

    factory CampaignListModel.fromJson(Map<String, dynamic> json) => CampaignListModel(
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
    String? name;

    Datum({
        this.id,
        this.name,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
