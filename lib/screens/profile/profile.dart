// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:custom_clippers/Clippers/multiple_points_clipper.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/config/lists.dart';
import 'package:fifa2022/models/match.dart';
import 'package:fifa2022/models/ticket.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/providers/user/match_provider.dart';
import 'package:fifa2022/providers/user/ticket_provider.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/screens/Auth/auth_widgets.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:fifa2022/screens/shared_widgets/unauthorized.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_container/tab_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin{
  late TextEditingController _textEditingControllerEmail;
  late TextEditingController _textEditingControllerPass1;
  late TextEditingController _textEditingControllerPass2;
  late TextEditingController _textEditingControllerFname;
  late TextEditingController _textEditingControllerLname;
  late TextEditingController _textEditingControllerUname;
  late TextEditingController _textEditingControllerNationality;
  int tabIconIndexSelected=0;
  int roleIndexSelected=0; //0 fan , 1 manager
  bool showDatePicker=false;
  DateRangePickerController? dateRangePickerController;
  DateTime dateTime=DateTime.now();
  bool enteredDate=false;
  late AnimationController animationController;
  GlobalKey<FormState> formKey4 = GlobalKey<FormState>();
  DateTime selectedDate=DateTime.now();
  TabContainerController? tabContainerController;

  bool emailHasError=false;
  bool passHasError=false;
  bool fnameHasError=false;
  bool lnameHasError=false;


  bool validateInput(){
    bool success=true;
    if(_textEditingControllerFname.text.isEmpty)
    {
      setState(() {
        fnameHasError=true;
      });
      success= false;
    }
    if(_textEditingControllerLname.text.isEmpty)
    {
      setState(() {
        lnameHasError=true;
      });
      success= false;
    }
    return success;
  }
  @override
  void initState() {
    // TODO: implement initState
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    tabContainerController=TabContainerController(length: Globals.isManager?1:2);
    if(Globals.isLoggedIn) {
      Future.delayed(Duration.zero, () async {
        showAlertDialog(context, animationController);
        try {
          await getUserInfo();
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
    _textEditingControllerEmail=TextEditingController
      (text: Provider.of<AuthProvider>(context,listen: false).user.email);
    _textEditingControllerLname=TextEditingController
      (text: Provider.of<AuthProvider>(context,listen: false).user.lastName);
    _textEditingControllerFname=TextEditingController
      (text: Provider.of<AuthProvider>(context,listen: false).user.firstName);
    _textEditingControllerUname=TextEditingController
      (text: Provider.of<AuthProvider>(context,listen: false).user.username);
    _textEditingControllerPass1=TextEditingController();
    _textEditingControllerPass2=TextEditingController();
    _textEditingControllerNationality=TextEditingController
      (text: Provider.of<AuthProvider>(context,listen: false).user.nationality);
    dateRangePickerController= DateRangePickerController();
    super.initState();

  }
  Future<void> getUserInfo()async{
    if(Globals.isLoggedIn&&
        Provider.of<AuthProvider>(context,listen: false).user.token=="none")
    {
      try {
        await AuthService().getUserInfo(Globals.token!).then((value) {
          print(value);
          User user = User.fromJson(value);
          user.token = Globals.token!;
          Provider.of<AuthProvider>(context,listen: false).setUser(user);
          _textEditingControllerEmail.text=user.email!;
          _textEditingControllerUname.text=user.username!;
          _textEditingControllerFname.text=user.firstName!;
          _textEditingControllerLname.text=user.lastName!;
          _textEditingControllerNationality.text=user.nationality!;
          roleIndexSelected=(user.role=="manager")?1:0;
          tabIconIndexSelected=(user.gender=="f")?1:0;
          dateTime=DateTime.parse(user.birthDate!);

          setState(() {

          });
        }

        );

      }
      catch (e)
      {
        // show page: a problem has occurred
        rethrow;
      }

    }
    else if(Globals.isLoggedIn&&
    Provider.of<AuthProvider>(context,listen: false).user.token!="none"
    ){
      _textEditingControllerEmail.text=Provider.of<AuthProvider>(context,listen: false).user.email!;
      _textEditingControllerUname.text=Provider.of<AuthProvider>(context,listen: false).user.username!;
      _textEditingControllerFname.text=Provider.of<AuthProvider>(context,listen: false).user.firstName!;
      _textEditingControllerLname.text=Provider.of<AuthProvider>(context,listen: false).user.lastName!;
      _textEditingControllerNationality.text=Provider.of<AuthProvider>(context,listen: false).user.nationality!;
      roleIndexSelected=(Provider.of<AuthProvider>(context,listen: false).user.role=="manager")?1:0;
      tabIconIndexSelected=(Provider.of<AuthProvider>(context,listen: false).user.gender=="f")?1:0;
      dateTime=DateTime.parse(Provider.of<AuthProvider>(context,listen: false).user.birthDate!);
      setState(() {

      });
    }

    if(Globals.isLoggedIn&&Globals.isManager==false&&
        Provider.of<TicketProvider>(context,listen: false).isInitialized==false
    )
      {
        try
        {
          await Provider.of<TicketProvider>(context,listen: false).getAllTicketsAPI();

        }
        catch(e)
          {
            showErrorSnackBar(context, e.toString());
          }
      }
    if(
        Provider.of<MatchProvider>(context,listen: false).isInitialized==false
    )
    {
      try
      {
        await Provider.of<MatchProvider>(context,listen: false).getAllMatchesAPI();

      }
      catch(e)
      {
        showErrorSnackBar(context, e.toString());
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    tabContainerController!.dispose();
    super.dispose();
    _textEditingControllerNationality.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerFname.dispose();
    _textEditingControllerLname.dispose();
    _textEditingControllerUname.dispose();
    _textEditingControllerPass2.dispose();
    _textEditingControllerPass1.dispose();
    dateRangePickerController!.dispose();
  }
  int tabSelected=0;
  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;
    AuthProvider authProvider=Provider.of<AuthProvider>(context);
    TicketProvider ticketProvider=Provider.of<TicketProvider>(context);
    return Scaffold(
      backgroundColor: backGround,
      appBar:  !Globals.isLoggedIn?null:const AppBarCustom(page: Pages.profile,),
      extendBodyBehindAppBar: true,
      body: !Globals.isLoggedIn?const UnauthorizedWidget():
      Container(
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
            tabEdge: TabEdge.left,
            isStringTabs: false,
            onEnd: () {
              setState(() {
                tabSelected=tabContainerController!.index;
              });
            },
            tabCurve: Curves.easeInOutCubic,
            tabs: Globals.isManager?[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:Icon(Icons.person, color: tabSelected==0?mainRed:Colors.white,
                size: 40,),
            ),
            ]:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Icon(Icons.person, color: tabSelected==0?mainRed:Colors.white,
                size: 40,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(CupertinoIcons.tickets, color: tabSelected==1?mainRed:Colors.white,
                  size: 40,),

              )
            ],
            tabExtent: 100,
            tabEnd: Globals.isManager?0.2:0.4,
            color: backGround,
            controller: tabContainerController,
            children: Globals.isManager?
            [
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    screenWidth>1000?Expanded(child: Container()):Container(),
                    Expanded(flex: 3,child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: screenWidth>1000?0:16.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16,),
                          SizedBox(height: screenHeight/4,child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 64.0),
                                child: Container(
                                  height: screenHeight/4-50,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          colors: [
                                            mainRed,
                                            Color(0xffB64A5F)
                                          ]
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.16),
                                            offset: const Offset(0, 3),
                                            blurRadius: 20
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 32.0),
                                          child: Text(
                                            "Ya Hala! ${authProvider.user.firstName}",
                                            style:const TextStyle(
                                              color: Colors.white,
                                              fontFamily: "kalam",
                                              fontSize: 44,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                height: screenHeight/4,
                                child: Image.asset("assets/images/welcoming.png"),
                              )
                            ],
                          ),
                          ),
                          Expanded(child: SingleChildScrollView(
                            child: ResponsiveGridRow(
                              children: [
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: fnameHasError,
                                      errorMsg: "first name should not be empty",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerFname,
                                      type: AuthInputType.firstName,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: lnameHasError,
                                      errorMsg: "Last name should not be empty",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerLname,
                                      type: AuthInputType.lastName,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      isSmallScreen: true,
                                      enabled: false,
                                      hasError: false,
                                      errorMsg: "",
                                      textEditingController: _textEditingControllerUname,
                                      type: AuthInputType.username,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      isSmallScreen: true,
                                      enabled: false,
                                      textEditingController: _textEditingControllerEmail,
                                      type: AuthInputType.email,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      isSmallScreen: true,
                                      hasError: false,
                                      errorMsg: "",
                                      placeHolder: "Type New Password",
                                      textEditingController: _textEditingControllerPass1,
                                      type: AuthInputType.password,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      placeHolder: "Retype Password",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerPass2,
                                      type: AuthInputType.password,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InputAuth(
                                        screenHeight: screenHeight,
                                        isSmallScreen: true,
                                        hasError: false,
                                        errorMsg: "",
                                        enabled: false,
                                        textEditingController: TextEditingController(),
                                        type: AuthInputType.age,
                                        selectedDate: authProvider.user.token!="none"?
                                        DateFormat("dd/MM/yyyy").format(dateTime):"Date of Birth",
                                        onClickingDate: (){
                                          setState(() {
                                            showDatePicker=true;
                                          });
                                        },

                                      )
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerNationality,
                                      type: AuthInputType.country,),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,
                                        horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FlutterToggleTab(
                                          width: 18,
                                          borderRadius: 15,
                                          selectedBackgroundColors: [mainRed],
                                          selectedIndex: tabIconIndexSelected,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                          unSelectedTextStyle:const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          labels: const ["",""],
                                          icons: const [Icons.male, Icons.female],
                                          selectedLabelIndex: (index) {
                                            setState(() {
                                              tabIconIndexSelected=index;
                                            });
                                          },
                                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveGridCol(md: 6,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,
                                        horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FlutterToggleTab(
                                          width: 18,
                                          borderRadius: 15,
                                          selectedBackgroundColors: const [mainRed],
                                          selectedIndex: roleIndexSelected,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          unSelectedTextStyle:const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          labels: const ["fan","manager"],
                                          icons: const [],
                                          selectedLabelIndex: (index) {

                                          },
                                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveGridCol(md: 12,
                                  sm: 12,child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,
                                        vertical: 32
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AuthButton(isSmallScreen: false, screenHeight: screenHeight,
                                          text: "Save", onPressed: ()async{
                                            // TODO:: Add validation
                                            bool passPassword=false;
                                            String pass="";
                                            User userTemp= User(
                                                nationality: _textEditingControllerNationality.text,
                                                firstName: _textEditingControllerFname.text,
                                                lastName: _textEditingControllerLname.text,
                                                gender: tabIconIndexSelected==1?"f":"m",
                                                birthDate: DateFormat("yyyy-MM-dd").format(dateTime)
                                            );
                                            if(_textEditingControllerPass1.text.isNotEmpty
                                                &&_textEditingControllerPass2.text.isNotEmpty)
                                            {
                                              if(_textEditingControllerPass1.text==
                                                  _textEditingControllerPass2.text)
                                              {
                                                // TODO:: validate password
                                                if(_textEditingControllerPass1.text.length<6)
                                                {
                                                  showErrorSnackBar(context, "Password length must be greater than 6");
                                                  return;
                                                }
                                                passPassword=true;
                                                pass=_textEditingControllerPass1.text;
                                              }
                                              else{
                                                // TODO:: show snack bar with error
                                                showErrorSnackBar(context, "Passwords don't match!");
                                                return;
                                              }
                                            }
                                            else{
                                              if(!(_textEditingControllerPass2.text.isEmpty
                                                  &&_textEditingControllerPass1.text.isEmpty))
                                              {
                                                // TODO:: show snack bar with error
                                                showErrorSnackBar(context, "Passwords don't match!");
                                                return;
                                              }

                                            }
                                            bool success;
                                            if(passPassword)
                                            {
                                              showAlertDialog(context, animationController);
                                              success=await Provider.of<AuthProvider>(context,listen: false).updateUserInfo(Globals.token!,
                                                  userTemp, pass);
                                              Navigator.pop(context);
                                              if(success){
                                                // TODO:: show snack bar with success
                                              }
                                              else
                                              {
                                                // TODO:: show snack bar with error
                                              }
                                            }
                                            else{
                                              showAlertDialog(context, animationController);

                                              success= await Provider.of<AuthProvider>(context,listen: false).updateUserInfo(Globals.token!,
                                                  userTemp);
                                              Navigator.pop(context);

                                              if(success){
                                                // TODO:: show snack bar with success
                                              }
                                              else
                                              {
                                                // TODO:: show snack bar with error
                                              }
                                            }

                                          },width: 150,)
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ))
                        ],
                      ),
                    ),),
                    screenWidth>1000?Expanded(child: Container()):Container(),
                  ],
                ),
                showDatePicker?
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight,
                      color: Colors.black38,
                    ),
                    Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[

                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SfDateRangePicker(
                          onSelectionChanged: (val){},
                          showActionButtons: true,
                          selectionColor: Colors.black,
                          todayHighlightColor: mainRed,
                          selectionTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          showTodayButton: false,
                          controller: dateRangePickerController,
                          headerStyle: const DateRangePickerHeaderStyle(
                            backgroundColor: mainRed,
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          selectionMode: DateRangePickerSelectionMode.single,
                          onSubmit: (val){
                            setState(() {
                              showDatePicker=false;
                              enteredDate=true;
                              dateTime=val as DateTime;
                            });
                          },
                          onCancel: (){
                            setState(() {
                              showDatePicker=false;
                            });
                          },

                        ),
                      ),
                    ),
                  ],
                ):Container()
              ],
            ),
            ]
                :
            [
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      screenWidth>1000?Expanded(child: Container()):Container(),
                      Expanded(flex: 3,child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenWidth>1000?0:16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16,),
                            SizedBox(height: screenHeight/4,child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 64.0),
                                  child: Container(
                                    height: screenHeight/4-50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          mainRed,
                                          Color(0xffB64A5F)
                                        ]
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.16),
                                          offset: const Offset(0, 3),
                                          blurRadius: 20
                                        )
                                      ]
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                         Expanded(
                                           child: Padding(
                                             padding: EdgeInsets.only(left: 32.0),
                                             child: Text(
                                              "Ya Hala! ${authProvider.user.firstName}",
                                              style:const TextStyle(
                                                color: Colors.white,
                                                fontFamily: "kalam",
                                                fontSize: 44,
                                              ),
                                        ),
                                           ),
                                         ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  height: screenHeight/4,
                                  child: Image.asset("assets/images/welcoming.png"),
                                )
                              ],
                            ),
                            ),
                            Expanded(child: SingleChildScrollView(
                              child: ResponsiveGridRow(
                                children: [
                                    ResponsiveGridCol(md: 6,
                                      sm: 12,child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InputAuth(screenHeight: screenHeight,
                                        hasError: fnameHasError,
                                        errorMsg: "first name should not be empty",
                                        isSmallScreen: true,
                                        textEditingController: _textEditingControllerFname,
                                        type: AuthInputType.firstName,),
                                    ),
                                    ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: lnameHasError,
                                      errorMsg: "Last name should not be empty",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerLname,
                                      type: AuthInputType.lastName,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      isSmallScreen: true,
                                      enabled: false,
                                      hasError: false,
                                      errorMsg: "",
                                      textEditingController: _textEditingControllerUname,
                                      type: AuthInputType.username,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      isSmallScreen: true,
                                      enabled: false,
                                      textEditingController: _textEditingControllerEmail,
                                      type: AuthInputType.email,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      isSmallScreen: true,
                                      hasError: false,
                                      errorMsg: "",
                                      placeHolder: "Type New Password",
                                      textEditingController: _textEditingControllerPass1,
                                      type: AuthInputType.password,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      placeHolder: "Retype Password",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerPass2,
                                      type: AuthInputType.password,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(
                                      screenHeight: screenHeight,
                                      isSmallScreen: true,
                                      hasError: false,
                                      errorMsg: "",
                                      enabled: false,
                                      textEditingController: TextEditingController(),
                                      type: AuthInputType.age,
                                      selectedDate: authProvider.user.token!="none"?
                                      DateFormat("dd/MM/yyyy").format(dateTime):"Date of Birth",
                                      onClickingDate: (){
                                        setState(() {
                                          showDatePicker=true;
                                        });
                                      },

                                    )
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InputAuth(screenHeight: screenHeight,
                                      hasError: false,
                                      errorMsg: "",
                                      isSmallScreen: true,
                                      textEditingController: _textEditingControllerNationality,
                                      type: AuthInputType.country,),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,
                                    horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FlutterToggleTab(
                                          width: 18,
                                          borderRadius: 15,
                                          selectedBackgroundColors: [mainRed],
                                          selectedIndex: tabIconIndexSelected,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                          unSelectedTextStyle:const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          labels: const ["",""],
                                          icons: const [Icons.male, Icons.female],
                                          selectedLabelIndex: (index) {
                                            setState(() {
                                              tabIconIndexSelected=index;
                                            });
                                          },
                                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 6,
                                    sm: 12,child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0,
                                    horizontal: 32),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        FlutterToggleTab(
                                          width: 18,
                                          borderRadius: 15,
                                          selectedBackgroundColors: const [mainRed],
                                          selectedIndex: roleIndexSelected,
                                          selectedTextStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          unSelectedTextStyle:const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                          labels: const ["fan","manager"],
                                          icons: const [],
                                          selectedLabelIndex: (index) {

                                          },
                                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                  ResponsiveGridCol(md: 12,
                                    sm: 12,child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0,
                                      vertical: 32
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AuthButton(isSmallScreen: false, screenHeight: screenHeight,
                                              text: "Save", onPressed: ()async{
                                            // TODO:: Add validation
                                              bool passPassword=false;
                                              String pass="";
                                              User userTemp= User(
                                                nationality: _textEditingControllerNationality.text,
                                                firstName: _textEditingControllerFname.text,
                                                lastName: _textEditingControllerLname.text,
                                                gender: tabIconIndexSelected==1?"f":"m",
                                                birthDate: DateFormat("yyyy-MM-dd").format(dateTime)
                                              );
                                              if(_textEditingControllerPass1.text.isNotEmpty
                                              &&_textEditingControllerPass2.text.isNotEmpty)
                                                {
                                                  if(_textEditingControllerPass1.text==
                                                      _textEditingControllerPass2.text)
                                                    {
                                                      // TODO:: validate password
                                                      if(_textEditingControllerPass1.text.length<6)
                                                        {
                                                          showErrorSnackBar(context, "Password length must be greater than 6");
                                                          return;
                                                        }
                                                      passPassword=true;
                                                      pass=_textEditingControllerPass1.text;
                                                    }
                                                  else{
                                                    // TODO:: show snack bar with error
                                                    showErrorSnackBar(context, "Passwords don't match!");
                                                    return;
                                                  }
                                                }
                                              else{
                                                if(!(_textEditingControllerPass2.text.isEmpty
                                                &&_textEditingControllerPass1.text.isEmpty))
                                                  {
                                                    // TODO:: show snack bar with error
                                                    showErrorSnackBar(context, "Passwords don't match!");
                                                    return;
                                                  }

                                              }
                                              bool success;
                                              if(passPassword)
                                                {
                                                  showAlertDialog(context, animationController);
                                                  success=await Provider.of<AuthProvider>(context,listen: false).updateUserInfo(Globals.token!,
                                                      userTemp, pass);
                                                Navigator.pop(context);
                                                  if(success){
                                                    // TODO:: show snack bar with success
                                                  }
                                                  else
                                                    {
                                                      // TODO:: show snack bar with error
                                                    }
                                                }
                                              else{
                                                showAlertDialog(context, animationController);

                                                success= await Provider.of<AuthProvider>(context,listen: false).updateUserInfo(Globals.token!,
                                                    userTemp);
                                               Navigator.pop(context);

                                                if(success){
                                                  // TODO:: show snack bar with success
                                                }
                                                else
                                                {
                                                  // TODO:: show snack bar with error
                                                }
                                              }

                                            },width: 150,)
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ))
                          ],
                        ),
                      ),),
                      screenWidth>1000?Expanded(child: Container()):Container(),
                    ],
                  ),
                  showDatePicker?
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black38,
                      ),
                      Container(
                        width: 250,
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: <BoxShadow>[

                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4)
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SfDateRangePicker(
                            onSelectionChanged: (val){},
                            showActionButtons: true,
                            selectionColor: Colors.black,
                            todayHighlightColor: mainRed,
                            selectionTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            showTodayButton: false,
                            controller: dateRangePickerController,
                            headerStyle: const DateRangePickerHeaderStyle(
                              backgroundColor: mainRed,
                              textStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            selectionMode: DateRangePickerSelectionMode.single,
                            onSubmit: (val){
                              setState(() {
                                showDatePicker=false;
                                enteredDate=true;
                                dateTime=val as DateTime;
                              });
                            },
                            onCancel: (){
                              setState(() {
                                showDatePicker=false;
                              });
                            },

                          ),
                        ),
                      ),
                    ],
                  ):Container()
                ],
              ),
              Container(
                child: SingleChildScrollView(
                  child: ResponsiveGridRow(
                    children:ticketProvider.tickets.map((e) =>
                        ResponsiveGridCol(
                        xl:6,
                        lg: 12,
                        child: TicketProfile(
                          ticket: e,
                          match: Provider.of<MatchProvider>(context,listen: false).getMatchWithId(int.parse(e.matchId!)),
                          onPress: ()async{
                            bool success;
                            String errorMsg="";
                            showAlertDialog(context, animationController);
                            try{
                              success=await Provider.of<TicketProvider>(context,listen: false).deleteTicketAPI(e.id!);

                            }
                            catch(e){
                              success=false;
                              errorMsg=e.toString();
                            }
                            Navigator.pop(context);
                            if(success)
                              {
                                showSuccessSnackBar(context, "Successfully deleted ticket!");
                              }
                            else
                              {
                                showErrorSnackBar(context, errorMsg);

                              }

                          },
                        )
                    ),
                    ).toList()
                  ),
                ),
              )
            ],
          ),
        ),
      ),


    );
  }
}

class TicketProfile extends StatelessWidget {
  const TicketProfile({required this.ticket,
    required this.onPress,
    required this.match,
    Key? key}) : super(key: key);
  final TicketModel ticket;
  final MatchModel match;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CouponCard(
        shadow: Shadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.25)
        ),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  mainRed,
                  Color(0xffB64A5F),
                  Color(0xffB64A5F)
                ]
            )
        ),
        firstChild: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.all(Colors.red.shade50),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              )),


            ),
            onPressed: onPress,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.delete_forever, color: mainRed,size: 30,),
            ),
          ),
        ),
        secondChild:  Row(children: [
          const VerticalDivider(width: 1,color: Colors.white70,),
          const SizedBox(width: 20,),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text("${match.team1_name}",
                          style:const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "kalam",
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        const SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white,width: 2)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset('icons/flags/png/${countryFlag.keys.contains(match.team1_name)?
                            countryFlag[match.team1_name]!.toLowerCase():"eg"}.png', package: 'country_icons',
                              width: 25,height: 25,fit: BoxFit.cover,),
                          ),
                        ),
                      ],
                    ),
                    const Text("VS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "kalam",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white,width: 2)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset('icons/flags/png/${countryFlag.keys.contains(match.team2_name)?
                            countryFlag[match.team2_name]!.toLowerCase():"eg"}.png', package: 'country_icons',
                              width: 25,height: 25,fit: BoxFit.cover,),
                          ),
                        ),
                        const SizedBox(width: 8,),
                        Text("${match.team2_name}",
                          style:const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "kalam",
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    )
                  ],
            ),
                ),
                const SizedBox(height: 16,),

                Expanded(
                  child: Row(
                    children: [

                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset("assets/images/4.png",
                            width: 50,),
                          Text(match.stadium_name!,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "montserrat",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      )),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Icon(Icons.chair,size: 50,color: Colors.white,),
                          Text(ticket.seatNumber!,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "montserrat",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      )),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Icon(Icons.calendar_today, color: Colors.white,size: 50,),
                          Text(match.date!,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "montserrat",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      )),
                      Expanded(child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          Icon(Icons.access_time, color: Colors.white,size: 50,),
                          Text(match.time!,
                            style:const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "montserrat",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
                const SizedBox(height: 16,),

              ],
            ),
          )
        ],),
        height: 200,
        backgroundColor: Colors.white,
        curveAxis: Axis.vertical,
        curvePosition: 150,
        curveRadius: 25,
      ),
    );
  }
}

