class BinLocationsResponse {
  List<BinLocation>? data;

  BinLocationsResponse({this.data});

  // This constructor handles when the response is a direct array
  BinLocationsResponse.fromJsonArray(List<dynamic> jsonArray) {
    data = jsonArray.map((item) => BinLocation.fromJson(item)).toList();
  }

  // This constructor handles when the response is an object with a data field
  BinLocationsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BinLocation>[];
      json['data'].forEach((v) {
        data!.add(BinLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
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
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;

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
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt =
        json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
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
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    return data;
  }
}
