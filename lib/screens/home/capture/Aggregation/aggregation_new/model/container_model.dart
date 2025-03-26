class ContainerModel {
  final String id;
  final String ssccNo;
  final String containerCode;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<PalletModel> pallets;
  final List<dynamic> ssccPackages;
  final List<dynamic> gtinPackages;
  final BinLocationModel binLocation;

  ContainerModel({
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
    required this.ssccPackages,
    required this.gtinPackages,
    required this.binLocation,
  });

  factory ContainerModel.fromJson(Map<String, dynamic> json) {
    return ContainerModel(
      id: json['id'] ?? '',
      ssccNo: json['SSCCNo'] ?? '',
      containerCode: json['containerCode'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      pallets: (json['pallets'] as List?)
              ?.map((pallet) => PalletModel.fromJson(pallet))
              .toList() ??
          [],
      ssccPackages: json['ssccPackages'] as List? ?? [],
      gtinPackages: json['gtinPackages'] as List? ?? [],
      binLocation: BinLocationModel.fromJson(json['binLocation'] ?? {}),
    );
  }
}

class PalletModel {
  final String id;
  final String ssccNo;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? containerId;

  PalletModel({
    required this.id,
    required this.ssccNo,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.containerId,
  });

  factory PalletModel.fromJson(Map<String, dynamic> json) {
    return PalletModel(
      id: json['id'] ?? '',
      ssccNo: json['SSCCNo'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      containerId: json['containerId'],
    );
  }
}

class BinLocationModel {
  final String id;
  final String groupWarehouse;
  final String zones;
  final String binNumber;
  final String zoneType;
  final String binHeight;
  final int binRow;
  final String binWidth;
  final String binTotalSize;
  final String binType;
  final String gln;
  final String sgln;
  final String zoned;
  final String zoneCode;
  final String zoneName;
  final String minimum;
  final String maximum;
  final String availableQty;
  final String memberId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BinLocationModel({
    required this.id,
    required this.groupWarehouse,
    required this.zones,
    required this.binNumber,
    required this.zoneType,
    required this.binHeight,
    required this.binRow,
    required this.binWidth,
    required this.binTotalSize,
    required this.binType,
    required this.gln,
    required this.sgln,
    required this.zoned,
    required this.zoneCode,
    required this.zoneName,
    required this.minimum,
    required this.maximum,
    required this.availableQty,
    required this.memberId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BinLocationModel.fromJson(Map<String, dynamic> json) {
    return BinLocationModel(
      id: json['id'] ?? '',
      groupWarehouse: json['groupWarehouse'] ?? '',
      zones: json['zones'] ?? '',
      binNumber: json['binNumber'] ?? '',
      zoneType: json['zoneType'] ?? '',
      binHeight: json['binHeight'] ?? '',
      binRow: json['binRow'] ?? 0,
      binWidth: json['binWidth'] ?? '',
      binTotalSize: json['binTotalSize'] ?? '',
      binType: json['binType'] ?? '',
      gln: json['gln'] ?? '',
      sgln: json['sgln'] ?? '',
      zoned: json['zoned'] ?? '',
      zoneCode: json['zoneCode'] ?? '',
      zoneName: json['zoneName'] ?? '',
      minimum: json['minimum'] ?? '',
      maximum: json['maximum'] ?? '',
      availableQty: json['availableQty'] ?? '',
      memberId: json['memberId'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
