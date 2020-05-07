import 'package:shared_preferences/shared_preferences.dart';

class SharedDatabase {
  //--------------------- COACHING DATA ---------------------------------------
  isVerifiedData(String userId, String userType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('id', userId);
    prefs.setString('type', userType);
  }

  setCoachingData(
      String userUid,
      String userId,
      String batchId,
      String admissionDate,
      String yearId,
      String userType,
      String coachingId,
      String status,
      String coachingName,
      String classID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('uid', userUid);
    prefs.setString('id', userId);
    prefs.setString('batchid', batchId);
    prefs.setString('date', admissionDate);
    prefs.setString('year', yearId);
    prefs.setString('type', userType);
    prefs.setString('cid', coachingId);
    prefs.setString('status', status);
    prefs.setString('coachingname', coachingName);
    prefs.setString('class', classID);
  }

  Future<String> getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('uid');
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('id');
  }

  Future<String> getBatchID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('batchid');
  }

  Future<String> getAdmissionDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('date');
  }

  Future<String> getYearID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('year');
  }

  Future<String> getTypeID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('type');
  }

  Future<String> getCoachingID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('cid');
  }

  Future<String> getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('status');
  }

  Future<String> getCoachingName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('coachingname');
  }

  Future<String> getClassID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('class');
  }
  setLocationID(String locationID) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', locationID);
  }
  Future<String> getLocationID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('location');
  }
  //--------------------USER DATA STORAGE---------------------------------
  setUserData(
      String username,
      String mobile,
      String address,
      String birth,
      String gender,
      String father_name,
      String image,
      String school_subject,
      String parents_experience,
      String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('username', username);
    prefs.setString('mobile', mobile);
    prefs.setString('address', address);
    prefs.setString('birth', birth);
    prefs.setString('gender', gender);
    prefs.setString('father_name', father_name);
    prefs.setString('image', image);
    prefs.setString('school_subject', school_subject);
    prefs.setString('parents_experience', parents_experience);
    prefs.setString('token', token);
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('username');
  }

  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mobile');
  }

  Future<String> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('address');
  }

  Future<String> getBirth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('birth');
  }

  Future<String> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('gender');
  }

  Future<String> getFatherName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('father_name');
  }

  Future<String> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('image');
  }

  Future<String> getSchoolSubject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('school_subject');
  }

  Future<String> getParentsExperience() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('parents_experience');
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('token');
  }

//------------------COACHING ADMIN DATA SET------------------------------------
  setAdminData(String id, String expired_at, String name, String userType,
      String yearId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('type', userType);
    prefs.setString('year', yearId);
    prefs.setString('cid', id);
    prefs.setString('expired_at', expired_at);
    prefs.setString('coachingname', name);
  }

  Future<String> getAdminExpiredDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('expired_at');
  }

  //-----------LOGIN VALUE DATABASE STORING-----------------------------
  setLogin(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', value);
  }

  Future<bool> getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('isLogin');
  }

  setVerified(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isVerify', value);
  }

  Future<bool> getVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getBool('isVerify');
  }

  userLogout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
