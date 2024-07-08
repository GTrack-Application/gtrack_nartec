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

  /* set token */
  static Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  // normal user id
  static Future<void> setNormalUserId(String normalUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('normalUserId', normalUserId);
  }

  // current user
  static Future<void> setCurrentUser(String currentUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currentUser', currentUser);
  }

  // vendorId
  static Future<void> setVendorId(String vendorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('vendorId', vendorId);
  }

  // gcp_type
  static Future<void> setGcpType(String gcpType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gcp_type', gcpType);
  }

  // gln
  static Future<void> setGln(String gln) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gln', gln);
  }

  // id
  static Future<void> setId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
  }

  // gcp_gln_id
  static Future<void> setGcpGlnId(String gcpGlnId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gcpGLNID', gcpGlnId);
  }

  // Getters...

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

  /* get token */
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // normal user id
  static Future<String?> getNormalUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('normalUserId');
  }

  // current user
  static Future<String?> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  // vendorId
  static Future<String?> getVendorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('vendorId');
  }

  // gcp_type
  static Future<String?> getGcpType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gcp_type');
  }

  // gln
  static Future<String?> getGln() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gln');
  }

  // id
  static Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  // gcp_gln_id
  static Future<String?> getGcpGlnId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gcpGLNID');
  }
}
