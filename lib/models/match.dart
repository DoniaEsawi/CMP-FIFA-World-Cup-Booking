// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:fifa2022/models/stadium.dart';
import 'package:fifa2022/models/team.dart';

class MatchModel {
  int? id;
  String? date;
  String? time;
  int? team1Id;
  int? team2Id;
  String? referee;
  String? lineman1;
  String? lineman2;
  int? stadiumId;
  String? createdAt;
  String? updatedAt;
  StadiumModel? stadium;
  TeamModel? team1;
  TeamModel? team2;
  String? stadium_name;
  String? team1_name;
  String? team2_name;
  List<int> seats=<int>[];
  MatchModel(
      {this.id=-1,
        this.date="2022-12-30",
        this.time="00:00:00",
        this.team1Id=-1,
        this.team2Id=-1,
        this.referee="",
        this.lineman1="",
        this.lineman2="",
        this.stadiumId=-1,
        this.createdAt="",
        this.updatedAt="",
        this.stadium,
        this.team1,
        this.team2,
        this.stadium_name,
        this.team1_name,
        this.team2_name,

      });
  void setSeats(List<dynamic> seatsData)
  {
    log("debugggg");
    seats=[];
    for (int seat in seatsData)
      {
        print("debugggg");
        seats!.add(seat);
      }
    return;

  }
  MatchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    team1Id = json['team1_id'];
    team2Id = json['team2_id'];
    referee = json['referee'];
    lineman1 = json['lineman1'];
    lineman2 = json['lineman2'];
    stadiumId = json['stadium_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    team1=TeamModel.fromJson(json["team1"]);
    team2=TeamModel.fromJson(json["team2"]);
    stadium=StadiumModel.fromJson(json["stadium"]);
    stadium_name=json['stadium_name'];
    team1_name=json['team1_name'];
    team2_name=json['team2_name'];
    seats=<int>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['time'] = time;
    data['team1_id'] = team1Id;
    data['team2_id'] = team2Id;
    data['referee'] = referee;
    data['lineman1'] = lineman1;
    data['lineman2'] = lineman2;
    data['stadium_id'] = stadiumId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['team1']=team1;
    data['team2']=team2;
    data['stadium']=stadium;
    data['stadium_name']=stadium_name;
    data['team1_name']=team1_name;
    data['team2_name']=team2_name;
    return data;
  }
}