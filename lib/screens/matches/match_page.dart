
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:developer';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/config/lists.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/models/stadium.dart';
import 'package:fifa2022/models/team.dart';
import 'package:fifa2022/models/ticket.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/stadium_provider.dart';
import 'package:fifa2022/providers/user/ticket_provider.dart';
import 'package:fifa2022/screens/Auth/auth_widgets.dart';
import 'package:fifa2022/screens/matches/all_matches_wodgets.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:fifa2022/services/matches_services.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
class MatchPage extends StatefulWidget {
  const MatchPage({Key? key,required this.id}) : super(key: key);
  final String id;
  @override
  _MatchPageState createState() => _MatchPageState();
}



class _MatchPageState extends State<MatchPage> with SingleTickerProviderStateMixin{

  List<int> chairRowIndecies= <int>[];
  List<int> chairColIndecies= <int>[];
  List<bool> reservedChairs= <bool>[];
  bool pageIsReady=false;
  MatchModel matchDetails= MatchModel(id: -1);
  late AnimationController animationController;
  List<int> userSelectedSeats=<int>[];
  @override
  void initState() {
    // TODO: implement initState

    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    Future.delayed(Duration.zero,()async{
      await getInfo();
    });
    super.initState();
  }
  Future<void> getInfo()async{
    if(int.tryParse(widget.id)!=null) {
      if (Provider
          .of<MatchProvider>(context, listen: false)
          .isInitialized) {
        MatchModel matchResult = Provider.of<MatchProvider>
          (context, listen: false).getMatchWithId(int.parse(widget.id));
        mainReferee=matchResult.referee!;
        if (matchResult.id != -1) {
          matchDetails=matchResult;

          chairRowIndecies = List.generate(int.parse(matchDetails.stadium!.numberOfRows!), (index) => index);
          chairColIndecies = List.generate(int.parse(matchDetails.stadium!.numberOfColumns!), (index) => index);
          reservedChairs= List.filled(int.parse(matchDetails.stadium!.numberOfRows!)*int.parse(matchDetails.stadium!.numberOfColumns!), false);
          Future.delayed(Duration.zero, ()async {
            await getAllReservedSeats(int.parse(widget.id));

            for(int seatNo in Provider.of<MatchProvider>
              (context, listen: false).getMatchWithId(int.parse(widget.id)).seats!)
            {
              reservedChairs[seatNo]=true;
            }
            setState(() {
              pageIsReady=true;
            });

          });

        }
        else {
          // TODO:: match not found
          showErrorSnackBar(context, "Match not found!");
        }
      }
      else {
        // get all matches
        Future.delayed(Duration.zero,
                ()async{
              showAlertDialog(context, animationController);
              try {
                await Provider
                    .of<MatchProvider>(context, listen: false).getAllMatchesAPI();
                MatchModel matchResult = Provider.of<MatchProvider>
                  (context, listen: false).getMatchWithId(int.parse(widget.id));

                if (matchResult.id != -1) {
                  matchDetails=matchResult;
                  pageIsReady=true;
                  chairRowIndecies = List.generate(int.parse(matchDetails.stadium!.numberOfRows!), (index) => index);
                  chairColIndecies = List.generate(int.parse(matchDetails.stadium!.numberOfColumns!), (index) => index);
                  reservedChairs= List.filled(int.parse(matchDetails.stadium!.numberOfRows!)*int.parse(matchDetails.stadium!.numberOfColumns!), false);
                  Future.delayed(Duration.zero, ()async {
                    await getAllReservedSeats(int.parse(widget.id));

                    for(int seatNo in Provider.of<MatchProvider>
                      (context, listen: false).getMatchWithId(int.parse(widget.id)).seats!)
                    {
                      reservedChairs[seatNo]=true;
                    }
                    setState(() {

                    });
                  });

                }
                else {
                  // TODO:: match not found
                  showErrorSnackBar(context, "Match not found!");

                }
                Navigator.pop(context);

              }
              catch(e)
              {
                Navigator.pop(context);
                showErrorSnackBar(context, e.toString());
              }

            }
        );

      }

    }
    else
    {
      showErrorSnackBar(context, "Match not found!");


    }
  }
  List<String> teams=<String>[];
  List<String> stadiums=<String>[];
  TeamModel selectedCountry1=TeamModel(name: "");
  TeamModel selectedCountry2=TeamModel(name: "");
  StadiumModel selectedStadium=StadiumModel(name: "");
  String mainReferee="";
  String lineMan1="";
  String lineMan2="";
  DateTime selectedDate=DateTime.now();
  TimeOfDay selectedTime= TimeOfDay.now();

  void getAllInfo()async{
    bool success=await Provider.of<StadiumProvider>(context,listen: false).getAllStadiumsAPI(Globals.token!);
    if(!success)
    {
      showErrorSnackBar(context,"failed to retrieve matches");
    }
    stadiums.clear();
    for (StadiumModel stadium in Provider.of<StadiumProvider>(context,listen: false).getAllStadiums())
    {
      stadiums.add(stadium.name!);
    }
    try {
      var data = await MatchesServices().getAllTeams(Globals.token);
      Globals.teams.clear();
      teams.clear();
      int i = 0;
      for (Map<String, dynamic> team in data) {
        Globals.teams.add(TeamModel.fromJson(team));

        teams.add(TeamModel.fromJson(team).name!);
        setState(() {

        });
        i++;
      }
    }
    catch(e)
    {
      showErrorSnackBar(context,e.toString());
    }



  }
  Future<void> getAllReservedSeats(int id)async{
    await Provider.of<MatchProvider>(context, listen: false).updateSeatsOfMatchWithId(id);
    if(Globals.isLoggedIn&&Globals.isManager)
      {
        getAllInfo();
      }

  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MatchProvider matchProvider = Provider.of<MatchProvider>(context);
    StadiumProvider stadiumProvider = Provider.of<StadiumProvider>(context);
    setState(() {

    });
    if(pageIsReady&&matchProvider.getMatchWithId(int.parse(widget.id)).seats!=null)
      {
        for(int seatNo in matchProvider.getMatchWithId(int.parse(widget.id)).seats!)
          {
            reservedChairs[seatNo]=true;
          }
        setState(() {

        });
      }
    return Scaffold(
      backgroundColor: backGround,
      appBar: const AppBarCustom(page: Pages.match,),
      body: Center(
        child: Row(
          children: [
            Expanded(flex: 1,child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: MainRefereeCard(name: matchDetails.referee!,),
                  ),
                  const SizedBox(height: 32,),
                  Expanded(
                    flex: 2,
                    child: LinesMenCard(firstName: matchDetails.lineman1!,
                    lastName: matchDetails.lineman2!,
                    ),
                  ),
                  Expanded(child:
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset("assets/images/chair_green.png")),
                              const Text("Free",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(child: Image.asset("assets/images/chair_red.png")),
                              const Text("Reserved",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ))

                ],
              ),
            ),),
            Expanded(flex: 2,child: pageIsReady?Column(
              children: [
                MatchTimeCard(
                  matchModel: matchDetails
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: chairRowIndecies.map((int row) =>
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (chairColIndecies).map((int col) =>
                              InkWell(
                                onHover: (val){},
                                onTap: (){
                                  if((Globals.isLoggedIn&&!Globals.isManager)||Globals.isLoggedIn==false) {
                                    if (reservedChairs[col + row * chairColIndecies.length] ==
                                        false) { // not reserved

                                      setState(() {
                                        reservedChairs[col + row * chairColIndecies.length] = true;
                                        userSelectedSeats.add(col + row * chairColIndecies.length);
                                      });
                                    }
                                    else if (userSelectedSeats.contains(col +
                                        row * chairColIndecies.length)) // reserved by the user
                                        {
                                      setState(() {
                                        userSelectedSeats.remove(
                                            col + row * chairColIndecies.length);
                                        reservedChairs[col + row * chairColIndecies.length] =
                                        false;
                                      });
                                    }
                                  }
                                },
                                child: Ink(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(reservedChairs[col+row*chairColIndecies.length]?"assets/images/chair_red.png"
                                      :"assets/images/chair_green.png"),
                                      Text((col+row*chairColIndecies.length).toString(),
                                        style: TextStyle(
                                            color: reservedChairs[col+row*chairColIndecies.length]?Colors.white:
                                            mainRed,
                                            fontSize: 18,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList()
                            ,
                          ))
                      ).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 16,)
              ],
            ):Container()),
            Expanded(
              child: (Globals.isLoggedIn&&!Globals.isManager)||(!Globals.isLoggedIn)?Ticket(matchInfo: matchDetails,
              tickets: userSelectedSeats.map((e) => TicketModel(
                matchId: widget.id,
                seatNumber: e.toString(),

              )).toList(),
            ):Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4)
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastDropdown(
                                    name: 'field_country_1',
                                    labelText: 'First Team',
                                    initialValue: matchDetails.team1_name,
                                    items: teams,

                                    validator: (val){
                                      if(val! ==selectedCountry2.name)
                                      {
                                        return "Cannot choose the same team twice";
                                      }
                                      return null;

                                    },
                                    onChanged: (val){
                                      setState(() {
                                        selectedCountry1=Globals.teams.firstWhere((element) => element.name==val);
                                        matchDetails.team1=selectedCountry1;
                                        matchDetails.team1_name=selectedCountry1.name;
                                        matchDetails.team1Id=selectedCountry1.id;
                                      });
                                      setState(() {

                                      });
                                    },

                                    focusColor: Colors.white,

                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastDropdown(
                                    name: 'field_country_2',
                                    labelText: 'Second Team',
                                    initialValue: matchDetails.team2_name,
                                    items: teams,
                                    validator: (val){
                                      if(val==selectedCountry1.name)
                                      {
                                        return "Cannot choose the same team twice";
                                      }
                                      return null;

                                    },
                                    onChanged: (val){
                                      setState(() {
                                        selectedCountry2=Globals.teams.firstWhere((element) => element.name==val);
                                        matchDetails.team2=selectedCountry2;
                                        matchDetails.team2_name=selectedCountry2.name;
                                        matchDetails.team2Id=selectedCountry2.id;
                                      });



                                    },

                                    focusColor: Colors.white,

                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastDropdown(
                                      name: 'field_venue',
                                      labelText: 'Stadium',
                                      initialValue: matchDetails.stadium_name,
                                      items: stadiums.toSet().toList(),

                                      onChanged: (val){
                                        StadiumModel tempStad=stadiumProvider.getAllStadiums().firstWhere(
                                                (element) => element.name==val);
                                        for (int seat in matchDetails.seats){
                                          if ((int.parse(tempStad.numberOfColumns!)*int.parse(tempStad.numberOfRows!))<=seat)
                                            {
                                              showErrorSnackBar(context, "this stadium is too small for reserved seats");
                                              return;
                                            }
                                        }
                                        setState(() {
                                          selectedStadium=tempStad;
                                          matchDetails.stadium_name=val;
                                          matchDetails.stadiumId=selectedStadium.id;
                                          matchDetails.stadium=selectedStadium;

                                        });
                                        reservedChairs= List.filled(int.parse(matchDetails.stadium!.numberOfRows!)*int.parse(matchDetails.stadium!.numberOfColumns!), false);

                                        chairRowIndecies=List.generate(int.parse(matchDetails.stadium!.numberOfRows!), (index) => index);
                                        chairColIndecies=List.generate(int.parse(matchDetails.stadium!.numberOfColumns!), (index) => index);
                                        setState(() {

                                        });
                                      },

                                      focusColor: Colors.white,

                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastDatePicker(
                                    dialogBuilder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: mainRed, // header background color
                                            onPrimary: Colors.white, // header text color
                                            onSurface: Colors.black, // body text color
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: mainRed, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2024),
                                    name: 'field_date',
                                    initialValue: DateTime.parse(matchDetails.date!),
                                    labelText: 'Date',
                                    onChanged: (val){
                                      setState(() {
                                        selectedDate=val!;
                                        matchDetails.date= DateFormat("yyyy-MM-dd").format(selectedDate);
                                      });
                                    },


                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTimePicker(
                                    dialogBuilder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: mainRed, // header background color
                                            onPrimary: Colors.white, // header text color
                                            onSurface: Colors.black, // body text color
                                          ),
                                          textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                              primary: mainRed, // button text color
                                            ),
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                    name: 'filed_time',
                                    labelText: 'Time',
                                    initialValue:
                                    TimeOfDay.fromDateTime(DateFormat('MM/dd/yyyy, hh:mm').parse("12/12/2022, ${matchDetails.time!.substring(0,5)}")),
                                    onChanged: (val){
                                      setState(() {
                                        selectedTime= val!;
                                        matchDetails.time="${selectedTime.hour<10?selectedTime.hour.toString().padLeft(2,'0'):selectedTime.hour.toString()}:${selectedTime.minute<10?selectedTime.minute.toString().padLeft(2,'0'):selectedTime.minute.toString()}:00";

                                      });
                                    },


                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTextField(
                                    cursorColor: mainRed,
                                    initialValue: mainReferee,
                                    name: 'field_referee',
                                    labelText: 'Main Referee',
                                    onChanged: (val){
                                      setState(() {
                                        mainReferee=val!;
                                        matchDetails.referee=mainReferee;
                                      });
                                    },


                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTextField(
                                    cursorColor: mainRed,
                                    initialValue: matchDetails.lineman1,
                                    name: 'field_lineman1',
                                    labelText: 'Line Man 1',
                                    onChanged: (val){
                                      setState(() {
                                        lineMan1=val!;
                                        matchDetails.lineman1=lineMan1;
                                      });
                                    },


                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTextField(
                                    cursorColor: mainRed,
                                    initialValue: matchDetails.lineman2,
                                    name: 'field_lineman2',
                                    labelText: 'Line Man 2',
                                    onChanged: (val){
                                      setState(() {
                                        lineMan2=val!;
                                        matchDetails.lineman2=lineMan2;

                                      });
                                    },


                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32,),
                    AuthButton(
                      isSmallScreen: true,
                      width: 200,
                      onPressed: ()async{
                          showAlertDialog(context, animationController);
                          try{
                            await MatchesServices().editMatch(matchDetails, Globals.token!);
                            Provider.of<MatchProvider>(context,listen: false).updateMatchWithId(matchDetails.id!, matchDetails);
                            Navigator.pop(context);
                            showSuccessSnackBar(context,"Updated Match Successfully!");

                          }
                          catch(e){
                            Navigator.pop(context);
                            showErrorSnackBar(context, e.toString());
                          }
                      },
                      text: "Save",
                      screenHeight: MediaQuery.of(context).size.height,
                    )
                  ],
                ),
            ),

            ),
          ],
        )
      ),

    );
  }
}

class Ticket extends StatefulWidget {
  const Ticket({
    required this.matchInfo,
    required this.tickets,
    super.key,
  });
  final MatchModel matchInfo;
  final List<TicketModel> tickets;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  String creditCardNum="";
  String pinNumber="";
  @override
  void initState() {

    super.initState();
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return widget.matchInfo.id!=-1?Padding(
      padding: const EdgeInsets.all(16.0),
      child: CouponCard(
        shadow: Shadow(
          blurRadius: 15,
          color: Colors.black.withOpacity(0.24)
        ),
        firstChild:  ClipPath(
          clipper: MultiplePointsClipper(
            Sides.BOTTOM
          ),
          child: Container(
            color: mainRed,
            child: DottedBorder(
              borderType: BorderType.RRect,
              strokeWidth: 2,
              color: Colors.white,
              dashPattern: const [6,2],
              borderPadding: const EdgeInsets.only(left: 10.0,
              right: 10.0,top: 10.0),
              radius: const Radius.circular(8),
              padding: const EdgeInsets.all(6),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                     Text("${widget.matchInfo.team1_name} Vs ${widget.matchInfo.team2_name}",
                      style:const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "kalam",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const Divider(height: 2,thickness: 2,color: Colors.white,),
                    const SizedBox(height: 32,),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text("Place",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                   Text("${widget.matchInfo.stadium_name}, ${widget.matchInfo.stadium!.location}",
                                    style:const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text("Date",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Expanded(
                                    child: Text(widget.matchInfo.date!,
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text("Time",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                   Expanded(
                                    child: Text(widget.matchInfo.time!.substring(0,5),
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:   [
                                  const Text("Seat no.",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Expanded(
                                    child: Wrap(
                                      children: widget.tickets.map((e) =>  Text("${e.seatNumber}, ",
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400
                                          ),

                                      )).toList()
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:   [
                                  const Text("Row no.",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                  Expanded(
                                    child: Wrap(
                                        children: widget.tickets.map((e) =>  Text("${int.parse(e.seatNumber!)~/int.parse(widget.matchInfo.stadium!.numberOfColumns!)+1}, ",
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400
                                          ),

                                        )).toList()
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                   const Text("Col no.",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                   const SizedBox(height: 8,),
                                    Expanded(
                                    child: Wrap(
                                        children: widget.tickets.map((e) =>  Text("${(int.parse(e.seatNumber!)%int.parse(widget.matchInfo.stadium!.numberOfColumns!)).toInt()+1}, ",
                                          style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w400
                                          ),

                                        )).toList()
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text("Price",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  const SizedBox(height: 8,),
                                   Expanded(
                                    child: Text("${widget.tickets.length*150} \$",
                                      style:const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w400
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              ),
                            ),
                            Expanded(child: Container())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        secondChild:  Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ElevatedButton(
                onPressed: ()async{
                  if(Globals.isLoggedIn==false)
                    {
                      Navigator.pushNamed(context, "/register");
                      return;
                    }
                  if(widget.tickets.isNotEmpty) {
                    QuickAlert.show(
                      context: context,
                      width: 300,
                      type: QuickAlertType.custom,
                      barrierDismissible: true,
                      confirmBtnText: 'Submit',
                      confirmBtnTextStyle: const TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontWeight: FontWeight.w500
                      ),
                      customAsset: 'assets/images/credit.gif',

                      widget: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Credit Card Number',
                              prefixIcon: Icon(
                                Icons.credit_card,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => creditCardNum = value,
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              hintText: 'Enter Pin Number',
                              prefixIcon: Icon(
                                Icons.fiber_pin_rounded,
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => pinNumber = value,
                          ),
                        ],
                      ),
                      confirmBtnColor: mainRed,
                      cancelBtnText: "cancel",
                      onConfirmBtnTap: () async {
                        if (creditCardNum.length != 15 || creditCardNum
                            .contains(RegExp(r"[^0-9]"))) {
                          await QuickAlert.show(
                            width: 300,
                            context: context,
                            confirmBtnColor: Colors.red,
                            type: QuickAlertType.error,
                            text: 'Please input correct card number',
                            customAsset: 'assets/images/error.png',
                            confirmBtnTextStyle: const TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                          );
                          return;
                        }
                        else if (pinNumber.length != 3 || pinNumber.contains(
                            RegExp(r"[^0-9]"))) {
                          await QuickAlert.show(
                            width: 300,
                            context: context,
                            confirmBtnColor: Colors.red,
                            type: QuickAlertType.error,
                            text: 'Please input correct pin number',
                            customAsset: 'assets/images/error.png',
                            confirmBtnTextStyle: const TextStyle(
                                fontFamily: "Montserrat",
                                color: Colors.white,
                                fontWeight: FontWeight.w500
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context);
                        // reserve ticket
                        showAlertDialog(context, animationController);
                        try {
                          bool success = await Provider.of<TicketProvider>(
                              context, listen: false).reserveTicketsAPI(
                              widget.tickets);
                          Navigator.pop(context);
                          if (success) {
                            showSuccessSnackBar(context, "Tickets has been reserved successfully");
                          }
                        }
                        catch(e){
                          Navigator.pop(context);
                          showErrorSnackBar(context, e.toString());

                        }



                      },
                    );
                  }
                  else
                    {
                    showErrorSnackBar(context, "You haven't chosen any seats yet!");
                    }
                  },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainRed),
                  elevation: MaterialStateProperty.all(8),
                  fixedSize: MaterialStateProperty.all(const Size(200, 50)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)
                  )),
                  overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
                ),
                child: const Text("Book Now",

                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ),
          ),
        ),
        height: 800,
        backgroundColor: Colors.white,
        curveAxis: Axis.horizontal,
        curvePosition: 500,
        curveRadius: 40,
      ),
    ):Container();
  }
}

class LinesMenCard extends StatelessWidget {
  const LinesMenCard({
  required this.lastName,
  required this.firstName,
    super.key,
  });
  final String firstName;
  final String lastName;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)
            )
          ]
      ),
      child: Row(
        children: [
          Expanded(child: Image.asset("assets/images/lineman.png")),
          VerticalDivider(width:0,color: Colors.black.withOpacity(0.05),thickness: 2,
            indent: 20,endIndent: 20,),
          const SizedBox(width: 16,),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const  Text("Line Man 1",
                style: TextStyle(
                    color: mainRed,
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 16,),
               Text(firstName,
                style:const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "kalam",
                    fontWeight: FontWeight.w500
                ),
              ),
              const SizedBox(height: 32,),

              const Text("Line Man 2",
                style: TextStyle(
                    color: mainRed,
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 16,),
              Text(lastName,
                style:const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "kalam",
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),),
          const SizedBox(width: 16,),
        ],
      ),
    );
  }
}

class MainRefereeCard extends StatelessWidget {
  const MainRefereeCard({
    required this.name,
    super.key,
  });
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4)
          )
        ]
      ),
      child: Row(
        children: [
          Expanded(child: Image.asset("assets/images/referee.png")),
          VerticalDivider(width:0,color: Colors.black.withOpacity(0.05),thickness: 2,
          indent: 20,endIndent: 20,),
          const SizedBox(width: 16,),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text("Main Refereee",
                style: TextStyle(
                    color: mainRed,
                    fontSize: 16,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 16,),
               Text(name,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "kalam",
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),)
        ],
      ),
    );
  }
}
