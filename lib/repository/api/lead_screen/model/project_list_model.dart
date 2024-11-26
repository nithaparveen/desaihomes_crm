// To parse this JSON data, do
//
//     final projectListModel = projectListModelFromJson(jsonString);

import 'dart:convert';

ProjectListModel projectListModelFromJson(String str) => ProjectListModel.fromJson(json.decode(str));

String projectListModelToJson(ProjectListModel data) => json.encode(data.toJson());

class ProjectListModel {
    List<Project>? projects;
    bool? status;

    ProjectListModel({
        this.projects,
        this.status,
    });

    factory ProjectListModel.fromJson(Map<String, dynamic> json) => ProjectListModel(
        projects: json["projects"] == null ? [] : List<Project>.from(json["projects"]!.map((x) => Project.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "projects": projects == null ? [] : List<dynamic>.from(projects!.map((x) => x.toJson())),
        "status": status,
    };
}

class Project {
    int? id;
    String? name;
    String? url;

    Project({
        this.id,
        this.name,
        this.url,
    });

    factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
    };
}
