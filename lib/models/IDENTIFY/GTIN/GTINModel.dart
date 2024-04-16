class GTIN_Model {
  String? id;
  String? userId;
  String? gcpGLNID;
  String? importCode;
  String? productnameenglish;
  String? productnamearabic;
  String? brandName;
  String? productType;
  String? origin;
  String? packagingType;
  String? mnfCode;
  String? mnfGLN;
  String? provGLN;
  String? unit;
  String? size;
  String? frontImage;
  String? backImage;
  String? childProduct;
  String? quantity;
  String? barcode;
  String? gpc;
  String? gpcCode;
  String? countrySale;
  String? hSCODES;
  String? hsDescription;
  String? gcpType;
  String? prodLang;
  String? detailsPage;
  String? detailsPageAr;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? memberID;
  int? adminId;
  String? saveAs;
  String? gtinType;
  String? productUrl;
  String? productLinkUrl;
  String? brandNameAr;
  String? digitalInfoType;
  String? readyForGepir;
  int? gepirPosted;
  String? image1;
  String? image2;
  String? image3;

  GTIN_Model(
      {this.id,
      this.userId,
      this.gcpGLNID,
      this.importCode,
      this.productnameenglish,
      this.productnamearabic,
      this.brandName,
      this.productType,
      this.origin,
      this.packagingType,
      this.mnfCode,
      this.mnfGLN,
      this.provGLN,
      this.unit,
      this.size,
      this.frontImage,
      this.backImage,
      this.childProduct,
      this.quantity,
      this.barcode,
      this.gpc,
      this.gpcCode,
      this.countrySale,
      this.hSCODES,
      this.hsDescription,
      this.gcpType,
      this.prodLang,
      this.detailsPage,
      this.detailsPageAr,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.memberID,
      this.adminId,
      this.saveAs,
      this.gtinType,
      this.productUrl,
      this.productLinkUrl,
      this.brandNameAr,
      this.digitalInfoType,
      this.readyForGepir,
      this.gepirPosted,
      this.image1,
      this.image2,
      this.image3});

  GTIN_Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    gcpGLNID = json['gcpGLNID'];
    importCode = json['import_code'];
    productnameenglish = json['productnameenglish'];
    productnamearabic = json['productnamearabic'];
    brandName = json['BrandName'];
    productType = json['ProductType'];
    origin = json['Origin'];
    packagingType = json['PackagingType'];
    mnfCode = json['MnfCode'];
    mnfGLN = json['MnfGLN'];
    provGLN = json['ProvGLN'];
    unit = json['unit'];
    size = json['size'];
    frontImage = json['front_image'];
    backImage = json['back_image'];
    childProduct = json['childProduct'];
    quantity = json['quantity'];
    barcode = json['barcode'];
    gpc = json['gpc'];
    gpcCode = json['gpc_code'];
    countrySale = json['countrySale'];
    hSCODES = json['HSCODES'];
    hsDescription = json['HsDescription'];
    gcpType = json['gcp_type'];
    prodLang = json['prod_lang'];
    detailsPage = json['details_page'];
    detailsPageAr = json['details_page_ar'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    memberID = json['memberID'];
    adminId = json['admin_id'];
    saveAs = json['save_as'];
    gtinType = json['gtin_type'];
    productUrl = json['product_url'];
    productLinkUrl = json['product_link_url'];
    brandNameAr = json['BrandNameAr'];
    digitalInfoType = json['digitalInfoType'];
    readyForGepir = json['readyForGepir'];
    gepirPosted = json['gepirPosted'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['gcpGLNID'] = this.gcpGLNID;
    data['import_code'] = this.importCode;
    data['productnameenglish'] = this.productnameenglish;
    data['productnamearabic'] = this.productnamearabic;
    data['BrandName'] = this.brandName;
    data['ProductType'] = this.productType;
    data['Origin'] = this.origin;
    data['PackagingType'] = this.packagingType;
    data['MnfCode'] = this.mnfCode;
    data['MnfGLN'] = this.mnfGLN;
    data['ProvGLN'] = this.provGLN;
    data['unit'] = this.unit;
    data['size'] = this.size;
    data['front_image'] = this.frontImage;
    data['back_image'] = this.backImage;
    data['childProduct'] = this.childProduct;
    data['quantity'] = this.quantity;
    data['barcode'] = this.barcode;
    data['gpc'] = this.gpc;
    data['gpc_code'] = this.gpcCode;
    data['countrySale'] = this.countrySale;
    data['HSCODES'] = this.hSCODES;
    data['HsDescription'] = this.hsDescription;
    data['gcp_type'] = this.gcpType;
    data['prod_lang'] = this.prodLang;
    data['details_page'] = this.detailsPage;
    data['details_page_ar'] = this.detailsPageAr;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['memberID'] = this.memberID;
    data['admin_id'] = this.adminId;
    data['save_as'] = this.saveAs;
    data['gtin_type'] = this.gtinType;
    data['product_url'] = this.productUrl;
    data['product_link_url'] = this.productLinkUrl;
    data['BrandNameAr'] = this.brandNameAr;
    data['digitalInfoType'] = this.digitalInfoType;
    data['readyForGepir'] = this.readyForGepir;
    data['gepirPosted'] = this.gepirPosted;
    data['image_1'] = this.image1;
    data['image_2'] = this.image2;
    data['image_3'] = this.image3;
    return data;
  }
}
