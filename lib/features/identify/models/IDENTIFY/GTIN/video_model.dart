class VideoModel {
  final String id;
  final String barcode;
  final String videos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String brandOwnerId;
  final String lastModifiedBy;
  final String domainName;

  VideoModel({
    required this.id,
    required this.barcode,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
    required this.brandOwnerId,
    required this.lastModifiedBy,
    required this.domainName,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      barcode: json['barcode'] ?? '',
      videos: json['videos'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      brandOwnerId: json['brand_owner_id'] ?? '',
      lastModifiedBy: json['last_modified_by'] ?? '',
      domainName: json['domainName'] ?? '',
    );
  }
}

class VideoResponse {
  final List<VideoModel> videos;
  final int totalPages;
  final int currentPage;

  VideoResponse({
    required this.videos,
    required this.totalPages,
    required this.currentPage,
  });

  factory VideoResponse.fromJson(Map<String, dynamic> json) {
    final videos = (json['data'] as List)
        .map((item) => VideoModel.fromJson(item))
        .toList();

    return VideoResponse(
      videos: videos,
      totalPages: json['pagination']['totalPages'],
      currentPage: json['pagination']['page'],
    );
  }
}
