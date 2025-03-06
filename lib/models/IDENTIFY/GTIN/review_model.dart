class ReviewModel {
  String? id;
  String? locationIP;
  String? senderId;
  int? rating;
  String? comments;
  String? createdAt;
  String? updatedAt;
  String? productId;
  String? productDescription;
  String? brandName;
  String? gTIN;
  String? gcpGLNID;

  ReviewModel(
      {this.id,
      this.locationIP,
      this.senderId,
      this.rating,
      this.comments,
      this.createdAt,
      this.updatedAt,
      this.productId,
      this.productDescription,
      this.brandName,
      this.gTIN,
      this.gcpGLNID});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locationIP = json['LocationIP'];
    senderId = json['SenderId'];
    rating = json['rating'];
    comments = json['Comments'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    productId = json['ProductId'];
    productDescription = json['ProductDescription'];
    brandName = json['BrandName'];
    gTIN = json['GTIN'];
    gcpGLNID = json['gcpGLNID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['LocationIP'] = locationIP;
    data['SenderId'] = senderId;
    data['rating'] = rating;
    data['Comments'] = comments;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['ProductId'] = productId;
    data['ProductDescription'] = productDescription;
    data['BrandName'] = brandName;
    data['GTIN'] = gTIN;
    data['gcpGLNID'] = gcpGLNID;
    return data;
  }
}
