class AllergenModel {
  String? id;
  String? productName;
  String? ingredient;
  String? quantity;
  String? unit;
  String? barcode;
  String? lotNumber;
  String? productionDate;
  String? expirationDate;
  String? allergenName;
  String? allergenType;
  String? severity;
  bool? containsAllergen;
  bool? mayContain;
  bool? crossContaminationRisk;
  String? allergenSource;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? brandOwnerId;
  String? lastModifiedBy;
  String? domainName;

  AllergenModel(
      {this.id,
      this.productName,
      this.ingredient,
      this.quantity,
      this.unit,
      this.barcode,
      this.lotNumber,
      this.productionDate,
      this.expirationDate,
      this.allergenName,
      this.allergenType,
      this.severity,
      this.containsAllergen,
      this.mayContain,
      this.crossContaminationRisk,
      this.allergenSource,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.brandOwnerId,
      this.lastModifiedBy,
      this.domainName});

  AllergenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    ingredient = json['ingredient'];
    quantity = json['quantity'];
    unit = json['unit'];
    barcode = json['barcode'];
    lotNumber = json['lot_number'];
    productionDate = json['production_date'];
    expirationDate = json['expiration_date'];
    allergenName = json['allergen_name'];
    allergenType = json['allergen_type'];
    severity = json['severity'];
    containsAllergen = json['contains_allergen'];
    mayContain = json['may_contain'];
    crossContaminationRisk = json['cross_contamination_risk'];
    allergenSource = json['allergen_source'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    brandOwnerId = json['brand_owner_id'];
    lastModifiedBy = json['last_modified_by'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['ingredient'] = ingredient;
    data['quantity'] = quantity;
    data['unit'] = unit;
    data['barcode'] = barcode;
    data['lot_number'] = lotNumber;
    data['production_date'] = productionDate;
    data['expiration_date'] = expirationDate;
    data['allergen_name'] = allergenName;
    data['allergen_type'] = allergenType;
    data['severity'] = severity;
    data['contains_allergen'] = containsAllergen;
    data['may_contain'] = mayContain;
    data['cross_contamination_risk'] = crossContaminationRisk;
    data['allergen_source'] = allergenSource;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['brand_owner_id'] = brandOwnerId;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    return data;
  }
}
