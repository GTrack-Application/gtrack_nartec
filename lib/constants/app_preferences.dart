import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // Setters

  // gs1 prefix
  static Future<void> setGs1Prefix(String gs1Prefix) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gs1Prefix', gs1Prefix);
  }

  static Future<void> userName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', userName);
  }

  static Future<void> setUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userEmail', userEmail);
  }

  static Future<void> setNfcEnabled(bool nfcEnabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('nfcEnabled', nfcEnabled);
  }

  static Future<void> setNfcSearchToken(String nfcSearchToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nfcSearchToken', nfcSearchToken);
  }

  /*  Set user id  */
  static Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  static Future<void> setMemberId(String memberId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('member_id', memberId);
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

  /* set gs1 user id */
  static Future<void> setGs1UserId(String gs1UserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gs1UserId', gs1UserId);
  }

  // Getters...

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  static Future<bool?> getNfcEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('nfcEnabled');
  }

  /* get gs1 prefix */
  static Future<String?> getGs1Prefix() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gs1Prefix');
  }

  /*  Get user id  */
  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<String?> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('member_id');
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

  /* get gs1 user id */
  static Future<String?> getGs1UserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('gs1UserId');
  }

  static Future<String?> getNfcSearchToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nfcSearchToken');
  }
}
