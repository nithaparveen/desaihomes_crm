// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromJson(jsonString);

import 'dart:convert';

List<ConversationModel> conversationModelFromJson(String str) => List<ConversationModel>.from(json.decode(str).map((x) => ConversationModel.fromJson(x)));

String conversationModelToJson(List<ConversationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConversationModel {
    int? leadId;
    String? leadName;
    String? message;
    String? msgType;
    DateTime? createdAt;
    String? phoneNumber;

    ConversationModel({
        this.leadId,
        this.leadName,
        this.message,
        this.msgType,
        this.createdAt,
        this.phoneNumber,
    });

    factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
        leadId: json["lead_id"],
        leadName: json["lead_name"],
        message: json["message"],
        msgType: json["msg_type"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        phoneNumber: json["phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "lead_id": leadId,
        "lead_name": leadName,
        "message": message,
        "msg_type": msgType,
        "created_at": createdAt?.toIso8601String(),
        "phone_number": phoneNumber,
    };
}
