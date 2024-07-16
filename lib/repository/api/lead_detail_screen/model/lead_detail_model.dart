// To parse this JSON data, do
//
//     final leadDetailModel = leadDetailModelFromJson(jsonString);

import 'dart:convert';

LeadDetailModel leadDetailModelFromJson(String str) => LeadDetailModel.fromJson(json.decode(str));

String leadDetailModelToJson(LeadDetailModel data) => json.encode(data.toJson());

class LeadDetailModel {
  Lead? lead;
  bool? status;

  LeadDetailModel({
    this.lead,
    this.status,
  });

  factory LeadDetailModel.fromJson(Map<String, dynamic> json) => LeadDetailModel(
    lead: json["lead"] == null ? null : Lead.fromJson(json["lead"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "lead": lead?.toJson(),
    "status": status,
  };
}

class Lead {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? altPhoneNumber;
  String? message;
  String? extraData;
  String? leadType;
  int? crmLeadTypeId;
  String? utmSource;
  String? sourceUrl;
  String? source;
  String? campaignName;
  int? countryId;
  String? ageRange;
  String? profession;
  String? city;
  dynamic adset;
  dynamic adName;
  String? ipAddress;
  String? userAgent;
  dynamic referrerLink;
  String? remarks;
  int? projectId;
  int? preferredProjectId;
  String? assignedTo;
  DateTime? followUpDate;
  String? referredBy;
  String? status;
  DateTime? requestedDate;
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
  AssignedToDetails? crmLeadType;
  AssignedToDetails? assignedToDetails;
  List<Label>? label;
  CrmStatusDetails? crmStatusDetails;
  Country? country;
  PreferredProject? preferredProject;
  List<LeadLabel>? leadLabels;

  Lead({
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
    this.crmLeadType,
    this.assignedToDetails,
    this.label,
    this.crmStatusDetails,
    this.country,
    this.preferredProject,
    this.leadLabels,
  });

  factory Lead.fromJson(Map<String, dynamic> json) => Lead(
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
    followUpDate: json["follow_up_date"] == null ? null : DateTime.parse(json["follow_up_date"]),
    referredBy: json["referred_by"],
    status: json["status"],
    requestedDate: json["requested_date"] == null ? null : DateTime.parse(json["requested_date"]),
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    project: json["project"] == null ? null : AssignedToDetails.fromJson(json["project"]),
    crmLeadType: json["crm_lead_type"] == null ? null : AssignedToDetails.fromJson(json["crm_lead_type"]),
    assignedToDetails: json["assigned_to_details"] == null ? null : AssignedToDetails.fromJson(json["assigned_to_details"]),
    label: json["label"] == null ? [] : List<Label>.from(json["label"]!.map((x) => Label.fromJson(x))),
    crmStatusDetails: json["crm_status_details"] == null ? null : CrmStatusDetails.fromJson(json["crm_status_details"]),
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    preferredProject: json["preferred_project"] == null ? null : PreferredProject.fromJson(json["preferred_project"]),
    leadLabels: json["lead_labels"] == null ? [] : List<LeadLabel>.from(json["lead_labels"]!.map((x) => LeadLabel.fromJson(x))),
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
    "follow_up_date": "${followUpDate!.year.toString().padLeft(4, '0')}-${followUpDate!.month.toString().padLeft(2, '0')}-${followUpDate!.day.toString().padLeft(2, '0')}",
    "referred_by": referredBy,
    "status": status,
    "requested_date": "${requestedDate!.year.toString().padLeft(4, '0')}-${requestedDate!.month.toString().padLeft(2, '0')}-${requestedDate!.day.toString().padLeft(2, '0')}",
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
    "crm_lead_type": crmLeadType?.toJson(),
    "assigned_to_details": assignedToDetails?.toJson(),
    "label": label == null ? [] : List<dynamic>.from(label!.map((x) => x.toJson())),
    "crm_status_details": crmStatusDetails?.toJson(),
    "country": country?.toJson(),
    "preferred_project": preferredProject?.toJson(),
    "lead_labels": leadLabels == null ? [] : List<dynamic>.from(leadLabels!.map((x) => x.toJson())),
  };
}

class AssignedToDetails {
  int? id;
  String? name;

  AssignedToDetails({
    this.id,
    this.name,
  });

  factory AssignedToDetails.fromJson(Map<String, dynamic> json) => AssignedToDetails(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Country {
  int? id;
  String? name;
  String? code;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Country({
    this.id,
    this.name,
    this.code,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class CrmStatusDetails {
  int? id;
  String? name;
  String? slug;
  dynamic dispalyOrder;
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

  factory CrmStatusDetails.fromJson(Map<String, dynamic> json) => CrmStatusDetails(
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
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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

class Label {
  int? id;
  String? title;
  String? bgColor;
  String? textColor;
  int? isPrivate;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  Label({
    this.id,
    this.title,
    this.bgColor,
    this.textColor,
    this.isPrivate,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Label.fromJson(Map<String, dynamic> json) => Label(
    id: json["id"],
    title: json["title"],
    bgColor: json["bg_color"],
    textColor: json["text_color"],
    isPrivate: json["is_private"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "bg_color": bgColor,
    "text_color": textColor,
    "is_private": isPrivate,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class LeadLabel {
  int? id;
  int? leadId;
  int? labelsId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Label? label;

  LeadLabel({
    this.id,
    this.leadId,
    this.labelsId,
    this.createdAt,
    this.updatedAt,
    this.label,
  });

  factory LeadLabel.fromJson(Map<String, dynamic> json) => LeadLabel(
    id: json["id"],
    leadId: json["lead_id"],
    labelsId: json["labels_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    label: json["label"] == null ? null : Label.fromJson(json["label"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "lead_id": leadId,
    "labels_id": labelsId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "label": label?.toJson(),
  };
}

class PreferredProject {
  int? id;
  dynamic oldContent;
  String? oldUrl;
  String? slug;
  String? name;
  String? title;
  String? shortDescription;
  Content? content;
  dynamic extraContent;
  dynamic propertyTypesId;
  int? projectTypeId;
  int? categoriesId;
  int? locationsId;
  int? featuredImageId;
  int? bannerImageId;
  String? browserTitle;
  dynamic ogTitle;
  String? metaDescription;
  dynamic ogDescription;
  dynamic ogImageId;
  String? metaKeywords;
  dynamic topDescription;
  dynamic bottomDescription;
  String? quickThreads;
  dynamic extraCss;
  dynamic extraJs;
  int? priority;
  int? homeFeaturedPriority;
  int? isFeatured;
  int? isReraProject;
  int? isTransit;
  int? isProjectFeatured;
  int? isTrending;
  int? trendingPriority;
  dynamic launchPrice;
  String? currentPrice;
  String? currentPriceLabel;
  int? launchYear;
  dynamic rentalValue;
  int? status;
  int? isSoldOut;
  dynamic searchKeywords;
  dynamic crmSrdNumber;
  dynamic crmProjectId;
  int? isLandingPage;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  PreferredProject({
    this.id,
    this.oldContent,
    this.oldUrl,
    this.slug,
    this.name,
    this.title,
    this.shortDescription,
    this.content,
    this.extraContent,
    this.propertyTypesId,
    this.projectTypeId,
    this.categoriesId,
    this.locationsId,
    this.featuredImageId,
    this.bannerImageId,
    this.browserTitle,
    this.ogTitle,
    this.metaDescription,
    this.ogDescription,
    this.ogImageId,
    this.metaKeywords,
    this.topDescription,
    this.bottomDescription,
    this.quickThreads,
    this.extraCss,
    this.extraJs,
    this.priority,
    this.homeFeaturedPriority,
    this.isFeatured,
    this.isReraProject,
    this.isTransit,
    this.isProjectFeatured,
    this.isTrending,
    this.trendingPriority,
    this.launchPrice,
    this.currentPrice,
    this.currentPriceLabel,
    this.launchYear,
    this.rentalValue,
    this.status,
    this.isSoldOut,
    this.searchKeywords,
    this.crmSrdNumber,
    this.crmProjectId,
    this.isLandingPage,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory PreferredProject.fromJson(Map<String, dynamic> json) => PreferredProject(
    id: json["id"],
    oldContent: json["old_content"],
    oldUrl: json["old_url"],
    slug: json["slug"],
    name: json["name"],
    title: json["title"],
    shortDescription: json["short_description"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    extraContent: json["extra_content"],
    propertyTypesId: json["property_types_id"],
    projectTypeId: json["project_type_id"],
    categoriesId: json["categories_id"],
    locationsId: json["locations_id"],
    featuredImageId: json["featured_image_id"],
    bannerImageId: json["banner_image_id"],
    browserTitle: json["browser_title"],
    ogTitle: json["og_title"],
    metaDescription: json["meta_description"],
    ogDescription: json["og_description"],
    ogImageId: json["og_image_id"],
    metaKeywords: json["meta_keywords"],
    topDescription: json["top_description"],
    bottomDescription: json["bottom_description"],
    quickThreads: json["quick_threads"],
    extraCss: json["extra_css"],
    extraJs: json["extra_js"],
    priority: json["priority"],
    homeFeaturedPriority: json["home_featured_priority"],
    isFeatured: json["is_featured"],
    isReraProject: json["is_rera_project"],
    isTransit: json["is_transit"],
    isProjectFeatured: json["is_project_featured"],
    isTrending: json["is_trending"],
    trendingPriority: json["trending_priority"],
    launchPrice: json["launch_price"],
    currentPrice: json["current_price"],
    currentPriceLabel: json["current_price_label"],
    launchYear: json["launch_year"],
    rentalValue: json["rental_value"],
    status: json["status"],
    isSoldOut: json["is_sold_out"],
    searchKeywords: json["search_keywords"],
    crmSrdNumber: json["crm_srd_number"],
    crmProjectId: json["crm_project_id"],
    isLandingPage: json["is_landing_page"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "old_content": oldContent,
    "old_url": oldUrl,
    "slug": slug,
    "name": name,
    "title": title,
    "short_description": shortDescription,
    "content": content?.toJson(),
    "extra_content": extraContent,
    "property_types_id": propertyTypesId,
    "project_type_id": projectTypeId,
    "categories_id": categoriesId,
    "locations_id": locationsId,
    "featured_image_id": featuredImageId,
    "banner_image_id": bannerImageId,
    "browser_title": browserTitle,
    "og_title": ogTitle,
    "meta_description": metaDescription,
    "og_description": ogDescription,
    "og_image_id": ogImageId,
    "meta_keywords": metaKeywords,
    "top_description": topDescription,
    "bottom_description": bottomDescription,
    "quick_threads": quickThreads,
    "extra_css": extraCss,
    "extra_js": extraJs,
    "priority": priority,
    "home_featured_priority": homeFeaturedPriority,
    "is_featured": isFeatured,
    "is_rera_project": isReraProject,
    "is_transit": isTransit,
    "is_project_featured": isProjectFeatured,
    "is_trending": isTrending,
    "trending_priority": trendingPriority,
    "launch_price": launchPrice,
    "current_price": currentPrice,
    "current_price_label": currentPriceLabel,
    "launch_year": launchYear,
    "rental_value": rentalValue,
    "status": status,
    "is_sold_out": isSoldOut,
    "search_keywords": searchKeywords,
    "crm_srd_number": crmSrdNumber,
    "crm_project_id": crmProjectId,
    "is_landing_page": isLandingPage,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Content {
  String? reraNumber;
  String? bhk;
  MediaId? mediaIdBrandLogo;
  String? summaryDescription;
  MediaId? mediaIdLocation;
  dynamic mediaIdOffer;
  dynamic statusUpdateText;
  dynamic statusUpdateContent;
  dynamic statusUpdateCount;
  dynamic statusUpdateLabel;
  MediaId? mediaIdBrochure;
  String? projectMap;
  String? embedProjectMap;
  MediaId? mediaIdQrCode;
  String? qrLabel;
  String? projectPhone;
  dynamic projectWhatsapp;
  dynamic mediaIdWalkthroughVideo;
  String? walkthroughYoutubeLink;
  dynamic mediaIdLpBannerImage;
  dynamic mediaIdLpMobBannerImage;
  dynamic projectLpPhone;
  dynamic projectLpWhatsapp;

  Content({
    this.reraNumber,
    this.bhk,
    this.mediaIdBrandLogo,
    this.summaryDescription,
    this.mediaIdLocation,
    this.mediaIdOffer,
    this.statusUpdateText,
    this.statusUpdateContent,
    this.statusUpdateCount,
    this.statusUpdateLabel,
    this.mediaIdBrochure,
    this.projectMap,
    this.embedProjectMap,
    this.mediaIdQrCode,
    this.qrLabel,
    this.projectPhone,
    this.projectWhatsapp,
    this.mediaIdWalkthroughVideo,
    this.walkthroughYoutubeLink,
    this.mediaIdLpBannerImage,
    this.mediaIdLpMobBannerImage,
    this.projectLpPhone,
    this.projectLpWhatsapp,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    reraNumber: json["rera_number"],
    bhk: json["bhk"],
    mediaIdBrandLogo: json["media_id_brand_logo"] == null ? null : MediaId.fromJson(json["media_id_brand_logo"]),
    summaryDescription: json["summary_description"],
    mediaIdLocation: json["media_id_location"] == null ? null : MediaId.fromJson(json["media_id_location"]),
    mediaIdOffer: json["media_id_offer"],
    statusUpdateText: json["status_update_text"],
    statusUpdateContent: json["status_update_content"],
    statusUpdateCount: json["status_update_count"],
    statusUpdateLabel: json["status_update_label"],
    mediaIdBrochure: json["media_id_brochure"] == null ? null : MediaId.fromJson(json["media_id_brochure"]),
    projectMap: json["project_map"],
    embedProjectMap: json["embed_project_map"],
    mediaIdQrCode: json["media_id_qr_code"] == null ? null : MediaId.fromJson(json["media_id_qr_code"]),
    qrLabel: json["qr_label"],
    projectPhone: json["project_phone"],
    projectWhatsapp: json["project_whatsapp"],
    mediaIdWalkthroughVideo: json["media_id_walkthrough_video"],
    walkthroughYoutubeLink: json["walkthrough_youtube_link"],
    mediaIdLpBannerImage: json["media_id_lp_banner_image"],
    mediaIdLpMobBannerImage: json["media_id_lp_mob_banner_image"],
    projectLpPhone: json["project_lp_phone"],
    projectLpWhatsapp: json["project_lp_whatsapp"],
  );

  Map<String, dynamic> toJson() => {
    "rera_number": reraNumber,
    "bhk": bhk,
    "media_id_brand_logo": mediaIdBrandLogo?.toJson(),
    "summary_description": summaryDescription,
    "media_id_location": mediaIdLocation?.toJson(),
    "media_id_offer": mediaIdOffer,
    "status_update_text": statusUpdateText,
    "status_update_content": statusUpdateContent,
    "status_update_count": statusUpdateCount,
    "status_update_label": statusUpdateLabel,
    "media_id_brochure": mediaIdBrochure?.toJson(),
    "project_map": projectMap,
    "embed_project_map": embedProjectMap,
    "media_id_qr_code": mediaIdQrCode?.toJson(),
    "qr_label": qrLabel,
    "project_phone": projectPhone,
    "project_whatsapp": projectWhatsapp,
    "media_id_walkthrough_video": mediaIdWalkthroughVideo,
    "walkthrough_youtube_link": walkthroughYoutubeLink,
    "media_id_lp_banner_image": mediaIdLpBannerImage,
    "media_id_lp_mob_banner_image": mediaIdLpMobBannerImage,
    "project_lp_phone": projectLpPhone,
    "project_lp_whatsapp": projectLpWhatsapp,
  };
}

class MediaId {
  int? id;
  String? fileName;
  String? filePath;
  String? thumbFilePath;
  String? fileType;
  int? fileSize;
  String? dimensions;
  String? mediaType;
  dynamic title;
  dynamic description;
  dynamic altText;
  int? isPublic;
  dynamic relatedType;
  dynamic relatedId;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  MediaId({
    this.id,
    this.fileName,
    this.filePath,
    this.thumbFilePath,
    this.fileType,
    this.fileSize,
    this.dimensions,
    this.mediaType,
    this.title,
    this.description,
    this.altText,
    this.isPublic,
    this.relatedType,
    this.relatedId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory MediaId.fromJson(Map<String, dynamic> json) => MediaId(
    id: json["id"],
    fileName: json["file_name"],
    filePath: json["file_path"],
    thumbFilePath: json["thumb_file_path"],
    fileType: json["file_type"],
    fileSize: json["file_size"],
    dimensions: json["dimensions"],
    mediaType: json["media_type"],
    title: json["title"],
    description: json["description"],
    altText: json["alt_text"],
    isPublic: json["is_public"],
    relatedType: json["related_type"],
    relatedId: json["related_id"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_name": fileName,
    "file_path": filePath,
    "thumb_file_path": thumbFilePath,
    "file_type": fileType,
    "file_size": fileSize,
    "dimensions": dimensions,
    "media_type": mediaType,
    "title": title,
    "description": description,
    "alt_text": altText,
    "is_public": isPublic,
    "related_type": relatedType,
    "related_id": relatedId,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}