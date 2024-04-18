class ProductContentsModel {
  String? linkType;
  String? language;
  String? context;
  String? mimeType;
  String? linkTitle;
  String? targetUrl;
  bool? defaultLinkType;
  bool? defaultLanguage;
  bool? defaultContext;
  bool? defaultMimeType;
  bool? fwqs;
  bool? public;

  ProductContentsModel(
      {this.linkType,
      this.language,
      this.context,
      this.mimeType,
      this.linkTitle,
      this.targetUrl,
      this.defaultLinkType,
      this.defaultLanguage,
      this.defaultContext,
      this.defaultMimeType,
      this.fwqs,
      this.public});

  ProductContentsModel.fromJson(Map<String, dynamic> json) {
    linkType = json['linkType'];
    language = json['language'];
    context = json['context'];
    mimeType = json['mimeType'];
    linkTitle = json['linkTitle'];
    targetUrl = json['targetUrl'];
    defaultLinkType = json['defaultLinkType'];
    defaultLanguage = json['defaultLanguage'];
    defaultContext = json['defaultContext'];
    defaultMimeType = json['defaultMimeType'];
    fwqs = json['fwqs'];
    public = json['public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['linkType'] = this.linkType;
    data['language'] = this.language;
    data['context'] = this.context;
    data['mimeType'] = this.mimeType;
    data['linkTitle'] = this.linkTitle;
    data['targetUrl'] = this.targetUrl;
    data['defaultLinkType'] = this.defaultLinkType;
    data['defaultLanguage'] = this.defaultLanguage;
    data['defaultContext'] = this.defaultContext;
    data['defaultMimeType'] = this.defaultMimeType;
    data['fwqs'] = this.fwqs;
    data['public'] = this.public;
    return data;
  }
}
