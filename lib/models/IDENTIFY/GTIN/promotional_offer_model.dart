class PromotionalOfferModel {
  final int id;
  final String promotionalOffers;
  final String linkType;
  final String lang;
  final String targetUrl;
  final String gtin;
  final DateTime expiryDate;
  final double price;
  final String banner;
  final String? companyId;

  PromotionalOfferModel({
    required this.id,
    required this.promotionalOffers,
    required this.linkType,
    required this.lang,
    required this.targetUrl,
    required this.gtin,
    required this.expiryDate,
    required this.price,
    required this.banner,
    this.companyId,
  });

  factory PromotionalOfferModel.fromJson(Map<String, dynamic> json) {
    return PromotionalOfferModel(
      id: json['ID'] ?? 0,
      promotionalOffers: json['PromotionalOffers'] ?? '',
      linkType: json['LinkType'] ?? '',
      lang: json['Lang'] ?? '',
      targetUrl: json['TargetURL'] ?? '',
      gtin: json['GTIN'] ?? '',
      expiryDate:
          DateTime.parse(json['ExpiryDate'] ?? DateTime.now().toString()),
      price: (json['price'] ?? 0).toDouble(),
      banner: json['banner'] ?? '',
      companyId: json['companyId'],
    );
  }
}
