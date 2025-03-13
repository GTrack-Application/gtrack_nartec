class EventStationResponse {
  final bool success;
  final String message;
  final List<EventStation> data;

  EventStationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EventStationResponse.fromJson(Map<String, dynamic> json) {
    return EventStationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<EventStation>.from(
              json['data'].map((x) => EventStation.fromJson(x)))
          : [],
    );
  }
}

class EventStation {
  final String id;
  final String eventStationName;
  final String eventStationSubProcessId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventStationSubProcess? eventStationSubProcess;
  final Member? member;

  EventStation({
    required this.id,
    required this.eventStationName,
    required this.eventStationSubProcessId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.eventStationSubProcess,
    this.member,
  });

  factory EventStation.fromJson(Map<String, dynamic> json) {
    return EventStation(
      id: json['id'] ?? '',
      eventStationName: json['eventStationName'] ?? '',
      eventStationSubProcessId: json['eventStationSubProcessId'] ?? '',
      createdBy: json['created_by'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      eventStationSubProcess: json['eventStationSubProcess'] != null
          ? EventStationSubProcess.fromJson(json['eventStationSubProcess'])
          : null,
      member: json['member'] != null ? Member.fromJson(json['member']) : null,
    );
  }
}

class EventStationSubProcess {
  final String id;
  final String name;
  final String description;
  final String linkId;
  final String eventStationMainProcessId;
  final dynamic createdAt;
  final dynamic updatedAt;
  final EventStationMainProcess? eventStationMainProcess;

  EventStationSubProcess({
    required this.id,
    required this.name,
    required this.description,
    required this.linkId,
    required this.eventStationMainProcessId,
    this.createdAt,
    this.updatedAt,
    this.eventStationMainProcess,
  });

  factory EventStationSubProcess.fromJson(Map<String, dynamic> json) {
    return EventStationSubProcess(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      linkId: json['linkId'] ?? '',
      eventStationMainProcessId: json['eventStationMainProcessId'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      eventStationMainProcess: json['eventStationMainProcess'] != null
          ? EventStationMainProcess.fromJson(json['eventStationMainProcess'])
          : null,
    );
  }
}

class EventStationMainProcess {
  final String id;
  final String name;
  final String description;
  final String output;
  final String sectorIndustryProcessId;
  final dynamic supplyChainTrxType;
  final dynamic createdAt;
  final DateTime? updatedAt;
  final String memberId;
  final SectorIndustryProcess? sectorIndustryProcess;

  EventStationMainProcess({
    required this.id,
    required this.name,
    required this.description,
    required this.output,
    required this.sectorIndustryProcessId,
    this.supplyChainTrxType,
    this.createdAt,
    this.updatedAt,
    required this.memberId,
    this.sectorIndustryProcess,
  });

  factory EventStationMainProcess.fromJson(Map<String, dynamic> json) {
    return EventStationMainProcess(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      output: json['output'] ?? '',
      sectorIndustryProcessId: json['sectorIndustryProcessId'] ?? '',
      supplyChainTrxType: json['SupplyChainTrxType'],
      createdAt: json['createdAt'],
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      memberId: json['memberId'] ?? '',
      sectorIndustryProcess: json['sectorIndustryProcess'] != null
          ? SectorIndustryProcess.fromJson(json['sectorIndustryProcess'])
          : null,
    );
  }
}

class SectorIndustryProcess {
  final String id;
  final String name;
  final String description;
  final String sectorIndustryId;
  final dynamic createdAt;
  final dynamic updatedAt;
  final SectorIndustry? sectorIndustry;

  SectorIndustryProcess({
    required this.id,
    required this.name,
    required this.description,
    required this.sectorIndustryId,
    this.createdAt,
    this.updatedAt,
    this.sectorIndustry,
  });

  factory SectorIndustryProcess.fromJson(Map<String, dynamic> json) {
    return SectorIndustryProcess(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      sectorIndustryId: json['sectorIndustryId'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      sectorIndustry: json['sectorIndustry'] != null
          ? SectorIndustry.fromJson(json['sectorIndustry'])
          : null,
    );
  }
}

class SectorIndustry {
  final String id;
  final String name;
  final dynamic createdAt;
  final dynamic updatedAt;

  SectorIndustry({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory SectorIndustry.fromJson(Map<String, dynamic> json) {
    return SectorIndustry(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Member {
  final String id;
  final String email;
  final String password;
  final String stackholderType;
  final String gs1CompanyPrefix;
  final String companyNameEnglish;
  final String companyNameArabic;
  final String contactPerson;
  final String companyLandline;
  final String mobileNo;
  final String extension;
  final String zipCode;
  final String website;
  final String gln;
  final String address;
  final String longitude;
  final String latitude;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Member({
    required this.id,
    required this.email,
    required this.password,
    required this.stackholderType,
    required this.gs1CompanyPrefix,
    required this.companyNameEnglish,
    required this.companyNameArabic,
    required this.contactPerson,
    required this.companyLandline,
    required this.mobileNo,
    required this.extension,
    required this.zipCode,
    required this.website,
    required this.gln,
    required this.address,
    required this.longitude,
    required this.latitude,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      stackholderType: json['stackholderType'] ?? '',
      gs1CompanyPrefix: json['gs1CompanyPrefix'] ?? '',
      companyNameEnglish: json['companyNameEnglish'] ?? '',
      companyNameArabic: json['companyNameArabic'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      companyLandline: json['companyLandline'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      extension: json['extension'] ?? '',
      zipCode: json['zipCode'] ?? '',
      website: json['website'] ?? '',
      gln: json['gln'] ?? '',
      address: json['address'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }
}

// Response model for station attributes
class StationAttributeResponse {
  final bool success;
  final String message;
  final List<StationAttributeMaster> data;

  StationAttributeResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StationAttributeResponse.fromJson(Map<String, dynamic> json) {
    return StationAttributeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<StationAttributeMaster>.from(
              json['data'].map((x) => StationAttributeMaster.fromJson(x)))
          : [],
    );
  }
}

class StationAttributeMaster {
  final String id;
  final String eventStationId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EventStation eventStation;
  final List<StationAttributeDetail> details;

  StationAttributeMaster({
    required this.id,
    required this.eventStationId,
    required this.createdAt,
    required this.updatedAt,
    required this.eventStation,
    required this.details,
  });

  factory StationAttributeMaster.fromJson(Map<String, dynamic> json) {
    return StationAttributeMaster(
      id: json['id'] ?? '',
      eventStationId: json['eventStationId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      eventStation: EventStation.fromJson(json['eventStation'] ?? {}),
      details: json['details'] != null
          ? List<StationAttributeDetail>.from(
              json['details'].map((x) => StationAttributeDetail.fromJson(x)))
          : [],
    );
  }
}

class StationAttributeDetail {
  final String id;
  final String masterId;
  final String attributeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AttributeInfo attribute;

  StationAttributeDetail({
    required this.id,
    required this.masterId,
    required this.attributeId,
    required this.createdAt,
    required this.updatedAt,
    required this.attribute,
  });

  factory StationAttributeDetail.fromJson(Map<String, dynamic> json) {
    return StationAttributeDetail(
      id: json['id'] ?? '',
      masterId: json['masterId'] ?? '',
      attributeId: json['attributeId'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      attribute: AttributeInfo.fromJson(json['attribute'] ?? {}),
    );
  }
}

class AttributeInfo {
  final String id;
  final String fieldName;
  final String fieldType;
  final String fieldDescription;

  AttributeInfo({
    required this.id,
    required this.fieldName,
    required this.fieldType,
    required this.fieldDescription,
  });

  factory AttributeInfo.fromJson(Map<String, dynamic> json) {
    return AttributeInfo(
      id: json['id'] ?? '',
      fieldName: json['fieldName'] ?? '',
      fieldType: json['fieldType'] ?? '',
      fieldDescription: json['fieldDescription'] ?? '',
    );
  }
}
