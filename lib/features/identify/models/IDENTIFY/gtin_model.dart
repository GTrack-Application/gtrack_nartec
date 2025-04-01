class GTINModel {
  String? imagePath;
  List<Products>? products;

  GTINModel({this.imagePath, this.products});

  GTINModel.fromJson(Map<String, dynamic> json) {
    imagePath = json['image_path'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_path'] = imagePath;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? gcpGLNID;
  String? productnameenglish;
  String? productnamearabic;
  String? brandName;
  String? brandNameAr;
  String? barcode;
  String? gpc;
  String? frontImage;
  String? backImage;

  Products(
      {this.id,
      this.gcpGLNID,
      this.productnameenglish,
      this.productnamearabic,
      this.brandName,
      this.brandNameAr,
      this.barcode,
      this.gpc,
      this.frontImage,
      this.backImage});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gcpGLNID = json['gcpGLNID'];
    productnameenglish = json['productnameenglish'];
    productnamearabic = json['productnamearabic'];
    brandName = json['BrandName'];
    brandNameAr = json['BrandNameAr'];
    barcode = json['barcode'];
    gpc = json['gpc'];
    frontImage = json['front_image'];
    backImage = json['back_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gcpGLNID'] = gcpGLNID;
    data['productnameenglish'] = productnameenglish;
    data['productnamearabic'] = productnamearabic;
    data['BrandName'] = brandName;
    data['BrandNameAr'] = brandNameAr;
    data['barcode'] = barcode;
    data['gpc'] = gpc;
    data['front_image'] = frontImage;
    data['back_image'] = backImage;
    return data;
  }
}
