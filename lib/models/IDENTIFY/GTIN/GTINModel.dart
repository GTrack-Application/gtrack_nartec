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
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? memberID;
  String? adminId;
  String? saveAs;
  String? gtinType;
  String? productUrl;
  String? productLinkUrl;
  String? brandNameAr;
  String? digitalInfoType;
  String? readyForGepir;
  String? gepirPosted;
  String? image1;
  String? image2;
  String? image3;

  GTIN_Model({
    this.id,
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
    this.image3,
  });

  GTIN_Model.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    gcpGLNID = json['gcpGLNID'].toString();
    importCode = json['import_code'].toString();
    productnameenglish = json['productnameenglish'].toString();
    productnamearabic = json['productnamearabic'].toString();
    brandName = json['BrandName'].toString();
    productType = json['ProductType'].toString();
    origin = json['Origin'].toString();
    packagingType = json['PackagingType'].toString();
    mnfCode = json['MnfCode'].toString();
    mnfGLN = json['MnfGLN'].toString();
    provGLN = json['ProvGLN'].toString();
    unit = json['unit'].toString();
    size = json['size'].toString();
    frontImage = json['front_image'].toString();
    backImage = json['back_image'].toString();
    childProduct = json['childProduct'].toString();
    quantity = json['quantity'].toString();
    barcode = json['barcode'].toString();
    gpc = json['gpc'].toString();
    gpcCode = json['gpc_code'].toString();
    countrySale = json['countrySale'].toString();
    hSCODES = json['HSCODES'].toString();
    hsDescription = json['HsDescription'].toString();
    gcpType = json['gcp_type'].toString();
    prodLang = json['prod_lang'].toString();
    detailsPage = json['details_page'].toString();
    detailsPageAr = json['details_page_ar'].toString();
    status = json['status'].toString();
    deletedAt = json['deleted_at'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    memberID = json['memberID'].toString();
    adminId = json['admin_id'].toString();
    saveAs = json['save_as'].toString();
    gtinType = json['gtin_type'].toString();
    productUrl = json['product_url'].toString();
    productLinkUrl = json['product_link_url'].toString();
    brandNameAr = json['BrandNameAr'].toString();
    digitalInfoType = json['digitalInfoType'].toString();
    readyForGepir = json['readyForGepir'].toString();
    gepirPosted = json['gepirPosted'].toString();
    image1 = json['image_1'].toString();
    image2 = json['image_2'].toString();
    image3 = json['image_3'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['gcpGLNID'] = gcpGLNID;
    data['import_code'] = importCode;
    data['productnameenglish'] = productnameenglish;
    data['productnamearabic'] = productnamearabic;
    data['BrandName'] = brandName;
    data['ProductType'] = productType;
    data['Origin'] = origin;
    data['PackagingType'] = packagingType;
    data['MnfCode'] = mnfCode;
    data['MnfGLN'] = mnfGLN;
    data['ProvGLN'] = provGLN;
    data['unit'] = unit;
    data['size'] = size;
    data['front_image'] = frontImage;
    data['back_image'] = backImage;
    data['childProduct'] = childProduct;
    data['quantity'] = quantity;
    data['barcode'] = barcode;
    data['gpc'] = gpc;
    data['gpc_code'] = gpcCode;
    data['countrySale'] = countrySale;
    data['HSCODES'] = hSCODES;
    data['HsDescription'] = hsDescription;
    data['gcp_type'] = gcpType;
    data['prod_lang'] = prodLang;
    data['details_page'] = detailsPage;
    data['details_page_ar'] = detailsPageAr;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['memberID'] = memberID;
    data['admin_id'] = adminId;
    data['save_as'] = saveAs;
    data['gtin_type'] = gtinType;
    data['product_url'] = productUrl;
    data['product_link_url'] = productLinkUrl;
    data['BrandNameAr'] = brandNameAr;
    data['digitalInfoType'] = digitalInfoType;
    data['readyForGepir'] = readyForGepir;
    data['gepirPosted'] = gepirPosted;
    data['image_1'] = image1;
    data['image_2'] = image2;
    data['image_3'] = image3;
    return data;
  }
}

class PaginatedGTINResponse {
  final int currentPage;
  final int pageSize;
  final int totalProducts;
  final List<GTIN_Model> products;

  PaginatedGTINResponse({
    required this.currentPage,
    required this.pageSize,
    required this.totalProducts,
    required this.products,
  });

  factory PaginatedGTINResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedGTINResponse(
      currentPage: json['currentPage'],
      pageSize: json['pageSize'] ?? json['limit'] ?? 10,
      totalProducts: json['totalProducts'],
      products: (json['products'] as List)
          .map((product) => GTIN_Model.fromJson(product))
          .toList(),
    );
  }
}
