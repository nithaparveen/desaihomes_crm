// To parse this JSON data, do
//
//     final templateModel = templateModelFromJson(jsonString);

import 'dart:convert';

TemplateModel templateModelFromJson(String str) =>
    TemplateModel.fromJson(json.decode(str));

String templateModelToJson(TemplateModel data) => json.encode(data.toJson());

class TemplateModel {
  bool? success;
  String? message;
  Data? data;

  TemplateModel({
    this.success,
    this.message,
    this.data,
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) => TemplateModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Datum>? data;
  Paging? paging;

  Data({
    this.data,
    this.paging,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        paging: json["paging"] == null ? null : Paging.fromJson(json["paging"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "paging": paging?.toJson(),
      };
}

class Datum {
  String? name;
  String? parameterFormat;
  List<Component>? components;
  String? language;
  String? status;
  String? category;
  String? id;

  Datum({
    this.name,
    this.parameterFormat,
    this.components,
    this.language,
    this.status,
    this.category,
    this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        parameterFormat: json["parameter_format"]!,
        components: json["components"] == null
            ? []
            : List<Component>.from(
                json["components"]!.map((x) => Component.fromJson(x))),
        language: json["language"]!,
        status: json["status"]!,
        category: json["category"]!,
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "parameter_format": parameterFormat,
        "components": components == null
            ? []
            : List<dynamic>.from(components!.map((x) => x.toJson())),
        "language": language,
        "status": status,
        "category": category,
        "id": id,
      };
}

class Component {
  String? type;
  String? format;
  String? text;
  Example? example;
  List<Button>? buttons;

  Component({
    this.type,
    this.format,
    this.text,
    this.example,
    this.buttons,
  });

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        type: json["type"],
        format: json["format"],
        text: json["text"],
        example:
            json["example"] == null ? null : Example.fromJson(json["example"]),
        buttons: json["buttons"] == null
            ? []
            : List<Button>.from(
                json["buttons"]!.map((x) => Button.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "format": format,
        "text": text,
        "example": example?.toJson(),
        "buttons": buttons == null
            ? []
            : List<dynamic>.from(buttons!.map((x) => x.toJson())),
      };
}

class Button {
  String? type;
  String? text;
  String? url;
  int? flowId;
  String? flowAction;
  String? navigateScreen;

  Button({
    this.type,
    this.text,
    this.url,
    this.flowId,
    this.flowAction,
    this.navigateScreen,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        type: json["type"]!,
        text: json["text"],
        url: json["url"],
        flowId: json["flow_id"],
        flowAction: json["flow_action"],
        navigateScreen: json["navigate_screen"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
        "url": url,
        "flow_id": flowId,
        "flow_action": flowAction,
        "navigate_screen": navigateScreen,
      };
}

class Example {
  List<String>? headerText;
  List<List<String>>? bodyText;
  List<String>? headerHandle; // Added header_handle field

  Example({
    this.headerText,
    this.bodyText,
    this.headerHandle,
  });

  factory Example.fromJson(Map<String, dynamic> json) => Example(
        headerText: json["header_text"] == null
            ? []
            : List<String>.from(json["header_text"]!.map((x) => x)),
        bodyText: json["body_text"] == null
            ? []
            : List<List<String>>.from(json["body_text"]!
                .map((x) => List<String>.from(x.map((x) => x)))),
        headerHandle: json["header_handle"] == null
            ? []
            : List<String>.from(json["header_handle"]!.map((x) => x)), // Added header_handle parsing
      );

  Map<String, dynamic> toJson() => {
        "header_text": headerText == null
            ? []
            : List<dynamic>.from(headerText!.map((x) => x)),
        "body_text": bodyText == null
            ? []
            : List<dynamic>.from(
                bodyText!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "header_handle": headerHandle == null
            ? []
            : List<dynamic>.from(headerHandle!.map((x) => x)), // Added header_handle serialization
      };
}

class Paging {
  Cursors? cursors;

  Paging({
    this.cursors,
  });

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        cursors:
            json["cursors"] == null ? null : Cursors.fromJson(json["cursors"]),
      );

  Map<String, dynamic> toJson() => {
        "cursors": cursors?.toJson(),
      };
}

class Cursors {
  String? before;
  String? after;

  Cursors({
    this.before,
    this.after,
  });

  factory Cursors.fromJson(Map<String, dynamic> json) => Cursors(
        before: json["before"],
        after: json["after"],
      );

  Map<String, dynamic> toJson() => {
        "before": before,
        "after": after,
      };
}