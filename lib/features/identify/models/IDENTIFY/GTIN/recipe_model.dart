class RecipeModel {
  final int id;
  final String? logo;
  final String title;
  final String description;
  final String ingredients;
  final String linkType;
  final String gtin;
  final dynamic companyId;

  RecipeModel({
    required this.id,
    this.logo,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.linkType,
    required this.gtin,
    this.companyId,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['ID'],
      logo: json['logo'],
      title: json['title'],
      description: json['description'],
      ingredients: json['ingredients'],
      linkType: json['LinkType'],
      gtin: json['GTIN'],
      companyId: json['companyId'],
    );
  }
}

class RecipeResponse {
  final List<RecipeModel> recipes;
  final int totalPages;

  RecipeResponse({
    required this.recipes,
    required this.totalPages,
  });

  factory RecipeResponse.fromJson(List<dynamic> json) {
    final recipes = json.map((e) => RecipeModel.fromJson(e)).toList();
    return RecipeResponse(
      recipes: recipes,
      totalPages: 1, // Since pagination isn't implemented in the API yet
    );
  }
}
