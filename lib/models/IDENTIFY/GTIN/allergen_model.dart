class AllergenResponse {
  final List<AllergenModel> allergens;
  final PaginationModel pagination;

  AllergenResponse({
    required this.allergens,
    required this.pagination,
  });

  factory AllergenResponse.fromJson(Map<String, dynamic> json) {
    return AllergenResponse(
      allergens: (json['allergens'] as List)
          .map((e) => AllergenModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }
}

class AllergenModel {
  final String id;
  final String barcode;
  final String productName;
  final String allergenName;
  final String allergenType;
  final String severity;
  final bool containsAllergen;
  final bool mayContain;
  final bool crossContaminationRisk;
  final String allergenSource;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expirationDate;
  final String brandOwnerId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String lastModifiedBy;
  final String domainName;
  final String status;

  AllergenModel({
    required this.id,
    required this.barcode,
    required this.productName,
    required this.allergenName,
    required this.allergenType,
    required this.severity,
    required this.containsAllergen,
    required this.mayContain,
    required this.crossContaminationRisk,
    required this.allergenSource,
    required this.lotNumber,
    required this.productionDate,
    required this.expirationDate,
    required this.brandOwnerId,
    required this.createdAt,
    required this.updatedAt,
    required this.lastModifiedBy,
    required this.domainName,
    required this.status,
  });

  factory AllergenModel.fromJson(Map<String, dynamic> json) {
    return AllergenModel(
      id: json['id'],
      barcode: json['barcode'],
      productName: json['product_name'],
      allergenName: json['allergen_name'],
      allergenType: json['allergen_type'],
      severity: json['severity'],
      containsAllergen: json['contains_allergen'],
      mayContain: json['may_contain'],
      crossContaminationRisk: json['cross_contamination_risk'],
      allergenSource: json['allergen_source'],
      lotNumber: json['lot_number'],
      productionDate: DateTime.parse(json['production_date']),
      expirationDate: DateTime.parse(json['expiration_date']),
      brandOwnerId: json['brand_owner_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastModifiedBy: json['last_modified_by'],
      domainName: json['domainName'],
      status: json['status'],
    );
  }
}

class PaginationModel {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginationModel({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json['total'],
      page: json['page'],
      pageSize: json['pageSize'],
      totalPages: json['totalPages'],
    );
  }
}
