class PromotionalOfferModel {
  final int id;
  final String promotionalOffers;
  final String linkType;
  final String lang;
  final String targetUrl;
  final String gtin;
  final String expiryDate;
  final double price;
  final String banner;
  final dynamic companyId;

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
      id: json['ID'],
      promotionalOffers: json['PromotionalOffers'],
      linkType: json['LinkType'],
      lang: json['Lang'],
      targetUrl: json['TargetURL'],
      gtin: json['GTIN'],
      expiryDate: json['ExpiryDate'],
      price: json['price']?.toDouble() ?? 0.0,
      banner: json['banner'],
      companyId: json['companyId'],
    );
  }
}

class PromotionalOfferResponse {
  final List<PromotionalOfferModel> offers;
  final int totalPages;

  PromotionalOfferResponse({
    required this.offers,
    required this.totalPages,
  });

  factory PromotionalOfferResponse.fromJson(List<dynamic> json) {
    final offers = json.map((e) => PromotionalOfferModel.fromJson(e)).toList();
    return PromotionalOfferResponse(
      offers: offers,
      totalPages: 1, // Since pagination isn't implemented in the API yet
    );
  }
}
