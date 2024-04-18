class DigitalLinksModel {
  bool? success;
  int? count;
  List<Data>? data;

  DigitalLinksModel({this.success, this.count, this.data});

  DigitalLinksModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['count'] = count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? identificationKeyType;
  String? identificationKey;
  String? itemDescription;
  String? dateInserted;
  String? dateLastUpdated;
  String? qualifierPath;
  bool? public;
  List<Responses>? responses;

  Data(
      {this.identificationKeyType,
      this.identificationKey,
      this.itemDescription,
      this.dateInserted,
      this.dateLastUpdated,
      this.qualifierPath,
      this.public,
      this.responses});

  Data.fromJson(Map<String, dynamic> json) {
    identificationKeyType = json['identificationKeyType'];
    identificationKey = json['identificationKey'];
    itemDescription = json['itemDescription'];
    dateInserted = json['dateInserted'];
    dateLastUpdated = json['dateLastUpdated'];
    qualifierPath = json['qualifierPath'];
    public = json['public'];
    if (json['responses'] != null) {
      responses = <Responses>[];
      json['responses'].forEach((v) {
        responses!.add(Responses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identificationKeyType'] = identificationKeyType;
    data['identificationKey'] = identificationKey;
    data['itemDescription'] = itemDescription;
    data['dateInserted'] = dateInserted;
    data['dateLastUpdated'] = dateLastUpdated;
    data['qualifierPath'] = qualifierPath;
    data['public'] = public;
    if (responses != null) {
      data['responses'] = responses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Responses {
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

  Responses(
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

  Responses.fromJson(Map<String, dynamic> json) {
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
