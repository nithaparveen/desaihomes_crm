// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
    String? name;
    String? messageType; // Change from 'type' to 'messageType'
    String? message;
    String? messageId;
    DateTime? createdAt;

    ChatModel({
        this.name,
        this.messageType, // Update here
        this.message,
        this.messageId,
        this.createdAt,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        name: json["name"],
        messageType: json["messageType"], // Update here
        message: json["message"],
        messageId: json["message_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "messageType": messageType, // Update here
        "message": message,
        "message_id": messageId,
        "created_at": createdAt?.toIso8601String(),
    };
}