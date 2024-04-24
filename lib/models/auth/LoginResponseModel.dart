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
  int? paymentStatus;
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
  int? upgradationDisc;
  int? upgradationDiscAmount;
  int? renewalDisc;
  int? renewalDiscAmount;
  String? membershipOtherCategory;
  int? activityID;
  String? registrationType;
  String? city;
  String? country;
  String? state;
  String? zipCode;
  int? oldMemberRecheck;
  int? isLogin;
  String? membershipCategoryId;
  String? industryTypes;
  int? isproductApproved;
  String? pendingInvoices;
  String? memberType;
  int? gepirPosted;
  String? apiKey;
  List<Carts>? carts;

  MemberData(
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
      this.carts});

  MemberData.fromJson(Map<String, dynamic> json) {
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
    verificationCode = json['verification_code'];
    crNumber = json['cr_number'];
    crActivity = json['cr_activity'];
    companyNameEng = json['company_name_eng'];
    companyNameArabic = json['company_name_arabic'];
    bussinessActivity = json['bussiness_activity'];
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
    rememberToken = json['remember_token'];
    parentMemberID = json['parent_memberID'];
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
    remarks = json['remarks'];
    assignTo = json['assign_to'];
    membershipCategory = json['membership_category'];
    upgradationDisc = json['upgradation_disc'];
    upgradationDiscAmount = json['upgradation_disc_amount'];
    renewalDisc = json['renewal_disc'];
    renewalDiscAmount = json['renewal_disc_amount'];
    membershipOtherCategory = json['membership_otherCategory'];
    activityID = json['activityID'];
    registrationType = json['registration_type'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
    zipCode = json['zip_code'];
    oldMemberRecheck = json['old_member_recheck'];
    isLogin = json['is_login'];
    membershipCategoryId = json['membership_category_id'];
    industryTypes = json['industryTypes'];
    isproductApproved = json['isproductApproved'];
    pendingInvoices = json['pending_invoices'];
    memberType = json['member_type'];
    gepirPosted = json['gepirPosted'];
    apiKey = json['api_key'];
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
  int? adminId;
  int? assignTo;
  int? discount;

  Carts(
      {this.id,
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
      this.discount});

  Carts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    cartItems = json['cart_items'];
    total = json['total'];
    documents = json['documents'];
    requestType = json['request_type'];
    paymentType = json['payment_type'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    rejectReason = json['reject_reason'];
    rejectBy = json['reject_by'];
    receipt = json['receipt'];
    receiptPath = json['receipt_path'];
    adminId = json['admin_id'];
    assignTo = json['assign_to'];
    discount = json['discount'];
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
