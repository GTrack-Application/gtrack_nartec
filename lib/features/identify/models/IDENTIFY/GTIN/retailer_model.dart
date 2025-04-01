class RetailerResponse {
  final List<RetailerModel> retailers;
  final RetailerPagination pagination;

  RetailerResponse({
    required this.retailers,
    required this.pagination,
  });

  factory RetailerResponse.fromJson(Map<String, dynamic> json) {
    return RetailerResponse(
      retailers:
          (json['data'] as List).map((e) => RetailerModel.fromJson(e)).toList(),
      pagination: RetailerPagination.fromJson(json['pagination']),
    );
  }
}

class RetailerModel {
  final String id;
  final String productSku;
  final String barcode;
  final String storeId;
  final String storeName;
  final String storeGln;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brandOwnerId;
  final String lastModifiedBy;
  final String domainName;

  RetailerModel({
    required this.id,
    required this.productSku,
    required this.barcode,
    required this.storeId,
    required this.storeName,
    required this.storeGln,
    required this.createdAt,
    required this.updatedAt,
    required this.brandOwnerId,
    required this.lastModifiedBy,
    required this.domainName,
  });

  factory RetailerModel.fromJson(Map<String, dynamic> json) {
    return RetailerModel(
      id: json['id'] ?? '',
      productSku: json['product_sku'] ?? '',
      barcode: json['barcode'] ?? '',
      storeId: json['store_id'] ?? '',
      storeName: json['store_name'] ?? '',
      storeGln: json['store_gln'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brandOwnerId: json['brand_owner_id'] ?? '',
      lastModifiedBy: json['last_modified_by'] ?? '',
      domainName: json['domainName'] ?? '',
    );
  }
}

class RetailerPagination {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  RetailerPagination({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory RetailerPagination.fromJson(Map<String, dynamic> json) {
    return RetailerPagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
