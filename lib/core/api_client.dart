import "package:dio/dio.dart";
import "package:fifa2022/config/globals.dart";
class ApiClient {
  final Dio _dio = Dio();

  Future<dynamic> registerUser(Map<String, dynamic>? userData) async {
    //IMPLEMENT USER REGISTRATION
    try {
      Response response = await _dio.post(
          '${Globals.baseUrl}/api/users/create',  //ENDPONT URL
          data: userData, //REQUEST BODY
          options: Options(headers: {'Accept': 'application/json', //HEADERS
          }));
      //returns the successful json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if there is
      return e.response!.data;
    }
  }

  Future<dynamic> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        '${Globals.baseUrl}/api/users/login',
        data: {
          'username': username,
          'password': password
        },
          options: Options(headers: {'Accept': 'application/json'})
      );
      //returns the successful user data json object
      return response.data;
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
    }
  }

  }
