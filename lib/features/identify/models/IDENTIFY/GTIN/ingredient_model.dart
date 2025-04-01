class IngredientResponse {
  final List<IngredientModel> ingredients;
  final IngredientPagination pagination;

  IngredientResponse({
    required this.ingredients,
    required this.pagination,
  });

  factory IngredientResponse.fromJson(Map<String, dynamic> json) {
    return IngredientResponse(
      ingredients: (json['data'] as List)
          .map((e) => IngredientModel.fromJson(e))
          .toList(),
      pagination: IngredientPagination.fromJson(json['pagination']),
    );
  }
}

class IngredientModel {
  final String id;
  final String productName;
  final String ingredient;
  final String quantity;
  final String unit;
  final String barcode;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expirationDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brandOwnerId;
  final String lastModifiedBy;
  final String domainName;

  IngredientModel({
    required this.id,
    required this.productName,
    required this.ingredient,
    required this.quantity,
    required this.unit,
    required this.barcode,
    required this.lotNumber,
    required this.productionDate,
    required this.expirationDate,
    required this.createdAt,
    required this.updatedAt,
    required this.brandOwnerId,
    required this.lastModifiedBy,
    required this.domainName,
  });

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      id: json['id'] ?? '',
      productName: json['product_name'] ?? '',
      ingredient: json['ingredient'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? '',
      barcode: json['barcode'] ?? '',
      lotNumber: json['lot_number'] ?? '',
      productionDate: DateTime.parse(json['production_date']),
      expirationDate: DateTime.parse(json['expiration_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brandOwnerId: json['brand_owner_id'] ?? '',
      lastModifiedBy: json['last_modified_by'] ?? '',
      domainName: json['domainName'] ?? '',
    );
  }
}

class IngredientPagination {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  IngredientPagination({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory IngredientPagination.fromJson(Map<String, dynamic> json) {
    return IngredientPagination(
      total: json['total'] ?? 0,
      page: json['page'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}
