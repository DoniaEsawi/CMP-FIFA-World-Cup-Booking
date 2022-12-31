import 'dart:convert';

import 'package:fifa2022/models/admin.dart';
import 'package:fifa2022/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminServices {
  final String _weirdConnection = '''
            {
              "meta": {
                        "status": "502",
                         "msg": "Weird Connection. Try Again?"
                      }
            }
        ''';

  final String _failed = '''
            {
              "meta": {
                        "status": "404",
                         "msg": "Failed to Connect to the server"
                      }
            }
        ''';
  /// When an error occur with any [Api] request
  http.Response errorFunction(
      final Object? error,
      final StackTrace stackTrace,
      ) {
    print(error.toString());
    if (error.toString().startsWith("SocketException: Failed host lookup")) {
      return http.Response(_weirdConnection, 502);
    } else {
      return http.Response(_failed, 404);
    }
  }

  Future<dynamic> loginAdmin(String username, String password) async {
    var url= 'http://127.0.0.1:8000/api/admins/login';
    var response = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password
        },
        headers: {'Accept': 'application/json'}
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );

    //returns the successful user data json object
    print(response.body);
    var data= jsonDecode(response.body);
    if(data["success"]==true) {
      String token = 'Bearer ' + data['result'];
      AdminModel.token=token;
      AdminModel.adminName=username;
      SharedPreferences prefs =await SharedPreferences.getInstance();
      prefs.setBool("admin_logged_in", true);
      prefs.setString("admin_token", token);
      prefs.setString("admin_name", username);

    }
    else{
      throw Exception("While logging admin in: ${data["message"]}");
    }




  }

  Future<dynamic> getAllUsers(String token) async {
    var url= 'http://127.0.0.1:8000/api/users/index';

    var response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token}
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    //returns the successful user data json object
    print(response.body);
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      return data["result"]["data"]["users"];
    }
    else{
      throw Exception("Error While retrieving all users info: ${data["message"]}");
    }

  }
  Future<dynamic> getAllUsersWhoWantToBeManager(String token) async {
    var url= 'http://127.0.0.1:8000/api/users/bemanager';

    var response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token}
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    //returns the successful user data json object
    print(response.body);
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      return data["result"]["data"]["users"];
    }
    else{
      throw Exception("Error While retrieving requesting users info: ${data["message"]}");
    }

  }
  Future<dynamic> makeUserManager(String token, int id) async {
    var url= 'http://127.0.0.1:8000/api/users/bemanager/${id.toString()}';

    var response = await http.put(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token}
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    //returns the successful user data json object
    print(response.body);
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      return data["result"]["data"]["user"];
    }
    else{
      throw Exception("Error While making user manager: ${data["message"]}");
    }

  }
  Future<bool> deleteUser(String token, int id) async {
    var url= 'http://127.0.0.1:8000/api/users/delete/${id.toString()}';
    var response = await http.delete(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token}
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    //returns the successful user data json object
    print(response.body);
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      return true;
    }
    else{
      throw Exception("Error While making user manager: ${data["message"]}");
    }

  }


}



