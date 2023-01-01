import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User _user= User(token: "none");

  User get user => _user;
  Future<void> setUser(User user) async{
    _user = user;
    notifyListeners();
  }
  Future<bool> logoutUsers() async {
    if(Globals.isLoggedIn) {
      try {
        print(user.token);

        await AuthService().logOut(Globals.token);
        setUser(User(token: "none"));
        notifyListeners();
        print(user.token);
        bool setAdminLoggedIn=false;
        String admin_name="";
        String adminToken="";
        SharedPreferences pref = await SharedPreferences.getInstance();
        if(pref.getBool("admin_logged_in")!=null&&pref.getBool("admin_logged_in")==true)
          {
            setAdminLoggedIn=true;
            admin_name= pref.getString("admin_name")!;
            adminToken= pref.getString("admin_token")!;
          }


        await pref.clear();
        if(setAdminLoggedIn)
          {
            pref.setBool("admin_logged_in", true);
            pref.setString("admin_token", adminToken);
            pref.setString("admin_name", admin_name);
          }
        Globals.isLoggedIn = false;
        Globals.token = "none";
        return true;
      }
      catch (e) {
        print(e);
        return false;
      }
    }
    else{
      return false;
    }
  }
  Future<bool> updateUserInfo(String token, User userUpdated, [String? pass]) async {

    try {
      print(user.token);
      await AuthService().updateUserInfo(user.token!,userUpdated,pass);
      User tempUser= user;
      tempUser.nationality=userUpdated.nationality;
      tempUser.gender=userUpdated.gender;
      tempUser.birthDate=userUpdated.birthDate;
      tempUser.firstName=userUpdated.firstName;
      tempUser.lastName=userUpdated.lastName;
      await setUser(tempUser);

      return true;

    }
    catch(e)
    {
      print(e);
      return false;

    }
  }



}