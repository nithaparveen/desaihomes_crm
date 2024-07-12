import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  Leads? leads;
  bool? status;

  DashboardModel({
    this.leads,
    this.status,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    leads: json["leads"] == null ? null : Leads.fromJson(json["leads"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "leads": leads?.toJson(),
    "status": status,
  };
}

class Leads {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Leads({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Leads.fromJson(Map<String, dynamic> json) => Leads(
    currentPage: json["current_page"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Datum {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  dynamic altPhoneNumber;
  String? message;
  String? extraData;
  String? leadType;
  int? crmLeadTypeId;
  String? utmSource;
  String? sourceUrl;
  String? source; // Changed from enum Source to String
  String? campaignName;
  dynamic countryId;
  dynamic ageRange;
  dynamic profession;
  String? city;
  String? adset;
  String? adName;
  String? ipAddress;
  dynamic userAgent;
  dynamic referrerLink;
  dynamic remarks;
  int? projectId;
  dynamic preferredProjectId;
  String? assignedTo;
  dynamic followUpDate;
  dynamic referredBy;
  String? status; // Changed from enum Status to String
  dynamic requestedDate;
  dynamic landingPageUrl;
  dynamic ogSourceUrl;
  String? crmStatus;
  int? wasSitevisit;
  int? isClosed;
  dynamic siteVisitDate;
  dynamic siteVisitRemarks;
  dynamic closedRemarks;
  int? emailAlreadyExistLeadId;
  int? phoneAlreadyExistLeadId;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  AssignedToDetails? project;
  CrmStatusDetails? crmStatusDetails;
  List<dynamic>? leadLabels;
  AssignedToDetails? assignedToDetails;
  bool? duplicateFlag;

  Datum({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.altPhoneNumber,
    this.message,
    this.extraData,
    this.leadType,
    this.crmLeadTypeId,
    this.utmSource,
    this.sourceUrl,
    this.source,
    this.campaignName,
    this.countryId,
    this.ageRange,
    this.profession,
    this.city,
    this.adset,
    this.adName,
    this.ipAddress,
    this.userAgent,
    this.referrerLink,
    this.remarks,
    this.projectId,
    this.preferredProjectId,
    this.assignedTo,
    this.followUpDate,
    this.referredBy,
    this.status,
    this.requestedDate,
    this.landingPageUrl,
    this.ogSourceUrl,
    this.crmStatus,
    this.wasSitevisit,
    this.isClosed,
    this.siteVisitDate,
    this.siteVisitRemarks,
    this.closedRemarks,
    this.emailAlreadyExistLeadId,
    this.phoneAlreadyExistLeadId,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.project,
    this.crmStatusDetails,
    this.leadLabels,
    this.assignedToDetails,
    this.duplicateFlag,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    altPhoneNumber: json["alt_phone_number"],
    message: json["message"],
    extraData: json["extra_data"],
    leadType: json["lead_type"],
    crmLeadTypeId: json["crm_lead_type_id"],
    utmSource: json["utm_source"],
    sourceUrl: json["source_url"],
    source: json["source"],
    campaignName: json["campaign_name"],
    countryId: json["country_id"],
    ageRange: json["age_range"],
    profession: json["profession"],
    city: json["city"],
    adset: json["adset"],
    adName: json["ad_name"],
    ipAddress: json["ip_address"],
    userAgent: json["user_agent"],
    referrerLink: json["referrer_link"],
    remarks: json["remarks"],
    projectId: json["project_id"],
    preferredProjectId: json["preferred_project_id"],
    assignedTo: json["assigned_to"],
    followUpDate: json["follow_up_date"],
    referredBy: json["referred_by"],
    status: json["status"],
    requestedDate: json["requested_date"],
    landingPageUrl: json["landing_page_url"],
    ogSourceUrl: json["og_source_url"],
    crmStatus: json["crm_status"],
    wasSitevisit: json["was_sitevisit"],
    isClosed: json["is_closed"],
    siteVisitDate: json["site_visit_date"],
    siteVisitRemarks: json["site_visit_remarks"],
    closedRemarks: json["closed_remarks"],
    emailAlreadyExistLeadId: json["email_already_exist_lead_id"],
    phoneAlreadyExistLeadId: json["phone_already_exist_lead_id"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    project: json["project"] == null
        ? null
        : AssignedToDetails.fromJson(json["project"]),
    crmStatusDetails: json["crm_status_details"] == null
        ? null
        : CrmStatusDetails.fromJson(json["crm_status_details"]),
    leadLabels: json["lead_labels"] == null
        ? []
        : List<dynamic>.from(json["lead_labels"]!.map((x) => x)),
    assignedToDetails: json["assigned_to_details"] == null
        ? null
        : AssignedToDetails.fromJson(json["assigned_to_details"]),
    duplicateFlag: json["duplicate_flag"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_number": phoneNumber,
    "alt_phone_number": altPhoneNumber,
    "message": message,
    "extra_data": extraData,
    "lead_type": leadType,
    "crm_lead_type_id": crmLeadTypeId,
    "utm_source": utmSource,
    "source_url": sourceUrl,
    "source": source,
    "campaign_name": campaignName,
    "country_id": countryId,
    "age_range": ageRange,
    "profession": profession,
    "city": city,
    "adset": adset,
    "ad_name": adName,
    "ip_address": ipAddress,
    "user_agent": userAgent,
    "referrer_link": referrerLink,
    "remarks": remarks,
    "project_id": projectId,
    "preferred_project_id": preferredProjectId,
    "assigned_to": assignedTo,
    "follow_up_date": followUpDate,
    "referred_by": referredBy,
    "status": status,
    "requested_date": requestedDate,
    "landing_page_url": landingPageUrl,
    "og_source_url": ogSourceUrl,
    "crm_status": crmStatus,
    "was_sitevisit": wasSitevisit,
    "is_closed": isClosed,
    "site_visit_date": siteVisitDate,
    "site_visit_remarks": siteVisitRemarks,
    "closed_remarks": closedRemarks,
    "email_already_exist_lead_id": emailAlreadyExistLeadId,
    "phone_already_exist_lead_id": phoneAlreadyExistLeadId,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "project": project?.toJson(),
    "crm_status_details": crmStatusDetails?.toJson(),
    "lead_labels": leadLabels == null
        ? []
        : List<dynamic>.from(leadLabels!.map((x) => x)),
    "assigned_to_details": assignedToDetails?.toJson(),
    "duplicate_flag": duplicateFlag,
  };
}

class AssignedToDetails {
  int? id;
  String? name;

  AssignedToDetails({
    this.id,
    this.name,
  });

  factory AssignedToDetails.fromJson(Map<String, dynamic> json) =>
      AssignedToDetails(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class CrmStatusDetails {
  int? id;
  String? name;
  String? slug;
  int? dispalyOrder;
  String? type;
  String? textColor;
  String? bgColor;
  int? status;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  CrmStatusDetails({
    this.id,
    this.name,
    this.slug,
    this.dispalyOrder,
    this.type,
    this.textColor,
    this.bgColor,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CrmStatusDetails.fromJson(Map<String, dynamic> json) =>
      CrmStatusDetails(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        dispalyOrder: json["dispaly_order"],
        type: json["type"],
        textColor: json["text_color"],
        bgColor: json["bg_color"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "dispaly_order": dispalyOrder,
    "type": type,
    "text_color": textColor,
    "bg_color": bgColor,
    "status": status,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Link {
  String? url;
  String? label;
  bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
