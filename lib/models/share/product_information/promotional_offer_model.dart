class PromotionalOfferModel {
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

  PromotionalOfferModel(
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

  PromotionalOfferModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['linkType'] = linkType;
    data['language'] = language;
    data['context'] = context;
    data['mimeType'] = mimeType;
    data['linkTitle'] = linkTitle;
    data['targetUrl'] = targetUrl;
    data['defaultLinkType'] = defaultLinkType;
    data['defaultLanguage'] = defaultLanguage;
    data['defaultContext'] = defaultContext;
    data['defaultMimeType'] = defaultMimeType;
    data['fwqs'] = fwqs;
    data['public'] = public;
    return data;
  }
}
