class MemberDataModel {
  User? user;
  MemberCategory? memberCategory;
  String? gtinRange;
  int? issuedGTIN;
  int? remainingGTIN;
  int? glnTotalBarcode;
  int? issuedGLN;
  int? ssccTotalBarcode;
  int? issuedSSCC;

  MemberDataModel(
      {this.user,
      this.memberCategory,
      this.gtinRange,
      this.issuedGTIN,
      this.remainingGTIN,
      this.glnTotalBarcode,
      this.issuedGLN,
      this.ssccTotalBarcode,
      this.issuedSSCC});

  MemberDataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    memberCategory = json['memberCategory'] != null
        ? MemberCategory.fromJson(json['memberCategory'])
        : null;
    gtinRange = json['gtinRange'];
    issuedGTIN = json['issuedGTIN'];
    remainingGTIN = json['remainingGTIN'];
    glnTotalBarcode = json['glnTotalBarcode'];
    issuedGLN = json['issuedGLN'];
    ssccTotalBarcode = json['ssccTotalBarcode'];
    issuedSSCC = json['issuedSSCC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (memberCategory != null) {
      data['memberCategory'] = memberCategory!.toJson();
    }
    data['gtinRange'] = gtinRange;
    data['issuedGTIN'] = issuedGTIN;
    data['remainingGTIN'] = remainingGTIN;
    data['glnTotalBarcode'] = glnTotalBarcode;
    data['issuedGLN'] = issuedGLN;
    data['ssccTotalBarcode'] = ssccTotalBarcode;
    data['issuedSSCC'] = issuedSSCC;
    return data;
  }
}

class User {
  int? id;
  String? userType;
  String? slug;
  String? locationUk;
  String? haveCr;
  String? crDocumentID;
  String? documentNumber;
  String? fname;
  String? lname;
  String? email;
  String? mobile;
  String? image;
  Address? address;
  String? address1;
  String? address2;
  String? poBox;
  String? mblExtension;
  String? website;
  String? noOfStaff;
  String? companyID;
  String? district;
  String? buildingNo;
  String? additionalNumber;
  String? otherLandline;
  String? unitNumber;
  String? qrCorde;
  String? emailVerifiedAt;
  String? code;
  String? verificationCode;
  String? crNumber;
  String? crActivity;
  String? companyNameEng;
  String? companyNameArabic;
  String? bussinessActivity;
  String? membershipType;
  String? memberCategory;
  String? otherProducts;
  String? gpc;
  String? productAddons;
  String? total;
  String? contactPerson;
  String? companyLandLine;
  String? documents;
  String? addressImage;
  String? status;
  String? paymentType;
  String? paymentStatus;
  String? onlinePayment;
  String? parentMemberID;
  String? memberType;
  String? invoiceFile;
  String? otpStatus;
  String? transactionId;
  String? createdAt;
  String? updatedAt;
  String? gcpGLNID;
  String? gln;
  String? gcpType;
  String? deletedAt;
  String? gcpExpiry;
  String? memberID;
  String? userId;
  String? membershipCategory;
  String? remarks;
  String? upgradationDisc;
  String? upgradationDiscAmount;
  String? renewalDisc;
  String? renewalDiscAmount;
  String? membershipOtherCategory;
  String? activityID;
  String? assignTo;

  User(
      {this.id,
      this.userType,
      this.slug,
      this.locationUk,
      this.haveCr,
      this.crDocumentID,
      this.documentNumber,
      this.fname,
      this.lname,
      this.email,
      this.mobile,
      this.image,
      this.address,
      this.address1,
      this.address2,
      this.poBox,
      this.mblExtension,
      this.website,
      this.noOfStaff,
      this.companyID,
      this.district,
      this.buildingNo,
      this.additionalNumber,
      this.otherLandline,
      this.unitNumber,
      this.qrCorde,
      this.emailVerifiedAt,
      this.code,
      this.verificationCode,
      this.crNumber,
      this.crActivity,
      this.companyNameEng,
      this.companyNameArabic,
      this.bussinessActivity,
      this.membershipType,
      this.memberCategory,
      this.otherProducts,
      this.gpc,
      this.productAddons,
      this.total,
      this.contactPerson,
      this.companyLandLine,
      this.documents,
      this.addressImage,
      this.status,
      this.paymentType,
      this.paymentStatus,
      this.onlinePayment,
      this.parentMemberID,
      this.memberType,
      this.invoiceFile,
      this.otpStatus,
      this.transactionId,
      this.createdAt,
      this.updatedAt,
      this.gcpGLNID,
      this.gln,
      this.gcpType,
      this.deletedAt,
      this.gcpExpiry,
      this.memberID,
      this.userId,
      this.membershipCategory,
      this.remarks,
      this.upgradationDisc,
      this.upgradationDiscAmount,
      this.renewalDisc,
      this.renewalDiscAmount,
      this.membershipOtherCategory,
      this.activityID,
      this.assignTo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    slug = json['slug'];
    locationUk = json['location_uk'];
    haveCr = json['have_cr'];
    crDocumentID = json['cr_documentID'];
    documentNumber = json['document_number'];
    fname = json['fname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    address1 = json['address1'];
    address2 = json['address2'];
    poBox = json['po_box'];
    mblExtension = json['mbl_extension'];
    website = json['website'];
    noOfStaff = json['no_of_staff'];
    companyID = json['companyID'];
    district = json['district'];
    buildingNo = json['building_no'];
    additionalNumber = json['additional_number'];
    otherLandline = json['other_landline'];
    unitNumber = json['unit_number'];
    qrCorde = json['qr_corde'];
    emailVerifiedAt = json['email_verified_at'];
    code = json['code'];
    verificationCode = json['verification_code'];
    crNumber = json['cr_number'];
    crActivity = json['cr_activity'];
    companyNameEng = json['company_name_eng'];
    companyNameArabic = json['company_name_arabic'];
    bussinessActivity = json['bussiness_activity'];
    membershipType = json['membership_type'];
    memberCategory = json['member_category'];
    otherProducts = json['other_products'];
    gpc = json['gpc'];
    productAddons = json['product_addons'];
    total = json['total'];
    contactPerson = json['contactPerson'];
    companyLandLine = json['companyLandLine'];
    documents = json['documents'];
    addressImage = json['address_image'];
    status = json['status'];
    paymentType = json['payment_type'];
    paymentStatus = json['payment_status'];
    onlinePayment = json['online_payment'];
    parentMemberID = json['parent_memberID'];
    memberType = json['member_type'];
    invoiceFile = json['invoice_file'];
    otpStatus = json['otp_status'];
    transactionId = json['transaction_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gcpGLNID = json['gcpGLNID'];
    gln = json['gln'];
    gcpType = json['gcp_type'];
    deletedAt = json['deleted_at'];
    gcpExpiry = json['gcp_expiry'];
    memberID = json['memberID'];
    userId = json['user_id'];
    membershipCategory = json['membership_category'];
    remarks = json['remarks'];
    upgradationDisc = json['upgradation_disc'];
    upgradationDiscAmount = json['upgradation_disc_amount'];
    renewalDisc = json['renewal_disc'];
    renewalDiscAmount = json['renewal_disc_amount'];
    membershipOtherCategory = json['membership_otherCategory'];
    activityID = json['activityID'];
    assignTo = json['assign_to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['slug'] = slug;
    data['location_uk'] = locationUk;
    data['have_cr'] = haveCr;
    data['cr_documentID'] = crDocumentID;
    data['document_number'] = documentNumber;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['mobile'] = mobile;
    data['image'] = image;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['address1'] = address1;
    data['address2'] = address2;
    data['po_box'] = poBox;
    data['mbl_extension'] = mblExtension;
    data['website'] = website;
    data['no_of_staff'] = noOfStaff;
    data['companyID'] = companyID;
    data['district'] = district;
    data['building_no'] = buildingNo;
    data['additional_number'] = additionalNumber;
    data['other_landline'] = otherLandline;
    data['unit_number'] = unitNumber;
    data['qr_corde'] = qrCorde;
    data['email_verified_at'] = emailVerifiedAt;
    data['code'] = code;
    data['verification_code'] = verificationCode;
    data['cr_number'] = crNumber;
    data['cr_activity'] = crActivity;
    data['company_name_eng'] = companyNameEng;
    data['company_name_arabic'] = companyNameArabic;
    data['bussiness_activity'] = bussinessActivity;
    data['membership_type'] = membershipType;
    data['member_category'] = memberCategory;
    data['other_products'] = otherProducts;
    data['gpc'] = gpc;
    data['product_addons'] = productAddons;
    data['total'] = total;
    data['contactPerson'] = contactPerson;
    data['companyLandLine'] = companyLandLine;
    data['documents'] = documents;
    data['address_image'] = addressImage;
    data['status'] = status;
    data['payment_type'] = paymentType;
    data['payment_status'] = paymentStatus;
    data['online_payment'] = onlinePayment;
    data['parent_memberID'] = parentMemberID;
    data['member_type'] = memberType;
    data['invoice_file'] = invoiceFile;
    data['otp_status'] = otpStatus;
    data['transaction_id'] = transactionId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['gcpGLNID'] = gcpGLNID;
    data['gln'] = gln;
    data['gcp_type'] = gcpType;
    data['deleted_at'] = deletedAt;
    data['gcp_expiry'] = gcpExpiry;
    data['memberID'] = memberID;
    data['user_id'] = userId;
    data['membership_category'] = membershipCategory;
    data['remarks'] = remarks;
    data['upgradation_disc'] = upgradationDisc;
    data['upgradation_disc_amount'] = upgradationDiscAmount;
    data['renewal_disc'] = renewalDisc;
    data['renewal_disc_amount'] = renewalDiscAmount;
    data['membership_otherCategory'] = membershipOtherCategory;
    data['activityID'] = activityID;
    data['assign_to'] = assignTo;
    return data;
  }
}

class Address {
  String? countryName;
  String? countryShortName;
  String? cityName;
  String? stateName;
  String? zip;
  String? address;

  Address(
      {this.countryName,
      this.countryShortName,
      this.cityName,
      this.stateName,
      this.zip,
      this.address});

  Address.fromJson(Map<String, dynamic> json) {
    countryName = json['countryName'];
    countryShortName = json['country_shortName'];
    cityName = json['cityName'];
    stateName = json['stateName'];
    zip = json['zip'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countryName'] = countryName;
    data['country_shortName'] = countryShortName;
    data['cityName'] = cityName;
    data['stateName'] = stateName;
    data['zip'] = zip;
    data['address'] = address;
    return data;
  }
}

class MemberCategory {
  String? memberCategoryDescription;
  String? totalNoOfBarcodes;

  MemberCategory({this.memberCategoryDescription, this.totalNoOfBarcodes});

  MemberCategory.fromJson(Map<String, dynamic> json) {
    memberCategoryDescription = json['member_category_description'];
    totalNoOfBarcodes = json['total_no_of_barcodes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['member_category_description'] = memberCategoryDescription;
    data['total_no_of_barcodes'] = totalNoOfBarcodes;
    return data;
  }
}
