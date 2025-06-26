class PackagingModel {
  String? id;
  String? status;
  String? barcode;
  String? packagingType;
  String? material;
  String? dimensions;
  String? weight;
  String? capacity;
  bool? recyclable;
  bool? biodegradable;
  String? packagingSupplier;
  String? costPerUnit;
  String? color;
  String? labeling;
  String? brandOwnerId;
  String? createdAt;
  String? updatedAt;
  List<String>? images;
  String? lastModifiedBy;
  String? domainName;

  PackagingModel({
    this.id,
    this.status,
    this.barcode,
    this.packagingType,
    this.material,
    this.dimensions,
    this.weight,
    this.capacity,
    this.recyclable,
    this.biodegradable,
    this.packagingSupplier,
    this.costPerUnit,
    this.color,
    this.labeling,
    this.brandOwnerId,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.lastModifiedBy,
    this.domainName,
  });

  PackagingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    status = json['status'].toString();
    barcode = json['barcode'].toString();
    packagingType = json['packaging_type'].toString();
    material = json['material'].toString();
    dimensions = json['dimensions'].toString();
    weight = json['weight'].toString();
    capacity = json['capacity'].toString();
    recyclable = json['recyclable'];
    biodegradable = json['biodegradable'];
    packagingSupplier = json['packaging_supplier'].toString();
    costPerUnit = json['cost_per_unit'].toString();
    color = json['color'].toString();
    labeling = json['labeling'].toString();
    brandOwnerId = json['brand_owner_id'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    images = json['images'].cast<String>();
    lastModifiedBy = json['last_modified_by'].toString();
    domainName = json['domainName'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['barcode'] = barcode;
    data['packaging_type'] = packagingType;
    data['material'] = material;
    data['dimensions'] = dimensions;
    data['weight'] = weight;
    data['capacity'] = capacity;
    data['recyclable'] = recyclable;
    data['biodegradable'] = biodegradable;
    data['packaging_supplier'] = packagingSupplier;
    data['cost_per_unit'] = costPerUnit;
    data['color'] = color;
    data['labeling'] = labeling;
    data['brand_owner_id'] = brandOwnerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['images'] = images;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    return data;
  }
}
