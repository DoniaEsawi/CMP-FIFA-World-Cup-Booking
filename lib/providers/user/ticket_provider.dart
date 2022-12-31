import 'package:fifa2022/models/ticket.dart';
import 'package:fifa2022/services/tickets_services.dart';
import 'package:flutter/material.dart';

class TicketProvider with ChangeNotifier{
  List<TicketModel> tickets= <TicketModel>[];
  bool isInitialized=false;

  TicketModel  getTicketWithId(int id){
    int index= tickets.indexWhere((element) =>  element.id==id);
    return index!=-1?tickets[index]:TicketModel(id: -1);
  }

  List<TicketModel> getAllTickets(){
    return tickets;
  }



  bool removeTicketWithId(int id){
    int index= tickets.indexWhere((element) =>  element.id==id);
    if(index!=-1){ // element exists
      tickets.removeAt(index);
      if(tickets.isEmpty)
        {
          isInitialized=false;
        }
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }

  void insertTicket(TicketModel ticket)
  {
    tickets.add(ticket);
    isInitialized=true;
    notifyListeners();
  }

  void clearTickets(){
    tickets.clear();
    isInitialized=false;
    notifyListeners();
  }

  Future<bool> getAllTicketsAPI()async{
    try
    {
      var data= await TicketsServices().getAllTicketsOfUser();
      clearTickets();
      for (Map<String,dynamic> ticketRes in data)
        {
          insertTicket(TicketModel.fromJson(ticketRes));
        }

      return true;
    }
    catch(e)
    {
        rethrow;
    }
  }
  Future<bool> deleteTicketAPI(int id)async{
    try{
      await TicketsServices().deleteTicketWithId(id);
      removeTicketWithId(id);
      return true;
    }
    catch(e){
      rethrow;
    }

  }
  Future<bool> reserveTicketsAPI(List<TicketModel> ticketsToReserve)async{
    try{
      int i =0;
      for(TicketModel ticketTemp in ticketsToReserve)
        {
          try {
            var data = await TicketsServices().reserveTicket(ticketTemp);
            tickets.add(TicketModel.fromJson(data));
            notifyListeners();
            i++;
          }
          catch(e) {
            rethrow;
          }
          }

      return true;
    }
    catch(e){
      rethrow;
    }

  }



}