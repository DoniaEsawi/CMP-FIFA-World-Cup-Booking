import 'dart:convert';

import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/ticket.dart';
import 'package:http/http.dart' as http;

class TicketsServices{
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

  Future<dynamic> getAllTicketsOfUser() async {
    var url= 'http://127.0.0.1:8000/api/ticket/allreserved';

    var response = await http.get(
        Uri.parse(url),

        headers: {'Accept': 'application/json',
          'Authorization':Globals.token
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
      return data["result"]["data"]["tickets"];
    }
    else{
      throw Exception("Error While getting tickets of user: ${data["message"]}");
    }
  }
  Future<void> deleteTicketWithId(int id) async {
    var url= 'http://127.0.0.1:8000/api/ticket/destroy/$id';

    var response = await http.delete(
        Uri.parse(url),

        headers: {'Accept': 'application/json',
          'Authorization':Globals.token
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
      throw Exception("Error While deleting ticket: ${data["message"]}");
    }

  }
  Future<dynamic> reserveTicket(TicketModel ticket) async {
    var url= 'http://127.0.0.1:8000/api/ticket/store';

    var response = await http.post(
        Uri.parse(url),
        body: {
          'match_id':ticket.matchId,
          'seat_number':ticket.seatNumber
        },
        headers: {'Accept': 'application/json',
          'Authorization':Globals.token
        }
    ).onError(errorFunction).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        return http.Response(_weirdConnection, 502);
      },
    );
    //returns the successful user data json object
    print("responseee");
    print(response.body);
    var data = jsonDecode(response.body);
    if(data["success"]==true) {
      print(data["message"].toString());
      return data["result"]["data"]["ticket_number"];
    }
    else{
      throw Exception("Error While reserving ticket: ${data["message"]}");
    }

  }


}