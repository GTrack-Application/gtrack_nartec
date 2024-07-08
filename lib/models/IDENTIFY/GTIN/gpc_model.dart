class GPCModel {
  String? pageContent;
  Metadata? metadata;

  GPCModel({this.pageContent, this.metadata});

  GPCModel.fromJson(Map<String, dynamic> json) {
    pageContent = json['pageContent'];
    metadata =
        json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pageContent'] = pageContent;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  int? id;
  double? createdAt;
  double? updatedAt;
  int? bricksCode;
  String? arabicTitle;
  String? bricksTitle;
  String? bricksDefinitionExcludes;
  String? bricksDefinitionIncludes;

  Metadata(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.bricksCode,
      this.arabicTitle,
      this.bricksTitle,
      this.bricksDefinitionExcludes,
      this.bricksDefinitionIncludes});

  Metadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bricksCode = json['bricks_code'];
    arabicTitle = json['arabic title'];
    bricksTitle = json['bricks_title'];
    bricksDefinitionExcludes = json['bricks_definition_excludes'];
    bricksDefinitionIncludes = json['bricks_definition_includes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['bricks_code'] = bricksCode;
    data['arabic title'] = arabicTitle;
    data['bricks_title'] = bricksTitle;
    data['bricks_definition_excludes'] = bricksDefinitionExcludes;
    data['bricks_definition_includes'] = bricksDefinitionIncludes;
    return data;
  }
}
