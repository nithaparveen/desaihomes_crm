// To parse this JSON data, do
//
//     final whatsappToLeadListModel = whatsappToLeadListModelFromJson(jsonString);

import 'dart:convert';

List<WhatsappToLeadListModel> whatsappToLeadListModelFromJson(String str) => List<WhatsappToLeadListModel>.from(json.decode(str).map((x) => WhatsappToLeadListModel.fromJson(x)));

String whatsappToLeadListModelToJson(List<WhatsappToLeadListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WhatsappToLeadListModel {
    int? id;
    String? name;
    String? phoneNumber;

    WhatsappToLeadListModel({
        this.id,
        this.name,
        this.phoneNumber,
    });

    factory WhatsappToLeadListModel.fromJson(Map<String, dynamic> json) => WhatsappToLeadListModel(
        id: json["id"],
        name: json["name"],
        phoneNumber: json["phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone_number": phoneNumber,
    };
}
