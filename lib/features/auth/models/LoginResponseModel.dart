// ignore_for_file: file_names

class LoginResponseModel {
  bool? success;
  MemberData? memberData;
  String? token;

  LoginResponseModel({this.success, this.memberData, this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    memberData = json['memberData'] != null
        ? MemberData.fromJson(json['memberData'])
        : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (memberData != null) {
      data['memberData'] = memberData!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class MemberData {
  String? id;
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
  String? verificationCode;
  String? crNumber;
  String? crActivity;
  String? companyNameEng;
  String? companyNameArabic;
  String? bussinessActivity;
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
  String? rememberToken;
  String? parentMemberID;
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
  String? remarks;
  String? assignTo;
  String? membershipCategory;
  String? upgradationDisc;
  String? upgradationDiscAmount;
  String? renewalDisc;
  String? renewalDiscAmount;
  String? membershipOtherCategory;
  String? activityID;
  String? registrationType;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  String? oldMemberRecheck;
  String? isLogin;
  String? membershipCategoryId;
  String? industryTypes;
  String? isproductApproved;
  String? pendingInvoices;
  String? memberType;
  String? gepirPosted;
  String? apiKey;
  List<Carts>? carts;

  MemberData({
    this.id,
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
    this.verificationCode,
    this.crNumber,
    this.crActivity,
    this.companyNameEng,
    this.companyNameArabic,
    this.bussinessActivity,
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
    this.rememberToken,
    this.parentMemberID,
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
    this.remarks,
    this.assignTo,
    this.membershipCategory,
    this.upgradationDisc,
    this.upgradationDiscAmount,
    this.renewalDisc,
    this.renewalDiscAmount,
    this.membershipOtherCategory,
    this.activityID,
    this.registrationType,
    this.city,
    this.country,
    this.state,
    this.zipCode,
    this.oldMemberRecheck,
    this.isLogin,
    this.membershipCategoryId,
    this.industryTypes,
    this.isproductApproved,
    this.pendingInvoices,
    this.memberType,
    this.gepirPosted,
    this.apiKey,
    this.carts,
  });

  MemberData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userType = json['user_type'].toString();
    slug = json['slug'].toString();
    locationUk = json['location_uk'].toString();
    haveCr = json['have_cr'].toString();
    crDocumentID = json['cr_documentID'].toString();
    documentNumber = json['document_number'].toString();
    fname = json['fname'].toString();
    lname = json['lname'].toString();
    email = json['email'].toString();
    mobile = json['mobile'].toString();
    image = json['image'].toString();
    poBox = json['po_box'].toString();
    mblExtension = json['mbl_extension'].toString();
    website = json['website'].toString();
    noOfStaff = json['no_of_staff'].toString();
    companyID = json['companyID'].toString();
    district = json['district'].toString();
    buildingNo = json['building_no'].toString();
    additionalNumber = json['additional_number'].toString();
    otherLandline = json['other_landline'].toString();
    unitNumber = json['unit_number'].toString();
    qrCorde = json['qr_corde'].toString();
    emailVerifiedAt = json['email_verified_at'].toString();
    verificationCode = json['verification_code'].toString();
    crNumber = json['cr_number'].toString();
    crActivity = json['cr_activity'].toString();
    companyNameEng = json['company_name_eng'].toString();
    companyNameArabic = json['company_name_arabic'].toString();
    bussinessActivity = json['bussiness_activity'].toString();
    memberCategory = json['member_category'].toString();
    otherProducts = json['other_products'].toString();
    gpc = json['gpc'].toString();
    productAddons = json['product_addons'].toString();
    total = json['total'].toString();
    contactPerson = json['contactPerson'].toString();
    companyLandLine = json['companyLandLine'].toString();
    documents = json['documents'].toString();
    addressImage = json['address_image'].toString();
    status = json['status'].toString();
    paymentType = json['payment_type'].toString();
    paymentStatus = json['payment_status'].toString();
    onlinePayment = json['online_payment'].toString();
    rememberToken = json['remember_token'].toString();
    parentMemberID = json['parent_memberID'].toString();
    invoiceFile = json['invoice_file'].toString();
    otpStatus = json['otp_status'].toString();
    transactionId = json['transaction_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    gcpGLNID = json['gcpGLNID'].toString();
    gln = json['gln'].toString();
    gcpType = json['gcp_type'].toString();
    deletedAt = json['deleted_at'].toString();
    gcpExpiry = json['gcp_expiry'].toString();
    memberID = json['memberID'].toString();
    userId = json['user_id'].toString();
    remarks = json['remarks'].toString();
    assignTo = json['assign_to'].toString();
    membershipCategory = json['membership_category'].toString();
    upgradationDisc = json['upgradation_disc'].toString();
    upgradationDiscAmount = json['upgradation_disc_amount'].toString();
    renewalDisc = json['renewal_disc'].toString();
    renewalDiscAmount = json['renewal_disc_amount'].toString();
    membershipOtherCategory = json['membership_otherCategory'].toString();
    activityID = json['activityID'].toString();
    registrationType = json['registration_type'].toString();
    city = json['city'].toString();
    country = json['country'].toString();
    state = json['state'].toString();
    zipCode = json['zip_code'].toString();
    oldMemberRecheck = json['old_member_recheck'].toString();
    isLogin = json['is_login'].toString();
    membershipCategoryId = json['membership_category_id'].toString();
    industryTypes = json['industryTypes'].toString();
    isproductApproved = json['isproductApproved'].toString();
    pendingInvoices = json['pending_invoices'].toString();
    memberType = json['member_type'].toString();
    gepirPosted = json['gepirPosted'].toString();
    apiKey = json['api_key'].toString();
    if (json['carts'] != null) {
      carts = <Carts>[];
      json['carts'].forEach((v) {
        carts!.add(Carts.fromJson(v));
      });
    }
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
    data['verification_code'] = verificationCode;
    data['cr_number'] = crNumber;
    data['cr_activity'] = crActivity;
    data['company_name_eng'] = companyNameEng;
    data['company_name_arabic'] = companyNameArabic;
    data['bussiness_activity'] = bussinessActivity;
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
    data['remember_token'] = rememberToken;
    data['parent_memberID'] = parentMemberID;
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
    data['remarks'] = remarks;
    data['assign_to'] = assignTo;
    data['membership_category'] = membershipCategory;
    data['upgradation_disc'] = upgradationDisc;
    data['upgradation_disc_amount'] = upgradationDiscAmount;
    data['renewal_disc'] = renewalDisc;
    data['renewal_disc_amount'] = renewalDiscAmount;
    data['membership_otherCategory'] = membershipOtherCategory;
    data['activityID'] = activityID;
    data['registration_type'] = registrationType;
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    data['zip_code'] = zipCode;
    data['old_member_recheck'] = oldMemberRecheck;
    data['is_login'] = isLogin;
    data['membership_category_id'] = membershipCategoryId;
    data['industryTypes'] = industryTypes;
    data['isproductApproved'] = isproductApproved;
    data['pending_invoices'] = pendingInvoices;
    data['member_type'] = memberType;
    data['gepirPosted'] = gepirPosted;
    data['api_key'] = apiKey;
    if (carts != null) {
      data['carts'] = carts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Carts {
  String? id;
  String? transactionId;
  String? cartItems;
  String? total;
  String? documents;
  String? requestType;
  String? paymentType;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? rejectReason;
  String? rejectBy;
  String? receipt;
  String? receiptPath;
  String? adminId;
  String? assignTo;
  String? discount;

  Carts({
    this.id,
    this.transactionId,
    this.cartItems,
    this.total,
    this.documents,
    this.requestType,
    this.paymentType,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.rejectReason,
    this.rejectBy,
    this.receipt,
    this.receiptPath,
    this.adminId,
    this.assignTo,
    this.discount,
  });

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    transactionId = json['transaction_id'].toString();
    cartItems = json['cart_items'].toString();
    total = json['total'].toString();
    documents = json['documents'].toString();
    requestType = json['request_type'].toString();
    paymentType = json['payment_type'].toString();
    userId = json['user_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    rejectReason = json['reject_reason'].toString();
    rejectBy = json['reject_by'].toString();
    receipt = json['receipt'].toString();
    receiptPath = json['receipt_path'].toString();
    adminId = json['admin_id'].toString();
    assignTo = json['assign_to'].toString();
    discount = json['discount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['cart_items'] = cartItems;
    data['total'] = total;
    data['documents'] = documents;
    data['request_type'] = requestType;
    data['payment_type'] = paymentType;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['reject_reason'] = rejectReason;
    data['reject_by'] = rejectBy;
    data['receipt'] = receipt;
    data['receipt_path'] = receiptPath;
    data['admin_id'] = adminId;
    data['assign_to'] = assignTo;
    data['discount'] = discount;
    return data;
  }
}
