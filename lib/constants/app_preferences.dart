import 'package:nb_utils/nb_utils.dart';

class AppPreferences {
  // Setters

  /*  Set user id  */
  static Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  /* set gpc */
  static Future<void> setGcp(String gcp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gcp', gcp);
  }

  /* set member category description */
  static Future<void> setMemberCategoryDescription(
      String memberCategoryDescription) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('memberCategoryDescription', memberCategoryDescription);
  }

  // Getters

  /*  Get user id  */
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  /* Get gcp */
  static Future<String?> getGcp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gcp');
  }

  /* get member category description */
  static Future<String?> getMemberCategoryDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('memberCategoryDescription');
  }
}
