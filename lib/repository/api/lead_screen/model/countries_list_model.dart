// To parse this JSON data, do
//
//     final countriesListModel = countriesListModelFromJson(jsonString);

import 'dart:convert';

List<CountriesListModel> countriesListModelFromJson(String str) => List<CountriesListModel>.from(json.decode(str).map((x) => CountriesListModel.fromJson(x)));

String countriesListModelToJson(List<CountriesListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

CountriesListModel countriesListModelsFromJson(String str) => CountriesListModel.fromJson(json.decode(str));

String countriesListModelsToJson(CountriesListModel data) => json.encode(data.toJson());

class CountriesListModel {
    int? id;
    String? code;
    String? name;

    CountriesListModel({
        this.id,
        this.code,
        this.name,
    });

    factory CountriesListModel.fromJson(Map<String, dynamic> json) => CountriesListModel(
        id: json["id"],
        code: json["code"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
    };
}
