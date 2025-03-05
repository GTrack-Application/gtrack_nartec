class InstructionModel {
  final String id;
  final String barcode;
  final String pdfDoc;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brandOwnerId;
  final String lastModifiedBy;

  InstructionModel({
    required this.id,
    required this.barcode,
    required this.pdfDoc,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.brandOwnerId,
    required this.lastModifiedBy,
  });

  factory InstructionModel.fromJson(Map<String, dynamic> json) {
    return InstructionModel(
      id: json['id'],
      barcode: json['barcode'],
      pdfDoc: json['pdfDoc'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brandOwnerId: json['brand_owner_id'],
      lastModifiedBy: json['last_modified_by'],
    );
  }
}

class InstructionResponse {
  final List<InstructionModel> instructions;
  final int totalPages;
  final int currentPage;

  InstructionResponse({
    required this.instructions,
    required this.totalPages,
    required this.currentPage,
  });

  factory InstructionResponse.fromJson(Map<String, dynamic> json) {
    final List<InstructionModel> instructions = (json['data'] as List)
        .map((item) => InstructionModel.fromJson(item))
        .toList();

    return InstructionResponse(
      instructions: instructions,
      totalPages: json['pagination']['totalPages'],
      currentPage: json['pagination']['page'],
    );
  }
}
