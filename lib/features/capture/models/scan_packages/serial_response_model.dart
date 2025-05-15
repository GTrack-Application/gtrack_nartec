class SerialResponseModel {
  final bool success;
  final String message;
  final SerialResponseData data;

  SerialResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SerialResponseModel.fromJson(Map<String, dynamic> json) {
    return SerialResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SerialResponseData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SerialResponseData {
  final List<SerialItem> items;
  final Pagination pagination;

  SerialResponseData({
    required this.items,
    required this.pagination,
  });

  factory SerialResponseData.fromJson(Map<String, dynamic> json) {
    return SerialResponseData(
      items: List<SerialItem>.from(
        json['items'].map((x) => SerialItem.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SerialItem {
  final String id;
  final String masterPackagingId;
  final String? binLocationId;
  final String serialGTIN;
  final String serialNo;
  final MasterPackaging masterPackaging;
  final dynamic binLocation; // null in the sample data
  final List<dynamic> includedGTINPackages;

  SerialItem({
    required this.id,
    required this.masterPackagingId,
    this.binLocationId,
    required this.serialGTIN,
    required this.serialNo,
    required this.masterPackaging,
    this.binLocation,
    required this.includedGTINPackages,
  });

  factory SerialItem.fromJson(Map<String, dynamic> json) {
    return SerialItem(
      id: json['id'] ?? '',
      masterPackagingId: json['masterPackagingId'] ?? '',
      binLocationId: json['binLocationId'],
      serialGTIN: json['serialGTIN'] ?? '',
      serialNo: json['serialNo'] ?? '',
      masterPackaging: MasterPackaging.fromJson(json['masterPackaging']),
      binLocation: json['binLocation'],
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
      'masterPackaging': masterPackaging.toJson(),
      'binLocation': binLocation,
      'includedGTINPackages': includedGTINPackages,
    };
  }
}

class MasterPackaging {
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

  MasterPackaging({
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
  });

  factory MasterPackaging.fromJson(Map<String, dynamic> json) {
    return MasterPackaging(
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
    };
  }
}

class Pagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
