// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/router/fluru.dart';
import 'package:fifa2022/screens/matches/all_matches_wodgets.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:provider/provider.dart';

class AllMatches extends StatefulWidget {
  const AllMatches({Key? key}) : super(key: key);

  @override
  _AllMatchesState createState() => _AllMatchesState();
}

class _AllMatchesState extends State<AllMatches> with SingleTickerProviderStateMixin{
  bool isFirstSelected=true;
  bool isSecondSelected=false;
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    Future.delayed(Duration.zero, ()
    async{
      showAlertDialog(context, animationController);
      try {
        getAllMatchesInfo();
        Navigator.pop(context);

      }
      catch (e) {
        print(e.toString());
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
  void getAllMatchesInfo()async{
    bool success=await Provider.of<MatchProvider>(context,listen: false).getAllMatchesAPI();
    if(!success)
      {
        throw Exception("failed to retrieve matches");
      }
    else
      {
        print(Provider.of<MatchProvider>(context,listen: false).matches.length);
      }

  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  Map<String, List<MatchModel>> matchesMap={};

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    MatchProvider matchProvider = Provider.of<MatchProvider>(context);
    if(matchProvider.isInitialized)
      {
        matchesMap={};
        for(MatchModel match in matchProvider.matches)
          {
            if(matchesMap[match.date]!=null&&matchesMap[match.date]!.contains(match)==false) {
              matchesMap[match.date]!.add(match);
            }
            else{
              matchesMap.putIfAbsent(match.date!, () => [match]);
            }
          }

          matchesMap= Map.fromEntries(
              matchesMap.entries.toList()..sort((e1, e2) => DateTime.parse(e1.key).compareTo( DateTime.parse(e2.key))));
          setState(() {

          });
        print(matchProvider.matches.length);
        print(matchesMap);
      }
    return Scaffold(
      backgroundColor: backGround,
      appBar: const AppBarCustom(page: Pages.allMatches,),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (screenWidth>1400)?
          Expanded(child: Container()):Container(),
          // table
          Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),

                        color: mainRed,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Expanded(
                              flex: screenWidth>1300?2:1,
                              child: const Padding(
                                padding:  EdgeInsets.all(16.0),
                                child:  Text("Football Schedule Fixtures",
                          style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600
                          ),),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AnimatedButton(text: "Upcoming",
                                          borderRadius:50,
                                          height: 35,
                                          borderColor: mainRed,

                                          isSelected: isFirstSelected,
                                          backgroundColor: Colors.black,
                                          selectedBackgroundColor: Colors.white,
                                          selectedTextColor: mainRed,
                                          animationDuration: const Duration(milliseconds: 100),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: "Montserrat",
                                              fontWeight: FontWeight.w500
                                          ),
                                          onPress: (){
                                        setState(() {
                                          isFirstSelected=true;
                                          isSecondSelected=false;
                                        });
                                          },
                                      width: 110,

                                      ),
                                    ),
                                    const SizedBox(width: 16,),
                                    Expanded(
                                      child: AnimatedButton(text: "Finished",
                                        borderRadius:50,
                                        height: 35,
                                        isSelected: isSecondSelected,
                                        backgroundColor: Colors.black,
                                        selectedBackgroundColor: Colors.white,
                                        selectedTextColor: mainRed,
                                        animationDuration: const Duration(milliseconds: 100),
                                        textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500
                                        ),
                                        onPress: (){
                                          setState(() {
                                            isFirstSelected=false;
                                            isSecondSelected=true;
                                          });
                                        },
                                        width: 110,

                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: matchesMap.entries.map((e) => SameDayMatchesList(
                        date: e.key,
                        matchModels:e.value,
                      )).toList(),
                    )

                  ],
                ),
              )),
          // stadiums, ads and other info
          (screenWidth>650)?Expanded(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Padding(
                   padding: EdgeInsets.all(16.0),
                   child: Text("Trending News",
                    style: TextStyle(
                        color: mainRed,
                        fontSize: 22,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700
                    ),
                ),

                 ),


              ],
              )):Container(),
        ],
      ),
    );
  }
}

