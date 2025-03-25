import 'bin_location.dart';

class PalletizationModel {
  String? id;
  String? sSCCNo;
  String? description;
  String? memberId;
  String? binLocationId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? containerId;
  List<SsccPackage>? ssccPackages;
  BinLocation? binLocation;
  IncludedInContainer? includedInContainer;

  PalletizationModel({
    this.id,
    this.sSCCNo,
    this.description,
    this.memberId,
    this.binLocationId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.containerId,
    this.ssccPackages,
    this.binLocation,
    this.includedInContainer,
  });

  factory PalletizationModel.fromJson(Map<String, dynamic> json) {
    return PalletizationModel(
      id: json['id'],
      sSCCNo: json['SSCCNo'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      containerId: json['containerId'],
      ssccPackages: json['ssccPackages'] != null
          ? List<SsccPackage>.from(
              json['ssccPackages'].map((x) => SsccPackage.fromJson(x)))
          : [],
      binLocation: json['binLocation'] != null
          ? BinLocation.fromJson(json['binLocation'])
          : null,
      includedInContainer: json['includedInContainer'] != null
          ? IncludedInContainer.fromJson(json['includedInContainer'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['SSCCNo'] = sSCCNo;
    data['description'] = description;
    data['memberId'] = memberId;
    data['binLocationId'] = binLocationId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['containerId'] = containerId;
    if (ssccPackages != null) {
      data['ssccPackages'] = ssccPackages!.map((v) => v.toJson()).toList();
    }
    if (binLocation != null) {
      data['binLocation'] = binLocation!.toJson();
    }
    if (includedInContainer != null) {
      data['includedInContainer'] = includedInContainer!.toJson();
    }
    return data;
  }
}

class SsccPackage {
  String? id;
  String? sSCCNo;
  String? packagingType;
  String? description;
  String? memberId;
  String? binLocationId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? palletId;
  String? containerId;

  SsccPackage({
    this.id,
    this.sSCCNo,
    this.packagingType,
    this.description,
    this.memberId,
    this.binLocationId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.palletId,
    this.containerId,
  });

  factory SsccPackage.fromJson(Map<String, dynamic> json) {
    return SsccPackage(
      id: json['id'],
      sSCCNo: json['SSCCNo'],
      packagingType: json['packagingType'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      palletId: json['palletId'],
      containerId: json['containerId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['SSCCNo'] = sSCCNo;
    data['packagingType'] = packagingType;
    data['description'] = description;
    data['memberId'] = memberId;
    data['binLocationId'] = binLocationId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['palletId'] = palletId;
    data['containerId'] = containerId;
    return data;
  }
}

class IncludedInContainer {
  String? id;
  String? sSCCNo;
  String? containerCode;
  String? description;
  String? memberId;
  String? binLocationId;
  String? status;
  String? createdAt;
  String? updatedAt;

  IncludedInContainer({
    this.id,
    this.sSCCNo,
    this.containerCode,
    this.description,
    this.memberId,
    this.binLocationId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory IncludedInContainer.fromJson(Map<String, dynamic> json) {
    return IncludedInContainer(
      id: json['id'],
      sSCCNo: json['SSCCNo'],
      containerCode: json['containerCode'],
      description: json['description'],
      memberId: json['memberId'],
      binLocationId: json['binLocationId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['SSCCNo'] = sSCCNo;
    data['containerCode'] = containerCode;
    data['description'] = description;
    data['memberId'] = memberId;
    data['binLocationId'] = binLocationId;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
