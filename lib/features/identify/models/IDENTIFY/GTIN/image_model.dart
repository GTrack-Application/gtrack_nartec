class ImageModel {
  final String id;
  final String barcode;
  final String photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brandOwnerId;
  final String lastModifiedBy;
  final String domainName;

  ImageModel({
    required this.id,
    required this.barcode,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
    required this.brandOwnerId,
    required this.lastModifiedBy,
    required this.domainName,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      barcode: json['barcode'],
      photos: json['photos'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brandOwnerId: json['brand_owner_id'],
      lastModifiedBy: json['last_modified_by'],
      domainName: json['domainName'],
    );
  }
}

class ImageResponse {
  final List<ImageModel> images;
  final int totalPages;
  final int currentPage;

  ImageResponse({
    required this.images,
    required this.totalPages,
    required this.currentPage,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    final List<ImageModel> images = (json['data'] as List)
        .map((item) => ImageModel.fromJson(item))
        .toList();

    return ImageResponse(
      images: images,
      totalPages: json['pagination']['totalPages'],
      currentPage: json['pagination']['page'],
    );
  }
}
