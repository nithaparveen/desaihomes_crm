// To parse this JSON data, do
//
//     final professionsListModel = professionsListModelFromJson(jsonString);

import 'dart:convert';

List<ProfessionsListModel> professionsListModelFromJson(String str) => List<ProfessionsListModel>.from(json.decode(str).map((x) => ProfessionsListModel.fromJson(x)));

String professionsListModelToJson(List<ProfessionsListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

ProfessionsListModel professionsListModelsFromJson(String str) => ProfessionsListModel.fromJson(json.decode(str));

String professionsListModelsToJson(ProfessionsListModel data) => json.encode(data.toJson());

class ProfessionsListModel {
    String? name;
    String? id;

    ProfessionsListModel({
        this.name,
        this.id,
    });

    factory ProfessionsListModel.fromJson(Map<String, dynamic> json) => ProfessionsListModel(
        name: json["name"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
    };
}
