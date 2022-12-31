import 'dart:developer';
import 'package:fifa2022/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tab_container/tab_container.dart';
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/config/lists.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/models/stadium.dart';
import 'package:fifa2022/models/team.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/stadium_provider.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:fifa2022/services/matches_services.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

class CreateEditMatchDetails extends StatefulWidget {
  CreateEditMatchDetails({Key? key}) : super(key: key);

  @override
  _CreateEditMatchDetailsState createState() => _CreateEditMatchDetailsState();
}

class _CreateEditMatchDetailsState extends State<CreateEditMatchDetails>
    with SingleTickerProviderStateMixin{

  TeamModel selectedCountry1=TeamModel(name: "");
  TeamModel selectedCountry2=TeamModel(name: "");
  StadiumModel selectedStadium=StadiumModel(name: "");
  String mainReferee="";
  String lineMan1="";
  String lineMan2="";
  DateTime selectedDate=DateTime.now();
  TimeOfDay selectedTime= TimeOfDay.now();
  late AnimationController animationController;
  List<String> teams=<String>[];
  List<String> stadiums=<String>[];
  TabContainerController? tabContainerController;
  String stadiumName="";
  String stadiumLoc="";
  int numberOfRows=1;
  int numberOfCols=1;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    tabContainerController=TabContainerController(length: 2);
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    Future.delayed(Duration.zero, ()
    async{
      showAlertDialog(context, animationController);
      try {
        getAllInfo();
        Navigator.pop(context);
      }
      catch (e) {
        Navigator.pop(context);
        SnackBar snackBar = SnackBar(
          content: Text(e.toString(),
            style: const TextStyle(
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.black,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    tabContainerController!.dispose();
    super.dispose();
  }
  void getAllInfo()async{
    bool success=await Provider.of<StadiumProvider>(context,listen: false).getAllStadiumsAPI(Globals.token!);
    if(!success)
    {
      throw Exception("failed to retrieve matches");
    }
    stadiums.clear();
    for (StadiumModel stadium in Provider.of<StadiumProvider>(context,listen: false).getAllStadiums())
      {
        stadiums.add(stadium.name!);
      }
    var data = await MatchesServices().getAllTeams(Globals.token!);
    Globals.teams.clear();
    setState(() {
      teams.clear();
    });
    int i=0;
    for (Map<String,dynamic> team in data){
      Globals.teams.add(TeamModel.fromJson(team));
      setState(() {
        teams.add(Globals.teams[i].name!);
      });
      i++;
    }



  }
  int tabSelected=0;
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    StadiumProvider stadiumProvider = Provider.of<StadiumProvider>(context);
    //MatchProvider matchProvider = Provider.of<MatchProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mainRed,
      appBar: const AppBarCustom(page: Pages.addMatch,),
      body: Container(

        decoration: const BoxDecoration(
          color: mainRed,
          image: DecorationImage(
            image: AssetImage("assets/images/bg_home.png",

            ),
            fit: BoxFit.cover
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          top: 86.0),
          child: TabContainer(
            controller: tabContainerController,
            tabEdge: TabEdge.left,
              isStringTabs: false,
              onEnd: () {
                setState(() {
                  tabSelected=tabContainerController!.index;
                });
              },
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(tabSelected==0?"assets/images/2.svg":"assets/images/5.svg",
                  width: 50,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(tabSelected==1?"assets/images/3.svg":"assets/images/4.svg",
                  width: 50,),

                )

              ],
              tabExtent: 100,
              tabEnd: 0.4,
              color: backGround,
            children:[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Text("Create New Match",
                        style: TextStyle(
                            color: mainRed,
                            fontSize: 38,
                            fontFamily: "kalam",
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      const SizedBox(height: 32,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth>1000?32:8.0),
                        child: ResponsiveGridRow(
                            children: [
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastDropdown(
                                      name: 'field_country_1',
                                      labelText: 'First Team',
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
                                        });
                                      },

                                      focusColor: Colors.white,

                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastDropdown(
                                      name: 'field_country_2',
                                      labelText: 'Second Team',
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
                                        });
                                      },

                                      focusColor: Colors.white,

                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: FastDropdown(
                                        name: 'field_venue',
                                        labelText: 'Stadium',
                                        items: stadiums,
                                        onChanged: (val){
                                          setState(() {
                                            selectedStadium=stadiumProvider.getAllStadiums().firstWhere(
                                                    (element) => element.name==val);
                                          });
                                        },

                                        focusColor: Colors.white,

                                      )
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
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
                                      labelText: 'Date',
                                      onChanged: (val){
                                        setState(() {
                                          selectedDate=val!;
                                        });
                                      },


                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
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
                                      initialValue: selectedTime,
                                      onChanged: (val){
                                        setState(() {
                                          selectedTime= val!;
                                        });
                                      },


                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastTextField(
                                      cursorColor: mainRed,

                                      name: 'field_referee',
                                      labelText: 'Main Referee',
                                      onChanged: (val){
                                        setState(() {
                                          mainReferee=val!;
                                        });
                                      },


                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastTextField(
                                      cursorColor: mainRed,

                                      name: 'field_lineman1',
                                      labelText: 'Line Man 1',
                                      onChanged: (val){
                                        setState(() {
                                          lineMan1=val!;
                                        });
                                      },


                                    ),
                                  )
                              ),
                              ResponsiveGridCol(
                                  md:6,
                                  xs: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: FastTextField(
                                      cursorColor: mainRed,

                                      name: 'field_lineman2',
                                      labelText: 'Line Man 2',
                                      onChanged: (val){
                                        setState(() {
                                          lineMan2=val!;
                                        });
                                      },


                                    ),
                                  )
                              ),
                            ]
                        ),
                      ),
                      const SizedBox(height: 64,),
                      AnimatedButton(text: "Submit",
                        borderRadius:50,
                        height: 45,
                        animatedOn: AnimatedOn.onHover,
                        backgroundColor: mainRed,
                        selectedBackgroundColor: Colors.black,
                        selectedTextColor: mainRed,
                        animationDuration: const Duration(milliseconds: 300),
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w500
                        ),
                        onPress: ()async{
                          String time;
                          time="${selectedTime.hour<10?selectedTime.hour.toString().padLeft(2,'0'):selectedTime.hour.toString()}:${selectedTime.minute<10?selectedTime.minute.toString().padLeft(2,'0'):selectedTime.minute.toString()}:00";


                          // TODO:: ADD VALIDATION
                          MatchModel matchModelTemp=MatchModel(
                              date: DateFormat("yyyy-MM-dd").format(selectedDate),
                              referee: mainReferee,
                              lineman1: lineMan1,
                              lineman2: lineMan2,
                              team1: selectedCountry1,
                              team2: selectedCountry2,
                              team1_name: selectedCountry1.name,
                              team2_name: selectedCountry2.name,
                              team1Id: selectedCountry1.id,
                              team2Id: selectedCountry2.id,
                              stadium: selectedStadium,
                              stadium_name: selectedStadium.name,
                              stadiumId: selectedStadium.id,
                              time: time

                          );
                          showAlertDialog(context,animationController );
                          bool success=
                          await Provider.of<MatchProvider>(context, listen: false).createNewMatchAPI(matchModelTemp);
                          Navigator.pop(context);
                          if(success)
                          {
                            const snackBar = SnackBar(
                              content: Text('Successfully added new match!',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              backgroundColor: Colors.green,
                              showCloseIcon: true,
                              closeIconColor: Colors.black,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          else
                          {
                            const snackBar = SnackBar(
                              content: Text('Failed to add new match, try again later',
                                style: TextStyle(
                                    color: Colors.white
                                ),
                              ),
                              backgroundColor: Colors.red,
                              showCloseIcon: true,
                              closeIconColor: Colors.black,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        width: 150,

                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    const Text("Add New Stadium",
                      style: TextStyle(
                          color: mainRed,
                          fontSize: 38,
                          fontFamily: "kalam",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 32,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth>1000?32:8.0),
                      child: ResponsiveGridRow(
                          children: [

                            ResponsiveGridCol(
                                md:6,
                                xs: 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTextField(
                                    cursorColor: mainRed,

                                    name: 'field_stadium_name',
                                    //labelText: 'Stadium Name',
                                    placeholder: "Stadium Name",
                                    onChanged: (val){
                                      setState(() {
                                        stadiumName=val!;
                                      });
                                    },


                                  ),
                                )
                            ),
                            ResponsiveGridCol(
                                md:6,
                                xs: 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastTextField(
                                    cursorColor: mainRed,

                                    name: 'field_stadium_loc',
                                    //labelText: 'Stadium Name',
                                    placeholder: "Stadium Location",
                                    onChanged: (val){
                                      setState(() {
                                        stadiumLoc=val!;
                                      });
                                    },


                                  ),
                                )
                            ),
                            ResponsiveGridCol(
                                md:6,
                                xs: 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastSlider(
                                    activeColor: mainRed,
                                    inactiveColor: Colors.grey.withOpacity(0.3),
                                    min: 1,
                                    max: 12,

                                    divisions: 12,
                                    decoration: InputDecoration(
                                      labelText: "Number of rows",
                                      helperText: "rows selected: ${numberOfRows.toString()}",
                                      border: InputBorder.none,
                                      helperStyle: const TextStyle(
                                        color: mainRed,
                                        fontSize: 12,
                                        fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600

                                      ),
                                        labelStyle:  TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 18,
                                          fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    labelText: "Number of rows",
                                    name: 'field_stadium_rows',
                                    //labelText: 'Stadium Name',
                                    onChanged: (val){
                                      setState(() {
                                        numberOfRows=val!.toInt();
                                      });
                                    },


                                  ),
                                )
                            ),
                            ResponsiveGridCol(
                                md:6,
                                xs: 12,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: FastSlider(
                                    activeColor: mainRed,
                                    inactiveColor: Colors.grey.withOpacity(0.3),
                                    min: 1,
                                    max: 12,

                                    divisions: 12,
                                    decoration: InputDecoration(
                                        labelText: "Number of cols",
                                        helperText: "cols selected: ${numberOfCols.toString()}",
                                        border: InputBorder.none,
                                        helperStyle: const TextStyle(
                                            color: mainRed,
                                            fontSize: 12,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600

                                        ),
                                        labelStyle:  TextStyle(
                                            color: Colors.black.withOpacity(0.8),
                                            fontSize: 18,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w600
                                        )
                                    ),
                                    labelText: "Number of cols",
                                    name: 'field_stadium_cols',
                                    //labelText: 'Stadium Name',
                                    onChanged: (val){
                                      setState(() {
                                        numberOfCols=val!.toInt();
                                      });
                                    },


                                  ),
                                )
                            ),
                          ]
                      ),
                    ),
                    const SizedBox(height: 64,),

                    AnimatedButton(text: "Submit",
                      borderRadius:50,
                      height: 45,
                      animatedOn: AnimatedOn.onHover,
                      backgroundColor: mainRed,
                      selectedBackgroundColor: Colors.black,
                      selectedTextColor: mainRed,
                      animationDuration: const Duration(milliseconds: 300),
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w500
                      ),
                      onPress: ()async{
                      showAlertDialog(context, animationController);
                        try{
                          Map<String, dynamic> result=await addNewStad();
                          Provider.of<StadiumProvider>(context,listen: false).insertStadium(StadiumModel.fromJson(result));

                          showSuccessSnackBar(context, "Stadium added successfully!");
                        }
                        catch(e){
                         showErrorSnackBar(context, e.toString());

                        }
                        Navigator.pop(context);
                      },
                      width: 150,

                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
  Future<Map<String, dynamic>> addNewStad()
  async{
    try {

      var result= await MatchesServices().createNewStadium(StadiumModel(
        location: stadiumLoc,
        name: stadiumName,
        numberOfRows:numberOfRows.toString(),
        numberOfColumns: numberOfCols.toString(),
      ), Globals.token);
      stadiums.add(stadiumName);

      setState(() {

      });
      return result;
    }
    catch(e){

      rethrow;
    }
  }
}
