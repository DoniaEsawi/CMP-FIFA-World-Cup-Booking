import 'dart:convert';

import 'package:fifa2022/models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
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
  Future<dynamic> registerUser(Map<String, dynamic>? userData) async {
    var url= 'http://127.0.0.1:8000/api/users/create';
    var response = await http.post(
        Uri.parse(url),
        body: userData,
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
      try {
        var userData = await getUserInfo(token);
        print(userData);
        User user = User.fromJson(userData);
        user.token = token;
        return user;
      }
      catch (e)
      {
        print(e);
      }
    }
    else{
      throw Exception("While Registering new user: ${data["message"]}");
    }


  }

  Future<dynamic> login(String username, String password) async {
    var url= 'http://127.0.0.1:8000/api/users/login';
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
        try {
          var userData = await getUserInfo(token);
          print(userData);
          User user = User.fromJson(userData);
          user.token = token;
          return user;
        }
        catch (e)
        {
          print(e);
        }
      }
      else{
        throw Exception("While logging in: ${data["message"]}");
      }




  }

  Future<dynamic> getUserInfo(String token) async {
    var url= 'http://127.0.0.1:8000/api/user';

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
        return data["result"]["data"]["user"];
      }
      else{
        throw Exception("Error While retrieving user info: ${data["message"]}");
      }

    }

  Future<void> logOut(String token) async {
    var url= 'http://127.0.0.1:8000/api/users/logout';
    var response = await http.post(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
        'Authorization':token
        }
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
      print(data["message"]);
    }
    else{
      print(data["message"]);

      throw Exception("While logging out: ${data["message"]}");

    }




  }
  Future<void> updateUserInfo(String token, User user, [String? pass]) async {
    var url= 'http://127.0.0.1:8000/api/users/update';
    var response = await http.post(
        Uri.parse(url),
        body: pass!=null?{
          'first_name':user.firstName,
          'last_name':user.lastName,
          'birth_date':user.birthDate,
          'gender':user.gender,
          'nationality':user.nationality,
          'password':pass,
        }:
        {
          'first_name':user.firstName,
          'last_name':user.lastName,
          'birth_date':user.birthDate,
          'gender':user.gender,
          'nationality':user.nationality,
        }
        ,
        headers: {'Accept': 'application/json',
          'Authorization':token
        }
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
      print(data["message"]);
    }
    else{
      print(data["message"]);

      throw Exception("While updating user info: ${data["message"]}");

    }




  }

}



