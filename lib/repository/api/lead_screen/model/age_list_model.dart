// To parse this JSON data, do
//
//     final ageListModel = ageListModelFromJson(jsonString);

import 'dart:convert';

List<AgeListModel> ageListModelFromJson(String str) => List<AgeListModel>.from(json.decode(str).map((x) => AgeListModel.fromJson(x)));

String ageListModelToJson(List<AgeListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

AgeListModel ageListModelsFromJson(String str) => AgeListModel.fromJson(json.decode(str));

String ageListModelsToJson(AgeListModel data) => json.encode(data.toJson());

class AgeListModel {
    String? name;
    String? id;

    AgeListModel({
        this.name,
        this.id,
    });

    factory AgeListModel.fromJson(Map<String, dynamic> json) => AgeListModel(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
