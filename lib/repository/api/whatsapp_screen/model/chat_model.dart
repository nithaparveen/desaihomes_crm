
import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) => List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatModel {
    String? name;
    String? messageType; 
    String? message;
    String? msgType;
    String? messageId;
    DateTime? createdAt;

    ChatModel({
        this.name,
        this.messageType,
        this.message,
        this.msgType,
        this.messageId,
        this.createdAt,
    });

    factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        name: json["name"],
        messageType: json["type"],
        message: json["message"],
        msgType: json["msg_type"],
        messageId: json["message_id"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "type": messageType,
        "message": message,
        "msg_type": msgType,
        "message_id": messageId,
        "created_at": createdAt?.toIso8601String(),
    };
}
