import 'container_model.dart';

class GtinPackagingResponse {
  final bool success;
  final String message;
  final List<GtinPackagingModel> data;

  GtinPackagingResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GtinPackagingResponse.fromJson(Map<String, dynamic> json) {
    return GtinPackagingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((item) => GtinPackagingModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class GtinPackagingModel {
  final String id;
  final String gtin;
  final String packagingType;
  final String description;
  final String memberId;
  final String binLocationId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? cartonDetailId;
  final String? palletId;
  final String? containerId;
  final List<PackagingDetailModel> details;
  final BinLocationModel binLocation;

  GtinPackagingModel({
    required this.id,
    required this.gtin,
    required this.packagingType,
    required this.description,
    required this.memberId,
    required this.binLocationId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.cartonDetailId,
    this.palletId,
    this.containerId,
    required this.details,
    required this.binLocation,
  });

  factory GtinPackagingModel.fromJson(Map<String, dynamic> json) {
    return GtinPackagingModel(
      id: json['id'] ?? '',
      gtin: json['GTIN'] ?? '',
      packagingType: json['packagingType'] ?? '',
      description: json['description'] ?? '',
      memberId: json['memberId'] ?? '',
      binLocationId: json['binLocationId'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      cartonDetailId: json['cartonDetailId'],
      palletId: json['palletId'],
      containerId: json['containerId'],
      details: (json['details'] as List?)
              ?.map((item) => PackagingDetailModel.fromJson(item))
              .toList() ??
          [],
      binLocation: BinLocationModel.fromJson(json['binLocation'] ?? {}),
    );
  }
}

class PackagingDetailModel {
  final String id;
  final String masterPackagingId;
  final String serialGTIN;
  final String serialNo;
  final String createdAt;
  final String updatedAt;

  PackagingDetailModel({
    required this.id,
    required this.masterPackagingId,
    required this.serialGTIN,
    required this.serialNo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PackagingDetailModel.fromJson(Map<String, dynamic> json) {
    return PackagingDetailModel(
      id: json['id'] ?? '',
      masterPackagingId: json['masterPackagingId'] ?? '',
      serialGTIN: json['serialGTIN'] ?? '',
      serialNo: json['serialNo'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
