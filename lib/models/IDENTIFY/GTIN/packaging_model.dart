class PackagingResponse {
  final int currentPage;
  final int pageSize;
  final int totalProducts;
  final int totalPages;
  final List<PackagingModel> packagings;

  PackagingResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalProducts,
    required this.totalPages,
    required this.packagings,
  });

  factory PackagingResponse.fromJson(Map<String, dynamic> json) {
    return PackagingResponse(
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalProducts: json['totalProducts'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      packagings: (json['packagings'] as List)
          .map((e) => PackagingModel.fromJson(e))
          .toList(),
    );
  }
}

class PackagingModel {
  final String id;
  final String status;
  final String barcode;
  final String packagingType;
  final String material;
  final String? dimensions;
  final String weight;
  final String? capacity;
  final bool recyclable;
  final bool biodegradable;
  final String? packagingSupplier;
  final String? costPerUnit;
  final String color;
  final String labeling;
  final String brandOwnerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> images;
  final String lastModifiedBy;
  final String domainName;

  PackagingModel({
    required this.id,
    required this.status,
    required this.barcode,
    required this.packagingType,
    required this.material,
    this.dimensions,
    required this.weight,
    this.capacity,
    required this.recyclable,
    required this.biodegradable,
    this.packagingSupplier,
    this.costPerUnit,
    required this.color,
    required this.labeling,
    required this.brandOwnerId,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
    required this.lastModifiedBy,
    required this.domainName,
  });

  factory PackagingModel.fromJson(Map<String, dynamic> json) {
    return PackagingModel(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      barcode: json['barcode'] ?? '',
      packagingType: json['packaging_type'] ?? '',
      material: json['material'] ?? '',
      dimensions: json['dimensions'],
      weight: json['weight']?.toString() ?? '0',
      capacity: json['capacity'],
      recyclable: json['recyclable'] ?? false,
      biodegradable: json['biodegradable'] ?? false,
      packagingSupplier: json['packaging_supplier'],
      costPerUnit: json['cost_per_unit'],
      color: json['color'] ?? '',
      labeling: json['labeling'] ?? '',
      brandOwnerId: json['brand_owner_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: List<String>.from(json['images'] ?? []),
      lastModifiedBy: json['last_modified_by'] ?? '',
      domainName: json['domainName'] ?? '',
    );
  }
}
