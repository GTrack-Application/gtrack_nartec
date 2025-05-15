class NutritionFactsModel {
  String? id;
  String? barcode;
  String? servingPerPackage;
  String? servingSize;
  String? amountPerServing;
  String? calories;
  String? dailyValue;
  String? totalFats;
  String? saturatedFats;
  String? monounsaturated;
  String? polyunsaturated;
  String? transFat;
  String? cholesterol;
  String? sodium;
  String? totalCarbohydrates;
  String? dietaryFibers;
  String? totalSugars;
  bool? containsAddedSugar;
  String? protein;
  String? remarks;
  String? brandOwnerId;
  String? createdAt;
  String? updatedAt;
  String? lastModifiedBy;
  String? domainName;

  NutritionFactsModel({
    this.id,
    this.barcode,
    this.servingPerPackage,
    this.servingSize,
    this.amountPerServing,
    this.calories,
    this.dailyValue,
    this.totalFats,
    this.saturatedFats,
    this.monounsaturated,
    this.polyunsaturated,
    this.transFat,
    this.cholesterol,
    this.sodium,
    this.totalCarbohydrates,
    this.dietaryFibers,
    this.totalSugars,
    this.containsAddedSugar,
    this.protein,
    this.remarks,
    this.brandOwnerId,
    this.createdAt,
    this.updatedAt,
    this.lastModifiedBy,
    this.domainName,
  });

  NutritionFactsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = json['barcode'];
    servingPerPackage = json['serving_per_package'];
    servingSize = json['serving_size'];
    amountPerServing = json['amount_per_serving'];
    calories = json['calories'];
    dailyValue = json['daily_value'];
    totalFats = json['total_fats'];
    saturatedFats = json['saturated_fats'];
    monounsaturated = json['monounsaturated'];
    polyunsaturated = json['polyunsaturated'];
    transFat = json['trans_fat'];
    cholesterol = json['cholesterol'];
    sodium = json['sodium'];
    totalCarbohydrates = json['total_carbohydrates'];
    dietaryFibers = json['dietary_fibers'];
    totalSugars = json['total_sugars'];
    containsAddedSugar = json['contains_added_sugar'];
    protein = json['protein'];
    remarks = json['remarks'];
    brandOwnerId = json['brand_owner_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    lastModifiedBy = json['last_modified_by'];
    domainName = json['domainName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['barcode'] = barcode;
    data['serving_per_package'] = servingPerPackage;
    data['serving_size'] = servingSize;
    data['amount_per_serving'] = amountPerServing;
    data['calories'] = calories;
    data['daily_value'] = dailyValue;
    data['total_fats'] = totalFats;
    data['saturated_fats'] = saturatedFats;
    data['monounsaturated'] = monounsaturated;
    data['polyunsaturated'] = polyunsaturated;
    data['trans_fat'] = transFat;
    data['cholesterol'] = cholesterol;
    data['sodium'] = sodium;
    data['total_carbohydrates'] = totalCarbohydrates;
    data['dietary_fibers'] = dietaryFibers;
    data['total_sugars'] = totalSugars;
    data['contains_added_sugar'] = containsAddedSugar;
    data['protein'] = protein;
    data['remarks'] = remarks;
    data['brand_owner_id'] = brandOwnerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['last_modified_by'] = lastModifiedBy;
    data['domainName'] = domainName;
    return data;
  }
}
