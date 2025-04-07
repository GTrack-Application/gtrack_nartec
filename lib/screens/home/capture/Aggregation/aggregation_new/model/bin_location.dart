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
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  BinLocation({
    this.id,
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
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

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
    latitude = json['latitude'];
    longitude = json['longitude'];
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
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
