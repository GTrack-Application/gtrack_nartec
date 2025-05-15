class SSCCResponseModel {
  final String level;
  final String ssccNo;
  final SSCCData sscc;
  final String message;

  SSCCResponseModel({
    required this.level,
    required this.ssccNo,
    required this.sscc,
    required this.message,
  });

  factory SSCCResponseModel.fromJson(Map<String, dynamic> json) {
    return SSCCResponseModel(
      level: json['level'] ?? '',
      ssccNo: json['ssccNo'] ?? '',
      sscc: SSCCData.fromJson(json['sscc']),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'ssccNo': ssccNo,
      'sscc': sscc.toJson(),
      'message': message,
    };
  }
}

class SSCCData {
  final String id;
  final String ssccNo;
  final String packagingType;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? palletId;
  final String? containerId;
  final List<PackageDetail> details;

  SSCCData({
    required this.id,
    required this.ssccNo,
    required this.packagingType,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.palletId,
    this.containerId,
    required this.details,
  });

  factory SSCCData.fromJson(Map<String, dynamic> json) {
    List<PackageDetail> packageDetails = [];
    if (json['details'] != null &&
        json['details'] is List &&
        json['details'].isNotEmpty) {
      packageDetails = List<PackageDetail>.from(
          json['details'].map((x) => PackageDetail.fromJson(x)));
    }

    return SSCCData(
      id: json['id'] ?? '',
      ssccNo: json['SSCCNo'] ?? '',
      packagingType: json['packagingType'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      palletId: json['palletId'],
      containerId: json['containerId'],
      details: packageDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'packagingType': packagingType,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'palletId': palletId,
      'containerId': containerId,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class PackageDetail {
  final String id;
  final String masterPackagingId;
  final String? binLocationId;
  final String serialGTIN;
  final String serialNo;
  final List<dynamic> includedGTINPackages;

  PackageDetail({
    required this.id,
    required this.masterPackagingId,
    this.binLocationId,
    required this.serialGTIN,
    required this.serialNo,
    required this.includedGTINPackages,
  });

  factory PackageDetail.fromJson(Map<String, dynamic> json) {
    return PackageDetail(
      id: json['id'] ?? '',
      masterPackagingId: json['masterPackagingId'] ?? '',
      binLocationId: json['binLocationId'],
      serialGTIN: json['serialGTIN'] ?? '',
      serialNo: json['serialNo'] ?? '',
      includedGTINPackages: json['includedGTINPackages'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masterPackagingId': masterPackagingId,
      'binLocationId': binLocationId,
      'serialGTIN': serialGTIN,
      'serialNo': serialNo,
      'includedGTINPackages': includedGTINPackages,
    };
  }
}
