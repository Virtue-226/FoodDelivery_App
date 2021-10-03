import 'package:fooddelivery_app/src/enum/auth_mode.dart';
import 'package:fooddelivery_app/src/models/food_model.dart';
import 'package:fooddelivery_app/src/models/user_info_model.dart';
import 'package:fooddelivery_app/src/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends Model {
  List<User> _users = [];
  List<UserInfo> _userInfos = [];
  User _authenticateUser;
  UserInfo _authenticatedUserInfo;
  bool _isLoading = false;
 


  List<User> get users {
    return List.from(_users);
  }

  List<UserInfo> get userinfos {
    return List.from(_userInfos);
  }

  User get authenticateUser {
    return _authenticateUser;
  }

  UserInfo get authenticatedUserInfo {
    return _authenticatedUserInfo;
  }

  bool get isloading {
    return _isLoading;
  }

  //Fetch user information

  Future<bool> fetchedUserInfo() async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response = await http.get(Uri.parse(
          "https://foodey3-e0880-default-rtdb.firebaseio.com/users.json"));

      final Map<String, dynamic> fetchedData = json.decode(response.body);
      // print(fetchedData);
      final List<UserInfo> userInfos = [];
      fetchedData.forEach((String id, dynamic userInfoData) {
        UserInfo userInfo = UserInfo(
          id: id,
          email: userInfoData['email'],
          userId: userInfoData['localId'],
          userType: userInfoData['userType'],
          username: userInfoData['username'],
        );
        userInfos.add(userInfo);
      });

      _userInfos = userInfos;
      _isLoading = false;
      notifyListeners();
      return Future.value(true);
    } catch (error) {
      print("The error : $error");
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  //add user information

  Future<bool> addUserInfo(Map<String, dynamic> userInfo) async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response response = await http.post(
          Uri.parse(
              "https://foodey3-e0880-default-rtdb.firebaseio.com/users.json"),
          body: json.encode(userInfo));
      // print(response);
      final Map<String, dynamic> responseData = json.decode(response.body);

      UserInfo userInfoWithID = UserInfo(
        id: responseData['name'],
        email: userInfo['email'],
        // firstname: userInfo['firstname'],
        // lastname: userInfo['lastname'],
        // phoneNumber: userInfo['phoneNumber'],
        // token: userInfo["userType"],
        username: userInfo["username"],
      );

      _userInfos.add(userInfoWithID);
      _isLoading = false;
      notifyListeners();

      return Future.value(true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return Future.value(false);
    }
  }

  //get user information

  Future<UserInfo> getUserInfo(String userId) async {
    final bool response = await fetchedUserInfo();
    UserInfo foundUserInfo;

    if (response) {
      for (int i = 0; i < _userInfos.length; i++) {
        if (_userInfos[i].userId == userId) {
          foundUserInfo = _userInfos[i];
          break;
        }
      }
    }
    return Future.value(foundUserInfo);
  }

  //get user details from firebase

  UserInfo getUserDetails(String userId) {
    fetchedUserInfo();

    UserInfo foundUserInfo;

    for (int i = 0; i < _userInfos.length; i++) {
      if (_userInfos[i].userId == userId) {
        foundUserInfo = _userInfos[i];
        break;
      }
    }
    return foundUserInfo;
  }

  //The authenticate Method
  Future<Map<String, dynamic>> authenticate(String email, String password,
      {AuthMode authmode = AuthMode.SignIn,
      Map<String, dynamic> userInfo}) async {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> authData = {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };

    String message;
    bool hasError = false;
    try {
      http.Response response;
      if (authmode == AuthMode.SignUp) {
        response = await http.post(
          Uri.parse(
              "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBPKnl-oIiSVTcYuaInH7vymuPQFVWlWWY"),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
        // addUserInfo(userInfo);
      } else if (authmode == AuthMode.SignIn) {
        response = await http.post(
          Uri.parse(
              "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBPKnl-oIiSVTcYuaInH7vymuPQFVWlWWY"),
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'},
        );
      }

      Map<String, dynamic> responsebody = json.decode(response.body);
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      if (responsebody.containsKey("idToken")) {
        _authenticateUser = User(
          id: responsebody['localId'],
          email: responsebody['email'],
          token: responsebody['idToken'],
          // userType: 'customer',
        );

        if (authmode == AuthMode.SignIn) {
          _authenticatedUserInfo = await getUserInfo(responsebody['localId']);

          // prefs.setString("username", _authenticatedUserInfo.username);
          // prefs.setString("email", _authenticatedUserInfo.email);
          // prefs.setString("userType", _authenticatedUserInfo.userType);

          message = "Sign in Successfully";
        } else if (authmode == AuthMode.SignUp) {
          userInfo['localId'] = responsebody['localId'];
          addUserInfo(userInfo);

          // prefs.setString("username", userInfo['username']);
          // prefs.setString("email", userInfo['email']);
          // prefs.setString("userType", userInfo['userType']);

          message = "Sign Up Successfully";
        }
        // prefs.setString("token", responsebody['idToken']);
        // prefs.setString("token", responsebody['expiresIn']);
      } else {
        hasError = true;

        if (responsebody['error']['message'] == 'EMAIL_EXISTS') {
          message = 'Email already exist';
        } else if (responsebody['error']['message'] == 'EMAIL_NOT FOUND') {
          message = 'Email or password does not exist';
        } else if (responsebody['error']['message'] == 'INVALID_PASSWORD') {
          message = 'Password is incorrect';
          // print("response body $responsebody");
        }
      }
      _isLoading = false;
      notifyListeners();
      return {'message': message, 'hasError': hasError};
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return {
        'message': "Failed to sign up successfully",
        'hasError': !hasError,
      };
    }
  }

  // void autoLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String token = prefs.getString("token");
  //   if (token != null) {
  //     _authenticateUser = null;
  //     _authenticatedUserInfo = null;
  //     notifyListeners();
  //   }
  // }

  //Logout method

  

  
  void logout() {
    _authenticateUser = null;
    _authenticatedUserInfo = null;
  }
}
