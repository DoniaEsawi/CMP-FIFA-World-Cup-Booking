import 'package:fifa2022/config/lists.dart';
import 'package:fifa2022/models/stadium.dart';
import 'package:fifa2022/services/matches_services.dart';
import 'package:flutter/material.dart';

class StadiumProvider with ChangeNotifier {
  List<StadiumModel> stadiums= <StadiumModel>[];
  bool isInitialized=false;

  StadiumModel  getStadiumWithId(int id){
    return stadiums.firstWhere((element) => element.id==id);
  }

  List<StadiumModel> getAllStadiums(){
    return stadiums;
  }

  bool updateMatchWithId(int id, StadiumModel stadiumModel){
    int index= stadiums.indexWhere((element) =>  element.id==id);
    if(index!=-1){ // element exists
      stadiums[index]=stadiumModel;
      stadiums[index].id=id; // to ensure that id is not get updated
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }

  void insertStadium(StadiumModel stadiumModel)
  {
    stadiums.add(stadiumModel);
    notifyListeners();
  }

  void clearStadiums(){
    stadiums.clear();
    notifyListeners();
  }

  Future<bool> getAllStadiumsAPI(String token)async{
    try {
      var data = await MatchesServices().getAllStadiums(token);
      print(data);
      stadiums.clear();
      for (Map<String,dynamic> stad in data){
        print(stad);
        insertStadium(StadiumModel.fromJson(stad));
      }
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

}