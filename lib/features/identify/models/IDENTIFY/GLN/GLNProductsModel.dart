// ignore_for_file: file_names

class GLNProductsModel {
  String? id;
  String? productId;
  String? referenceId;
  String? locationNameEn;
  String? locationNameAr;
  String? addressEn;
  String? addressAr;
  String? pobox;
  String? postalCode;
  String? countryId;
  String? stateId;
  String? cityId;
  String? licenceNo;
  String? locationCRNumber;
  String? officeTel;
  String? telExtension;
  String? officeFax;
  String? faxExtension;
  String? contact1Name;
  String? contact1Email;
  String? contact1Mobile;
  String? contact2Name;
  String? contact2Email;
  String? contact2Mobile;
  String? longitude;
  String? latitude;
  String? image;
  String? gLNBarcodeNumber;
  String? gLNBarcodeNumberWithoutCheck;
  String? status;
  String? userId;
  String? createdAt;
  String? updatedAt;
  String? gcpGLNID;
  String? deletedAt;
  String? adminId;
  String? glnIdenfication;
  String? physicalLocation;

  GLNProductsModel(
      {this.id,
      this.productId,
      this.referenceId,
      this.locationNameEn,
      this.locationNameAr,
      this.addressEn,
      this.addressAr,
      this.pobox,
      this.postalCode,
      this.countryId,
      this.stateId,
      this.cityId,
      this.licenceNo,
      this.locationCRNumber,
      this.officeTel,
      this.telExtension,
      this.officeFax,
      this.faxExtension,
      this.contact1Name,
      this.contact1Email,
      this.contact1Mobile,
      this.contact2Name,
      this.contact2Email,
      this.contact2Mobile,
      this.longitude,
      this.latitude,
      this.image,
      this.gLNBarcodeNumber,
      this.gLNBarcodeNumberWithoutCheck,
      this.status,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.gcpGLNID,
      this.deletedAt,
      this.adminId,
      this.glnIdenfication,
      this.physicalLocation});

  GLNProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    referenceId = json['reference_id'];
    locationNameEn = json['locationNameEn'];
    locationNameAr = json['locationNameAr'];
    addressEn = json['AddressEn'];
    addressAr = json['AddressAr'];
    pobox = json['pobox'];
    postalCode = json['postal_code'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    licenceNo = json['licence_no'];
    locationCRNumber = json['locationCRNumber'];
    officeTel = json['office_tel'];
    telExtension = json['tel_extension'];
    officeFax = json['office_fax'];
    faxExtension = json['fax_extension'];
    contact1Name = json['contact1Name'];
    contact1Email = json['contact1Email'];
    contact1Mobile = json['contact1Mobile'];
    contact2Name = json['contact2Name'];
    contact2Email = json['contact2Email'];
    contact2Mobile = json['contact2Mobile'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    image = json['image'];
    gLNBarcodeNumber = json['GLNBarcodeNumber'];
    gLNBarcodeNumberWithoutCheck = json['GLNBarcodeNumber_without_check'];
    status = json['status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    gcpGLNID = json['gcpGLNID'];
    deletedAt = json['deleted_at'];
    adminId = json['admin_id'];
    glnIdenfication = json['gln_idenfication'];
    physicalLocation = json['physical_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['reference_id'] = referenceId;
    data['locationNameEn'] = locationNameEn;
    data['locationNameAr'] = locationNameAr;
    data['AddressEn'] = addressEn;
    data['AddressAr'] = addressAr;
    data['pobox'] = pobox;
    data['postal_code'] = postalCode;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['licence_no'] = licenceNo;
    data['locationCRNumber'] = locationCRNumber;
    data['office_tel'] = officeTel;
    data['tel_extension'] = telExtension;
    data['office_fax'] = officeFax;
    data['fax_extension'] = faxExtension;
    data['contact1Name'] = contact1Name;
    data['contact1Email'] = contact1Email;
    data['contact1Mobile'] = contact1Mobile;
    data['contact2Name'] = contact2Name;
    data['contact2Email'] = contact2Email;
    data['contact2Mobile'] = contact2Mobile;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['image'] = image;
    data['GLNBarcodeNumber'] = gLNBarcodeNumber;
    data['GLNBarcodeNumber_without_check'] = gLNBarcodeNumberWithoutCheck;
    data['status'] = status;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['gcpGLNID'] = gcpGLNID;
    data['deleted_at'] = deletedAt;
    data['admin_id'] = adminId;
    data['gln_idenfication'] = glnIdenfication;
    data['physical_location'] = physicalLocation;
    return data;
  }
}
