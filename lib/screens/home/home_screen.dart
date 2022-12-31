// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  int tabSelected=0;
  @override
  void initState() {
    // TODO: implement initState

    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    print("is logged in ${Globals.isLoggedIn}");
    Future.delayed((Duration.zero),()async{
      showAlertDialog(context, animationController);
      getUserInfo();
      Navigator.pop(context);
    });
    super.initState();
  }

  void getUserInfo()async{
    if(Globals.isLoggedIn!&&
        Provider.of<AuthProvider>(context,listen: false).user.token=="none")
    {
      try {

        await AuthService().getUserInfo(Globals.token!).then((value) {
          print(value);
          User user = User.fromJson(value);
          user.token = Globals.token!;
          Provider.of<AuthProvider>(context,listen: false).setUser(user);}
        );

      }
      catch (e)
      {
        // show page: a problem has occurred
        print(e);


      }

    }
    try {

      await Provider
          .of<MatchProvider>(context, listen: false).getAllMatchesAPI();

    }
    catch(e)
    {
      showErrorSnackBar(context, e.toString());
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();

    super.dispose();
  }
  bool isLoggedIn=Globals.isLoggedIn;


  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backGround,
      appBar:const AppBarCustom(page: Pages.home,),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomePageHeader(screenHeight: screenHeight,
            screenWidth: screenWidth,
            onBookNowPressed: ()async{
              showAlertDialog(context, animationController);
              await Navigator.pushNamed(context, '/matches');

            },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32,),
                 Text("What Managers Can Do?",
                  style: TextStyle(
                      color: mainRed,
                      fontSize: screenWidth>1080?38:screenWidth>600?32:24,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 64,),
                ManagerFunctionalities(screenWidth: screenWidth,),
                SizedBox(height: screenWidth>1080?200:screenWidth>600?64:32,),
                ClipPath(
                  clipper: DirectionalWaveClipper(
                  verticalPosition: VerticalPosition.TOP
                  ),
                  child:
                  Container(
                    width: screenWidth,
                    color: mainRed,
                    child: Padding(
                      padding: const EdgeInsets.all(64.0),
                      child: Center(
                        child: Column(
                          children: [
                            Text("What Fans Can Do?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth>1080?38:screenWidth>600?32:24,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            const SizedBox(height: 64,),
                            FansFunctionalities(screenWidth: screenWidth),
                            SizedBox(height: screenWidth>1080?64:screenWidth>600?32:18,),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ViewMatchesSection(screenWidth: screenWidth,onViewMatches:()async{
                  showAlertDialog(context, animationController);
                  await Navigator.pushNamed(context, '/matches');

                },),
                Container(width:screenWidth,
                  color: Colors.white,
                  height: screenWidth>1080?64:screenWidth>600?32:24,),
                Container(
                    color: Colors.white,
                    child: Image.asset("assets/images/6.png",width: screenWidth))

              ],
            )
          ],
        ),
      ),

    );
  }
}

class ViewMatchesSection extends StatelessWidget {
  const ViewMatchesSection({
    super.key,
    required this.screenWidth,
  required this.onViewMatches,
  });
  final VoidCallback onViewMatches;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(

          children: [
            Expanded(child: Image.asset("assets/images/match_details.png",)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("All you need to know about the upcoming matches",
                    style: TextStyle(
                        color: mainRed,
                        fontSize: screenWidth>1080?32:screenWidth>600?24:18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  const SizedBox(height: 32,),
                  const Text("Teams Playing ⚽ ",
                    style: TextStyle(
                        color:Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 16,),
                  const Text("Match Venue 🏟️ ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 16,),
                  const Text("Date & Time 📆 ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 16,),
                  const Text("️Main Referee Name 🏃‍♂",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 16,),

                  const Text("️Lines Men Names 🧍‍♂️🧍‍♂",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 32,),
                  Center(
                    child: AnimatedButton(text: "View All Matches", onPress: onViewMatches,
                      selectedTextColor: Colors.black,
                      backgroundColor: mainRed.withOpacity(0.03),
                      width: 200,
                      transitionType: TransitionType.LEFT_TO_RIGHT,
                      borderRadius: 0,
                      borderColor: mainRed,
                      borderWidth: 2,
                      animatedOn: AnimatedOn.onHover,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          color: mainRed,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],

              ),
            )
          ],
        ),
      ),
    );
  }
}

class ManagerFunctionalities extends StatelessWidget {
  const ManagerFunctionalities({
    super.key,
    required this.screenWidth,
  });
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return screenWidth>=1450?Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const[
        FunctionalityCard(icon: CupertinoIcons.calendar_badge_plus,
        title: "Create a new match event",
          body: "The managers can create a new match event and "
              "add all its details.",
        ),

        FunctionalityCard(icon: Icons.edit,
          title: "Edit the details of an existing match",
          body: "The managers can change/edit the details of a "
              "certain match.",
        ),
        FunctionalityCard(icon: Icons.add_business,
          title: "Add a new stadium",
          body: "The managers can create a new match event and "
              "add all its details.",
        ),
        FunctionalityCard(icon:Icons.preview_outlined,
          title: "View match details",
          body: "The managers can view all matches details.",
        ),
        FunctionalityCard(icon: Icons.event_seat,
          title: "View vacant/reserved seats for each match",
          body: "The managers can view the overall seat status for "
            "each event (vacant/reserved).",
        ),
      ],
    ):
    screenWidth>=1080?Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const[
            FunctionalityCard(icon: CupertinoIcons.calendar_badge_plus,
              title: "Create a new match event",
              body: "The managers can create a new match event and "
                  "add all its details.",
            ),
            SizedBox(width: 32,),
            FunctionalityCard(icon: Icons.edit,
              title: "Edit the details of an existing match",
              body: "The managers can change/edit the details of a "
                  "certain match.",
            ),
            SizedBox(width: 32,),

            FunctionalityCard(icon: Icons.add_business,
              title: "Add a new stadium",
              body: "The managers can create a new match event and "
                  "add all its details.",
            ),
          ],
        ),
        const SizedBox(height: 32,),
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            FunctionalityCard(icon:Icons.preview_outlined,
              title: "View match details",
              body: "The managers can view all matches details.",
            ),
            SizedBox(width: 32,),

            FunctionalityCard(icon: Icons.event_seat,
              title: "View vacant/reserved seats for each match",
              body: "The managers can view the overall seat status for "
                  "each event (vacant/reserved).",
            ),
          ],
        )
      ],
    ):
    screenWidth>=600?
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: const[
            FunctionalityCard(icon: CupertinoIcons.calendar_badge_plus,
              title: "Create a new match event",
              body: "The managers can create a new match event and "
                  "add all its details.",
            ),
            SizedBox(width: 32,),
            FunctionalityCard(icon: Icons.edit,
              title: "Edit the details of an existing match",
              body: "The managers can change/edit the details of a "
                  "certain match.",
            ),


          ],
        ),
        const SizedBox(height: 32,),
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            FunctionalityCard(icon: Icons.add_business,
              title: "Add a new stadium",
              body: "The managers can create a new match event and "
                  "add all its details.",
            ),
            SizedBox(width: 32,),

            FunctionalityCard(icon:Icons.preview_outlined,
              title: "View match details",
              body: "The managers can view all matches details.",
            ),


          ],
        ),
        const SizedBox(height: 32,),
        Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            FunctionalityCard(icon: Icons.event_seat,
              title: "View vacant/reserved seats for each match",
              body: "The managers can view the overall seat status for "
                  "each event (vacant/reserved).",
            ),

          ],
        )
      ],
    ):
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        FunctionalityCard(icon: CupertinoIcons.calendar_badge_plus,
          title: "Create a new match event",
          body: "The managers can create a new match event and "
              "add all its details.",
        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon: Icons.edit,
          title: "Edit the details of an existing match",
          body: "The managers can change/edit the details of a "
              "certain match.",
        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon: Icons.add_business,
          title: "Add a new stadium",
          body: "The managers can create a new match event and "
              "add all its details.",
        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon:Icons.preview_outlined,
          title: "View match details",
          body: "The managers can view all matches details.",
        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon: Icons.event_seat,
          title: "View vacant/reserved seats for each match",
          body: "The managers can view the overall seat status for "
              "each event (vacant/reserved).",
        ),


      ],
    );
  }
}
class FansFunctionalities extends StatelessWidget {
  const FansFunctionalities({
    super.key,
    required this.screenWidth,
  });
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return screenWidth>=1450?Row(

      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const[
        FunctionalityCard(icon: Icons.edit,
        title: "Edit their data.",
          body: "The customer can edit their personal data (except"
              " for the username and email address).",
          isReversed: true,
        ),
        FunctionalityCard(icon:Icons.preview_outlined,
          title: "View match details",
          body: "The customer can view all match details as well as "
              "the vacant seats for each match.",
          isReversed: true,

        ),

        FunctionalityCard(icon:  Icons.event_seat,
          title: "Reserve vacant seat(s) in future matches",
          body: "The customer can select vacant seat/s only.",
          isReversed: true,

        ),
        FunctionalityCard(icon: Icons.cancel,
          title: "Cancel a reservation",
          body: "The customer can cancel a reserved ticket only 3 "
              "days before the start of the event.",
          isReversed: true,

        ),

      ],
    ):
    screenWidth>=1080?
    Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            FunctionalityCard(icon: Icons.edit,
              title: "Edit their data.",
              body: "The customer can edit their personal data (except"
                  " for the username and email address).",
              isReversed: true,
            ),
            SizedBox(width: 32,),
            FunctionalityCard(icon:Icons.preview_outlined,
              title: "View match details",
              body: "The customer can view all match details as well as "
                  "the vacant seats for each match.",
              isReversed: true,

            ),
          ],
        ),
        const SizedBox(height: 32,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const[
            FunctionalityCard(icon:  Icons.event_seat,
              title: "Reserve vacant seat(s) in future matches",
              body: "The customer can select vacant seat/s only.",
              isReversed: true,

            ),
            SizedBox(width: 32,),
            FunctionalityCard(icon: Icons.cancel,
              title: "Cancel a reservation",
              body: "The customer can cancel a reserved ticket only 3 "
                  "days before the start of the event.",
              isReversed: true,

            ),
          ],
        ),

      ],
    ):
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        FunctionalityCard(icon: Icons.edit,
          title: "Edit their data.",
          body: "The customer can edit their personal data (except"
              " for the username and email address).",
          isReversed: true,
        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon:Icons.preview_outlined,
          title: "View match details",
          body: "The customer can view all match details as well as "
              "the vacant seats for each match.",
          isReversed: true,

        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon:  Icons.event_seat,
          title: "Reserve vacant seat(s) in future matches",
          body: "The customer can select vacant seat/s only.",
          isReversed: true,

        ),
         SizedBox(height: 32,),

        FunctionalityCard(icon: Icons.cancel,
          title: "Cancel a reservation",
          body: "The customer can cancel a reserved ticket only 3 "
              "days before the start of the event.",
          isReversed: true,

        ),



      ],
    );
  }
}
class FunctionalityCard extends StatefulWidget {
  const FunctionalityCard({Key? key, required this.icon,
    this.isReversed= false,
    required this.title, required this.body}) : super(key: key);
  final IconData icon;
  final String title;
  final String body;
  final bool isReversed;
  @override
  _FunctionalityCardState createState() => _FunctionalityCardState();
}

class _FunctionalityCardState extends State<FunctionalityCard> {
  bool isHovered=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,

          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0,3),
                blurRadius: 30
            )                                ]
      ),
      child: InkWell(
        onHover: (val){
          setState(() {
            isHovered=val;
          });
        },
        onTap: (){
          log("tapped");
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 270,
            height: 230,
            decoration: BoxDecoration(
              border:  Border(
                  top: BorderSide(
                      color: widget.isReversed?Colors.black:mainRed,
                      width: 4
                  )
              ),
              //borderRadius: BorderRadius.circular(10),
              color: isHovered?(widget.isReversed?Colors.black:mainRed)
                  :Colors.white,

            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  const SizedBox(height: 32,),
                  Icon(widget.icon,
                    size: 50,color: isHovered?Colors.white:Colors.black,),
                  const SizedBox(height: 16,),
                  Text(widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: isHovered?Colors.white:mainRed,
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 16,),

                  Text(widget.body,
                    textAlign: TextAlign.center,

                    style: TextStyle(

                        color: isHovered?Colors.white:Colors.black,
                        fontSize: 14,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  required this.onBookNowPressed,
  });

  final double screenHeight;
  final double screenWidth;
  final VoidCallback onBookNowPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight,
      child: Stack(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [

              ClipPath(
                clipper: DirectionalWaveClipper(

                ),
                child: Container(
                  height: screenHeight,
                  decoration: BoxDecoration(
                      color: mainRed.withOpacity(0.4),

                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Multiple Points Clipper Bottom Only',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

              ),
              ClipPath(
                clipper: SinCosineWaveClipper(

                ),
                child: Container(
                  height: screenHeight,
                  decoration: const BoxDecoration(
                      color: mainRed,
                      image: DecorationImage(
                          image: AssetImage("assets/images/bg_home.png"),
                          fit: BoxFit.cover
                      )
                  ),
                  alignment: Alignment.center,

                ),

              ),

            ],
          ),
          screenWidth>1300?
          Positioned(
            left: -80,
            top: -10,
            child: Row(
              children: [
                Image.asset("assets/images/3egal.png",
                  height: screenHeight,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:  [
                    const Text("FIFA WORLD CUP\nQATAR 2022",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 18,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Do you want to visit a World Cup 2022 football match in Qatar?"
                          "\nbook your tickets safely online through our secure booking system.",
                        style: TextStyle(
                            color: Colors.white70,

                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    const SizedBox(height: 24,),
                    AnimatedButton(text: "Book Now", onPress: onBookNowPressed,
                      selectedTextColor: Colors.black,
                      backgroundColor: Colors.white24,
                      width: 160,
                      transitionType: TransitionType.LEFT_TO_RIGHT,
                      borderRadius: 50,
                      borderColor: Colors.white,
                      borderWidth: 2,
                      animatedOn: AnimatedOn.onHover,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 18,),

                  ],
                )
              ],
            ),
          ):
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("FIFA WORLD CUP QATAR 2022",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:screenWidth>1080?60:40,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    const SizedBox(height: 18,),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text("Do you want to visit a World Cup 2022 football match in Qatar?"
                          " book your tickets safely online through our secure booking system.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white70,

                            fontSize: 18,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                    const SizedBox(height: 24,),
                    AnimatedButton(text: "Book Now", onPress: (){},
                      selectedTextColor: Colors.black,
                      backgroundColor: Colors.white24,
                      width: 160,
                      transitionType: TransitionType.LEFT_TO_RIGHT,
                      borderRadius: 50,
                      borderColor: Colors.white,
                      borderWidth: 2,
                      animatedOn: AnimatedOn.onHover,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 18,),

                  ],
                ),
              )
        ],
      ),
    );
  }
}
