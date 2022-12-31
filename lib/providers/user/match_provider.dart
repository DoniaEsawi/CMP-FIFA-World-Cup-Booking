import 'dart:developer';

import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/services/matches_services.dart';
import 'package:flutter/material.dart';

class MatchProvider with ChangeNotifier{
  List<MatchModel> matches= <MatchModel>[];
  bool isInitialized=false;

  MatchModel  getMatchWithId(int id){
    int index= matches.indexWhere((element) =>  element.id==id);
    return index!=-1?matches[index]:MatchModel(id: -1);
  }

  List<MatchModel> getAllMatches(){
    return matches;
  }

  bool updateMatchWithId(int id, MatchModel matchModel){
    int index= matches.indexWhere((element) =>  element.id==id);
    if(index!=-1){ // element exists
      matches[index]=matchModel;
      matches[index].id=id; // to ensure that id is not get updated
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }

  void insertMatch(MatchModel matchModel)
  {
    matches.add(matchModel);
    notifyListeners();
  }

  void clearMatches(){
    matches.clear();
    notifyListeners();
  }

  Future<bool> getAllMatchesAPI()async{
    try {
      var data = await MatchesServices().getAllMatches();
      matches=<MatchModel>[];
      for (Map<String,dynamic> match in data){
        matches.add(MatchModel.fromJson(match));
      }

      isInitialized=true;
      notifyListeners();
      return true;
    }
    catch(e)
    {
      rethrow;
    }

  }
  Future<bool> createNewMatchAPI(MatchModel matchModel)async{
    try {
      await MatchesServices().createNewMatch(matchModel, Globals.token!);

      insertMatch(matchModel);
      isInitialized=true;
      notifyListeners();
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }

  }

  Future<bool> updateSeatsOfMatchWithId(int id)async{
    int index= matches.indexWhere((element) =>  element.id==id);
    if(index!=-1){ // element exists
      try {
        var data = await MatchesServices().getAllReservedSeatsForMatch(id);
        log("hello");
        log(data.toString());
        matches[index].setSeats(data);
        log("huuuu");
        notifyListeners();
        return true;
      }
      catch(e)
      {
        log("huuuulll");
        print(e);
        return false;
      }
    }
    else{
      return false;
    }
  }
  void addToSeatsOfMatchWithId(int id, int seatNo){
    int index= matches.indexWhere((element) =>  element.id==id);
    if(index!=-1) { // element exists
      matches[index].seats==null?
      matches[index].setSeats(<dynamic>[seatNo]):
      matches[index].seats!.add(seatNo);
      notifyListeners();
    }
  }
}