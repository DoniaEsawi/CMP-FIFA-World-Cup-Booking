import 'dart:convert';

import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/models/stadium.dart';
import 'package:fifa2022/models/user.dart';
import 'package:http/http.dart' as http;
class MatchesServices{
  final String _weirdConnection = '''
            {
              "success": false,
              "message":"Weird Connection. Try Again?"
            }
        ''';

  final String _failed = '''
            
            {
              "success": false,
              "message":"Failed to Connect to the server"
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

  Future<dynamic> getAllMatches() async {
    var url= '${Globals.baseUrl}/api/match/index';

    var response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json',}
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
      return data["result"]["data"]["matches"];
    }
    else{
      throw Exception("Error While retrieving matches: ${data["message"]}");
    }

  }
  Future<void> createNewMatch(MatchModel matchModel, String token) async {
    var url= '${Globals.baseUrl}/api/match/store';

    var response = await http.post(
        Uri.parse(url),
        body: {
          'date':matchModel.date,
          'referee':matchModel.referee,
          'lineman1':matchModel.lineman1,
          'lineman2':matchModel.lineman2,
          'team1_id':matchModel.team1!.id.toString(),
          'team2_id':matchModel.team2!.id.toString(),
          'stadium_id':matchModel.stadium!.id.toString(),
          'time':matchModel.time,
        },
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
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      print(data["message"].toString());
    }
    else{
      throw Exception("Error While creating new match: ${data["message"]}");
    }

  }
  Future<void> editMatch(MatchModel matchModel, String token) async {
    var url= '${Globals.baseUrl}/api/match/update/${matchModel.id}';

    var response = await http.post(
        Uri.parse(url),
        body: {
          'date':matchModel.date,
          'referee':matchModel.referee,
          'lineman1':matchModel.lineman1,
          'lineman2':matchModel.lineman2,
          'team1_id':matchModel.team1!.id.toString(),
          'team2_id':matchModel.team2!.id.toString(),
          'stadium_id':matchModel.stadium!.id.toString(),
          'time':matchModel.time,
        },
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
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      print(data["message"].toString());
    }
    else{
      throw Exception("While editing match: ${data["message"]}");
    }

  }
  Future<dynamic> getAllTeams(String token) async {
    var url= '${Globals.baseUrl}/api/team/index';

    var response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token
        }
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
      return data["result"]["data"]["teams"];
    }
    else{
      throw Exception("Error While retrieving teams: ${data["message"]}");
    }

  }
  Future<dynamic> getAllStadiums(String token) async {
    var url= '${Globals.baseUrl}/api/stadium/index';

    var response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json',
          'Authorization': token
        }
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
      return data["result"]["data"]["stadiums"];
    }
    else{
      throw Exception("Error While retrieving teams: ${data["message"]}");
    }

  }
  Future<dynamic> getAllReservedSeatsForMatch(int matchId) async {
    var url= '${Globals.baseUrl}/api/ticket/match/$matchId';

    var response = await http.get(
        Uri.parse(url),

        headers: {'Accept': 'application/json',
        }
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
      return data["result"]["data"]["seats"];
    }
    else{
      throw Exception("Error While retrieving teams: ${data["message"]}");
    }

  }
  Future<dynamic> createNewStadium(StadiumModel stadiumModel, String token) async {
    var url= '${Globals.baseUrl}/api/stadium/store';

    var response = await http.post(
        Uri.parse(url),
        body: {
          'name':stadiumModel.name,
          'location':stadiumModel.location,
          'number_of_rows':stadiumModel.numberOfRows.toString(),
          'number_of_columns':stadiumModel.numberOfColumns.toString(),
        },
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
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      print(data["message"].toString());
      return data["result"]["data"]["stadium"];

    }
    else{
      throw Exception("Error While creating new stadium: ${data["message"]}");
    }

  }


}