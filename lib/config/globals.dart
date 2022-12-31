import 'package:fifa2022/models/team.dart';
import 'package:flutter/material.dart';

class Globals
{
  static bool isLoggedIn=false;
  static String token="";
  static bool isManager=false;
  static List<TeamModel> teams=<TeamModel>[];
  static String baseUrl="https://cmp-world-cup-fifa-2022.azurewebsites.net";//http://127.0.0.1:8000

}