// // Packaging Scan Models for SSCC API
// // This file contains models for the three different response types: SSCC, Pallet, and Container

// // Base class for common packaging fields
// abstract class BasePackagingInfo {
//   final String id;
//   final String SSCCNo;
//   final String description;
//   final String memberId;
//   final String binLocationId;
//   final String status;
//   final String createdAt;
//   final String updatedAt;

//   BasePackagingInfo({
//     required this.id,
//     required this.SSCCNo,
//     required this.description,
//     required this.memberId,
//     required this.binLocationId,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // Factory method to be implemented by subclasses
//   factory BasePackagingInfo.fromJson(Map<String, dynamic> json) {
//     throw UnimplementedError(
//         'BasePackagingInfo.fromJson must be implemented by subclasses');
//   }
// }

// class PackagingScanResponse {
//   final String level;
//   final String ssccNo;
//   final SSCCInfo? sscc;
//   final PalletInfo? pallet;
//   final ContainerInfo? container;
//   final String message;

//   PackagingScanResponse({
//     required this.level,
//     required this.ssccNo,
//     this.sscc,
//     this.pallet,
//     this.container,
//     required this.message,
//   });

//   factory PackagingScanResponse.fromJson(Map<String, dynamic> json) {
//     return PackagingScanResponse(
//       level: json['level'] ?? '',
//       ssccNo: json['ssccNo'] ?? '',
//       sscc: json['sscc'] != null ? SSCCInfo.fromJson(json['sscc']) : null,
//       pallet:
//           json['pallet'] != null ? PalletInfo.fromJson(json['pallet']) : null,
//       container: json['container'] != null
//           ? ContainerInfo.fromJson(json['container'])
//           : null,
//       message: json['message'] ?? '',
//     );
//   }

//   // Helper method to get the appropriate level info
//   T? getLevelInfo<T>() {
//     switch (level.toLowerCase()) {
//       case 'sscc':
//         return sscc as T?;
//       case 'pallet':
//         return pallet as T?;
//       case 'container':
//         return container as T?;
//       default:
//         return null;
//     }
//   }
// }

// // Common classes used across different levels
// class PackageDetail {
//   final String id;
//   final String masterPackagingId;
//   final String? binLocationId;
//   final String serialGTIN;
//   final String serialNo;
//   final List<dynamic> includedGTINPackages;

//   PackageDetail({
//     required this.id,
//     required this.masterPackagingId,
//     this.binLocationId,
//     required this.serialGTIN,
//     required this.serialNo,
//     required this.includedGTINPackages,
//   });

//   factory PackageDetail.fromJson(Map<String, dynamic> json) {
//     return PackageDetail(
//       id: json['id'] ?? '',
//       masterPackagingId: json['masterPackagingId'] ?? '',
//       binLocationId: json['binLocationId'],
//       serialGTIN: json['serialGTIN'] ?? '',
//       serialNo: json['serialNo'] ?? '',
//       includedGTINPackages: json['includedGTINPackages'] ?? [],
//     );
//   }

//   // Create a copy of this object with modified properties
//   PackageDetail copyWith({
//     String? id,
//     String? masterPackagingId,
//     String? binLocationId,
//     String? serialGTIN,
//     String? serialNo,
//     List<dynamic>? includedGTINPackages,
//   }) {
//     return PackageDetail(
//       id: id ?? this.id,
//       masterPackagingId: masterPackagingId ?? this.masterPackagingId,
//       binLocationId: binLocationId ?? this.binLocationId,
//       serialGTIN: serialGTIN ?? this.serialGTIN,
//       serialNo: serialNo ?? this.serialNo,
//       includedGTINPackages: includedGTINPackages ?? this.includedGTINPackages,
//     );
//   }
// }

// class SSCCPackage extends BasePackagingInfo {
//   final String packagingType;
//   final String? palletId;
//   final String? containerId;
//   final List<PackageDetail> details;

//   SSCCPackage({
//     required String id,
//     required String SSCCNo,
//     required this.packagingType,
//     required String description,
//     required String memberId,
//     required String binLocationId,
//     required String status,
//     required String createdAt,
//     required String updatedAt,
//     this.palletId,
//     this.containerId,
//     required this.details,
//   }) : super(
//           id: id,
//           SSCCNo: SSCCNo,
//           description: description,
//           memberId: memberId,
//           binLocationId: binLocationId,
//           status: status,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );

//   factory SSCCPackage.fromJson(Map<String, dynamic> json) {
//     List<PackageDetail> packageDetails = [];
//     if (json['details'] != null) {
//       packageDetails = List<PackageDetail>.from(
//         json['details'].map((x) => PackageDetail.fromJson(x)),
//       );
//     }

//     return SSCCPackage(
//       id: json['id'] ?? '',
//       SSCCNo: json['SSCCNo'] ?? '',
//       packagingType: json['packagingType'] ?? '',
//       description: json['description'] ?? '',
//       memberId: json['memberId'] ?? '',
//       binLocationId: json['binLocationId'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       palletId: json['palletId'],
//       containerId: json['containerId'],
//       details: packageDetails,
//     );
//   }

//   // Create a copy of this object with modified properties
//   SSCCPackage copyWith({
//     String? id,
//     String? SSCCNo,
//     String? packagingType,
//     String? description,
//     String? memberId,
//     String? binLocationId,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//     String? palletId,
//     String? containerId,
//     List<PackageDetail>? details,
//   }) {
//     return SSCCPackage(
//       id: id ?? this.id,
//       SSCCNo: SSCCNo ?? this.SSCCNo,
//       packagingType: packagingType ?? this.packagingType,
//       description: description ?? this.description,
//       memberId: memberId ?? this.memberId,
//       binLocationId: binLocationId ?? this.binLocationId,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       palletId: palletId ?? this.palletId,
//       containerId: containerId ?? this.containerId,
//       details: details ?? this.details,
//     );
//   }
// }

// // SSCCInfo class for level="sscc" response
// class SSCCInfo extends BasePackagingInfo {
//   final String packagingType;
//   final String? palletId;
//   final String? containerId;
//   final List<PackageDetail> details;

//   SSCCInfo({
//     required String id,
//     required String SSCCNo,
//     required this.packagingType,
//     required String description,
//     required String memberId,
//     required String binLocationId,
//     required String status,
//     required String createdAt,
//     required String updatedAt,
//     this.palletId,
//     this.containerId,
//     required this.details,
//   }) : super(
//           id: id,
//           SSCCNo: SSCCNo,
//           description: description,
//           memberId: memberId,
//           binLocationId: binLocationId,
//           status: status,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );

//   factory SSCCInfo.fromJson(Map<String, dynamic> json) {
//     List<PackageDetail> packageDetails = [];
//     if (json['details'] != null) {
//       packageDetails = List<PackageDetail>.from(
//         json['details'].map((x) => PackageDetail.fromJson(x)),
//       );
//     }

//     return SSCCInfo(
//       id: json['id'] ?? '',
//       SSCCNo: json['SSCCNo'] ?? '',
//       packagingType: json['packagingType'] ?? '',
//       description: json['description'] ?? '',
//       memberId: json['memberId'] ?? '',
//       binLocationId: json['binLocationId'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       palletId: json['palletId'],
//       containerId: json['containerId'],
//       details: packageDetails,
//     );
//   }

//   // Create a copy of this object with modified properties
//   SSCCInfo copyWith({
//     String? id,
//     String? SSCCNo,
//     String? packagingType,
//     String? description,
//     String? memberId,
//     String? binLocationId,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//     String? palletId,
//     String? containerId,
//     List<PackageDetail>? details,
//   }) {
//     return SSCCInfo(
//       id: id ?? this.id,
//       SSCCNo: SSCCNo ?? this.SSCCNo,
//       packagingType: packagingType ?? this.packagingType,
//       description: description ?? this.description,
//       memberId: memberId ?? this.memberId,
//       binLocationId: binLocationId ?? this.binLocationId,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       palletId: palletId ?? this.palletId,
//       containerId: containerId ?? this.containerId,
//       details: details ?? this.details,
//     );
//   }
// }

// // PalletInfo class for level="pallet" response
// class PalletInfo extends BasePackagingInfo {
//   final String? containerId;
//   final List<SSCCPackage> ssccPackages;
//   final List<dynamic> gtinPackages;
//   final ContainerInfo? includedInContainer;

//   PalletInfo({
//     required String id,
//     required String SSCCNo,
//     required String description,
//     required String memberId,
//     required String binLocationId,
//     required String status,
//     required String createdAt,
//     required String updatedAt,
//     this.containerId,
//     required this.ssccPackages,
//     required this.gtinPackages,
//     this.includedInContainer,
//   }) : super(
//           id: id,
//           SSCCNo: SSCCNo,
//           description: description,
//           memberId: memberId,
//           binLocationId: binLocationId,
//           status: status,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );

//   factory PalletInfo.fromJson(Map<String, dynamic> json) {
//     List<SSCCPackage> ssccPackagesList = [];
//     if (json['ssccPackages'] != null) {
//       ssccPackagesList = List<SSCCPackage>.from(
//         json['ssccPackages'].map((x) => SSCCPackage.fromJson(x)),
//       );
//     }

//     return PalletInfo(
//       id: json['id'] ?? '',
//       SSCCNo: json['SSCCNo'] ?? '',
//       description: json['description'] ?? '',
//       memberId: json['memberId'] ?? '',
//       binLocationId: json['binLocationId'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       containerId: json['containerId'],
//       ssccPackages: ssccPackagesList,
//       gtinPackages: json['gtinPackages'] ?? [],
//       includedInContainer: json['includedInContainer'] != null
//           ? ContainerInfo.fromJson(json['includedInContainer'])
//           : null,
//     );
//   }

//   // Create a copy of this object with modified properties
//   PalletInfo copyWith({
//     String? id,
//     String? SSCCNo,
//     String? description,
//     String? memberId,
//     String? binLocationId,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//     String? containerId,
//     List<SSCCPackage>? ssccPackages,
//     List<dynamic>? gtinPackages,
//     ContainerInfo? includedInContainer,
//   }) {
//     return PalletInfo(
//       id: id ?? this.id,
//       SSCCNo: SSCCNo ?? this.SSCCNo,
//       description: description ?? this.description,
//       memberId: memberId ?? this.memberId,
//       binLocationId: binLocationId ?? this.binLocationId,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       containerId: containerId ?? this.containerId,
//       ssccPackages: ssccPackages ?? this.ssccPackages,
//       gtinPackages: gtinPackages ?? this.gtinPackages,
//       includedInContainer: includedInContainer ?? this.includedInContainer,
//     );
//   }
// }

// // ContainerInfo class for level="container" response
// class ContainerInfo extends BasePackagingInfo {
//   final String containerCode;
//   final List<PalletInfo>? pallets;
//   final List<dynamic>? ssccPackages;
//   final List<dynamic>? gtinPackages;

//   ContainerInfo({
//     required String id,
//     required String SSCCNo,
//     required this.containerCode,
//     required String description,
//     required String memberId,
//     required String binLocationId,
//     required String status,
//     required String createdAt,
//     required String updatedAt,
//     this.pallets,
//     this.ssccPackages,
//     this.gtinPackages,
//   }) : super(
//           id: id,
//           SSCCNo: SSCCNo,
//           description: description,
//           memberId: memberId,
//           binLocationId: binLocationId,
//           status: status,
//           createdAt: createdAt,
//           updatedAt: updatedAt,
//         );

//   factory ContainerInfo.fromJson(Map<String, dynamic> json) {
//     List<PalletInfo>? palletsList;
//     if (json['pallets'] != null) {
//       palletsList = List<PalletInfo>.from(
//         json['pallets'].map((x) => PalletInfo.fromJson(x)),
//       );
//     }

//     return ContainerInfo(
//       id: json['id'] ?? '',
//       SSCCNo: json['SSCCNo'] ?? '',
//       containerCode: json['containerCode'] ?? '',
//       description: json['description'] ?? '',
//       memberId: json['memberId'] ?? '',
//       binLocationId: json['binLocationId'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       pallets: palletsList,
//       ssccPackages: json['ssccPackages'],
//       gtinPackages: json['gtinPackages'],
//     );
//   }

//   // Create a copy of this object with modified properties
//   ContainerInfo copyWith({
//     String? id,
//     String? SSCCNo,
//     String? containerCode,
//     String? description,
//     String? memberId,
//     String? binLocationId,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//     List<PalletInfo>? pallets,
//     List<dynamic>? ssccPackages,
//     List<dynamic>? gtinPackages,
//   }) {
//     return ContainerInfo(
//       id: id ?? this.id,
//       SSCCNo: SSCCNo ?? this.SSCCNo,
//       containerCode: containerCode ?? this.containerCode,
//       description: description ?? this.description,
//       memberId: memberId ?? this.memberId,
//       binLocationId: binLocationId ?? this.binLocationId,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       pallets: pallets ?? this.pallets,
//       ssccPackages: ssccPackages ?? this.ssccPackages,
//       gtinPackages: gtinPackages ?? this.gtinPackages,
//     );
//   }
// }

class ContainerResponseModel {
  final String level;
  final String ssccNo;
  final ContainerData container;
  final String message;

  ContainerResponseModel({
    required this.level,
    required this.ssccNo,
    required this.container,
    required this.message,
  });

  factory ContainerResponseModel.fromJson(Map<String, dynamic> json) {
    return ContainerResponseModel(
      level: json['level'],
      ssccNo: json['ssccNo'],
      container: ContainerData.fromJson(json['container']),
      message: json['message'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'ssccNo': ssccNo,
      'container': container.toJson(),
      'message': message,
    };
  }
}

class ContainerData {
  final String id;
  final String ssccNo;
  final String containerCode;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<Pallet> pallets;

  ContainerData({
    required this.id,
    required this.ssccNo,
    required this.containerCode,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.pallets,
  });

  factory ContainerData.fromJson(Map<String, dynamic> json) {
    return ContainerData(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      containerCode: json['containerCode'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pallets: (json['pallets'] as List<dynamic>)
          .map((e) => Pallet.fromJson(e))
          .toList(),
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
      'pallets': pallets.map((e) => e.toJson()).toList(),
    };
  }
}

class Pallet {
  final String id;
  final String ssccNo;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String containerId;
  final List<SSCCPackage> ssccPackages;

  Pallet({
    required this.id,
    required this.ssccNo,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.containerId,
    required this.ssccPackages,
  });

  factory Pallet.fromJson(Map<String, dynamic> json) {
    return Pallet(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      containerId: json['containerId'] ?? '',
      ssccPackages: (json['ssccPackages'] as List<dynamic>)
          .map((e) => SSCCPackage.fromJson(e))
          .toList(),
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
    required this.palletId,
    required this.containerId,
    required this.details,
  });

  factory SSCCPackage.fromJson(Map<String, dynamic> json) {
    return SSCCPackage(
      id: json['id'],
      ssccNo: json['SSCCNo'],
      packagingType: json['packagingType'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      palletId: json['palletId'],
      containerId: json['containerId'],
      details: (json['details'] as List<dynamic>)
          .map((e) => PackageDetail.fromJson(e))
          .toList(),
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
      id: json['id'],
      masterPackagingId: json['masterPackagingId'],
      binLocationId: json['binLocationId'],
      serialGTIN: json['serialGTIN'],
      serialNo: json['serialNo'],
      includedGTINPackages: json['includedGTINPackages'],
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
