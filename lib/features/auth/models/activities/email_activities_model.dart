class EmailActivitiesModel {
  String? activity;
  String? activityID;

  EmailActivitiesModel({this.activity, this.activityID});

  EmailActivitiesModel.fromJson(Map<String, dynamic> json) {
    activity = json['activity'];
    activityID = json['activityID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activity'] = activity;
    data['activityID'] = activityID;
    return data;
  }
}
