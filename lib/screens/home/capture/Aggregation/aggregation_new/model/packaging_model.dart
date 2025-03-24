class PackagingModel {
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
  List<Details>? details;
  BinLocation? binLocation;
  IncludedInPallet? includedInPallet;

  PackagingModel(
      {this.id,
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
      this.details,
      this.binLocation,
      this.includedInPallet});

  PackagingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sSCCNo = json['SSCCNo'];
    packagingType = json['packagingType'];
    description = json['description'];
    memberId = json['memberId'];
    binLocationId = json['binLocationId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    palletId = json['palletId'];
    containerId = json['containerId'].toString();
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
    binLocation = json['binLocation'] != null
        ? BinLocation.fromJson(json['binLocation'])
        : null;
    includedInPallet = json['includedInPallet'] != null
        ? IncludedInPallet.fromJson(json['includedInPallet'])
        : null;
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
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    if (binLocation != null) {
      data['binLocation'] = binLocation!.toJson();
    }
    if (includedInPallet != null) {
      data['includedInPallet'] = includedInPallet!.toJson();
    }
    return data;
  }
}

class Details {
  String? id;
  String? masterPackagingId;
  String? serialGTIN;
  String? serialNo;
  List<dynamic>? includedGTINPackages;

  Details({
    this.id,
    this.masterPackagingId,
    this.serialGTIN,
    this.serialNo,
    this.includedGTINPackages,
  });

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    masterPackagingId = json['masterPackagingId'];
    serialGTIN = json['serialGTIN'];
    serialNo = json['serialNo'];
    if (json['includedGTINPackages'] != null) {
      includedGTINPackages = <dynamic>[];
      json['includedGTINPackages'].forEach((v) {
        includedGTINPackages!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['masterPackagingId'] = masterPackagingId;
    data['serialGTIN'] = serialGTIN;
    data['serialNo'] = serialNo;
    if (includedGTINPackages != null) {
      data['includedGTINPackages'] =
          includedGTINPackages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BinLocation {
  String? id;
  String? groupWarehouse;
  String? zones;
  String? binNumber;
  String? zoneType;
  String? binHeight;
  int? binRow;
  String? binWidth;
  String? binTotalSize;
  String? binType;
  String? gln;
  String? sgln;
  String? zoned;
  String? zoneCode;
  String? zoneName;
  String? minimum;
  String? maximum;
  String? availableQty;
  String? memberId;
  String? createdAt;
  String? updatedAt;

  BinLocation(
      {this.id,
      this.groupWarehouse,
      this.zones,
      this.binNumber,
      this.zoneType,
      this.binHeight,
      this.binRow,
      this.binWidth,
      this.binTotalSize,
      this.binType,
      this.gln,
      this.sgln,
      this.zoned,
      this.zoneCode,
      this.zoneName,
      this.minimum,
      this.maximum,
      this.availableQty,
      this.memberId,
      this.createdAt,
      this.updatedAt});

  BinLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupWarehouse = json['groupWarehouse'];
    zones = json['zones'];
    binNumber = json['binNumber'];
    zoneType = json['zoneType'];
    binHeight = json['binHeight'];
    binRow = json['binRow'];
    binWidth = json['binWidth'];
    binTotalSize = json['binTotalSize'];
    binType = json['binType'];
    gln = json['gln'];
    sgln = json['sgln'];
    zoned = json['zoned'];
    zoneCode = json['zoneCode'];
    zoneName = json['zoneName'];
    minimum = json['minimum'];
    maximum = json['maximum'];
    availableQty = json['availableQty'];
    memberId = json['memberId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupWarehouse'] = groupWarehouse;
    data['zones'] = zones;
    data['binNumber'] = binNumber;
    data['zoneType'] = zoneType;
    data['binHeight'] = binHeight;
    data['binRow'] = binRow;
    data['binWidth'] = binWidth;
    data['binTotalSize'] = binTotalSize;
    data['binType'] = binType;
    data['gln'] = gln;
    data['sgln'] = sgln;
    data['zoned'] = zoned;
    data['zoneCode'] = zoneCode;
    data['zoneName'] = zoneName;
    data['minimum'] = minimum;
    data['maximum'] = maximum;
    data['availableQty'] = availableQty;
    data['memberId'] = memberId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class IncludedInPallet {
  String? id;
  String? sSCCNo;
  String? description;
  String? memberId;
  String? binLocationId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? containerId;

  IncludedInPallet(
      {this.id,
      this.sSCCNo,
      this.description,
      this.memberId,
      this.binLocationId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.containerId});

  IncludedInPallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sSCCNo = json['SSCCNo'];
    description = json['description'];
    memberId = json['memberId'];
    binLocationId = json['binLocationId'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    containerId = json['containerId'];
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
    return data;
  }
}
