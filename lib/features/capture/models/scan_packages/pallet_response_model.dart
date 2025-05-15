class PalletResponseModel {
  final String level;
  final String ssccNo;
  final PalletData pallet;
  final String message;

  PalletResponseModel({
    required this.level,
    required this.ssccNo,
    required this.pallet,
    required this.message,
  });

  factory PalletResponseModel.fromJson(Map<String, dynamic> json) {
    return PalletResponseModel(
      level: json['level'] ?? '',
      ssccNo: json['ssccNo'] ?? '',
      pallet: PalletData.fromJson(json['pallet']),
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'ssccNo': ssccNo,
      'pallet': pallet.toJson(),
      'message': message,
    };
  }
}

class PalletData {
  final String id;
  final String ssccNo;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? containerId;
  final List<SSCCPackage> ssccPackages;
  final List<dynamic> gtinPackages;
  final ContainerInfo? includedInContainer;

  PalletData({
    required this.id,
    required this.ssccNo,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.containerId,
    required this.ssccPackages,
    required this.gtinPackages,
    this.includedInContainer,
  });

  factory PalletData.fromJson(Map<String, dynamic> json) {
    return PalletData(
      id: json['id'] ?? '',
      ssccNo: json['SSCCNo'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      containerId: json['containerId'],
      ssccPackages: json['ssccPackages'] != null
          ? List<SSCCPackage>.from(
              json['ssccPackages'].map((x) => SSCCPackage.fromJson(x)))
          : [],
      gtinPackages: json['gtinPackages'] ?? [],
      includedInContainer: json['includedInContainer'] != null
          ? ContainerInfo.fromJson(json['includedInContainer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'containerId': containerId,
      'ssccPackages': ssccPackages.map((e) => e.toJson()).toList(),
      'gtinPackages': gtinPackages,
      'includedInContainer': includedInContainer?.toJson(),
    };
  }
}

class SSCCPackage {
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

  SSCCPackage({
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

  factory SSCCPackage.fromJson(Map<String, dynamic> json) {
    return SSCCPackage(
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
      details: json['details'] != null
          ? List<PackageDetail>.from(
              json['details'].map((x) => PackageDetail.fromJson(x)))
          : [],
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

class ContainerInfo {
  final String id;
  final String ssccNo;
  final String containerCode;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;

  ContainerInfo({
    required this.id,
    required this.ssccNo,
    required this.containerCode,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContainerInfo.fromJson(Map<String, dynamic> json) {
    return ContainerInfo(
      id: json['id'] ?? '',
      ssccNo: json['SSCCNo'] ?? '',
      containerCode: json['containerCode'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'SSCCNo': ssccNo,
      'containerCode': containerCode,
      'description': description,
      'memberId': memberId,
      'binLocationId': binLocationId,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
