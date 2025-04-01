class AttributeOption {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;

  AttributeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttributeOption.fromJson(Map<String, dynamic> json) {
    return AttributeOption(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class AttributeOptionsResponse {
  final bool success;
  final String message;
  final List<AttributeOption> data;

  AttributeOptionsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttributeOptionsResponse.fromJson(Map<String, dynamic> json) {
    return AttributeOptionsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)
              ?.map((e) => AttributeOption.fromJson(e))
              .toList() ??
          [],
    );
  }
}
