class GlnModel {
  final String id;
  final String? productId;
  final String? referenceId;
  final String locationNameEn;
  final String locationNameAr;
  final String addressEn;
  final String addressAr;
  final String? pobox;
  final String? postalCode;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String? licenceNo;
  final String? locationCRNumber;
  final String? officeTel;
  final String? telExtension;
  final String? officeFax;
  final String? faxExtension;
  final String? contact1Name;
  final String? contact1Email;
  final String? contact1Mobile;
  final String? contact2Name;
  final String? contact2Email;
  final String? contact2Mobile;
  final String longitude;
  final String latitude;
  final String? image;
  final String glnBarcodeNumber;
  final String? glnBarcodeNumberWithoutCheck;
  final String status;
  final String userId;
  final String createdAt;
  final String updatedAt;
  final String gcpGLNID;
  final String? deletedAt;
  final String? adminId;
  final String? glnIdenfication;
  final String? physicalLocation;

  GlnModel({
    required this.id,
    this.productId,
    this.referenceId,
    required this.locationNameEn,
    required this.locationNameAr,
    required this.addressEn,
    required this.addressAr,
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
    required this.longitude,
    required this.latitude,
    this.image,
    required this.glnBarcodeNumber,
    this.glnBarcodeNumberWithoutCheck,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.gcpGLNID,
    this.deletedAt,
    this.adminId,
    this.glnIdenfication,
    this.physicalLocation,
  });

  factory GlnModel.fromJson(Map<String, dynamic> json) {
    return GlnModel(
      id: json['id'] ?? '',
      productId: json['product_id'],
      referenceId: json['reference_id'],
      locationNameEn: json['locationNameEn'] ?? '',
      locationNameAr: json['locationNameAr'] ?? '',
      addressEn: json['AddressEn'] ?? '',
      addressAr: json['AddressAr'] ?? '',
      pobox: json['pobox'],
      postalCode: json['postal_code'],
      countryId: json['country_id'],
      stateId: json['state_id'],
      cityId: json['city_id'],
      licenceNo: json['licence_no'],
      locationCRNumber: json['locationCRNumber'],
      officeTel: json['office_tel'],
      telExtension: json['tel_extension'],
      officeFax: json['office_fax'],
      faxExtension: json['fax_extension'],
      contact1Name: json['contact1Name'],
      contact1Email: json['contact1Email'],
      contact1Mobile: json['contact1Mobile'],
      contact2Name: json['contact2Name'],
      contact2Email: json['contact2Email'],
      contact2Mobile: json['contact2Mobile'],
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      image: json['image'],
      glnBarcodeNumber: json['GLNBarcodeNumber'] ?? '',
      glnBarcodeNumberWithoutCheck: json['GLNBarcodeNumber_without_check'],
      status: json['status'] ?? '',
      userId: json['user_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      gcpGLNID: json['gcpGLNID'] ?? '',
      deletedAt: json['deleted_at'],
      adminId: json['admin_id'],
      glnIdenfication: json['gln_idenfication'],
      physicalLocation: json['physical_location'],
    );
  }
}
