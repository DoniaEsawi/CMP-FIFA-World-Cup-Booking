// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:math';

import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/core/api_client.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:video_player/video_player.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
  super.key,
  required this.screenHeight,
  required this.isSmallScreen,

  });

  final double screenHeight;

  final bool isSmallScreen;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with SingleTickerProviderStateMixin{
  late TextEditingController _textEditingControllerUserName;
  late TextEditingController _textEditingControllerPass;
  final ApiClient _apiClient = ApiClient();
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _textEditingControllerUserName=TextEditingController();
    _textEditingControllerPass=TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _textEditingControllerPass.dispose();
    _textEditingControllerUserName.dispose();
    super.dispose();


  }
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    Future<void> loginUsers() async {

      showAlertDialog(context, _controller);

      try {
        User user= await AuthService().login(
            _textEditingControllerUserName.text,
            _textEditingControllerPass.text
        );

        authProvider.setUser(user);
        print(user.token);
        SharedPreferences pref =await SharedPreferences.getInstance();
        pref.setString("token", user.token!);
        Globals.isLoggedIn=true;
        Globals.isManager=user.role=="manager";
        Globals.token=user.token!;
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, "/home");


      }
      catch(e)
      {
        print(e);

        Navigator.pop(context);

      }
    }
    return Column(
      crossAxisAlignment: widget.isSmallScreen?CrossAxisAlignment.center:
      CrossAxisAlignment.start,
      mainAxisAlignment: widget.isSmallScreen?MainAxisAlignment.center:
      MainAxisAlignment.start,
      children: <Widget>[
        Text("Ya Hala!",
          style: TextStyle(
              color:Colors.black,
              fontSize: widget.isSmallScreen?40:50,
              fontFamily: "kalam",
              fontWeight: FontWeight.w700
          ),
        ),
        Text("Welcome Back",
          style: TextStyle(
              color: mainRed,
              fontSize: widget.isSmallScreen?40:50,
              fontFamily: "kalam",
              fontWeight: FontWeight.w700
          ),
        ),
        const SizedBox(height: 32,),

        InputAuth(screenHeight: widget.screenHeight,
          isSmallScreen: widget.isSmallScreen,
          textEditingController: _textEditingControllerUserName,
          type: AuthInputType.username,),
        const SizedBox(height: 16,),
        InputAuth(screenHeight: widget.screenHeight,
          isSmallScreen:widget.isSmallScreen,
          textEditingController: _textEditingControllerPass,
          type: AuthInputType.password,),
        const SizedBox(height: 32,),

        AuthButton(isSmallScreen: widget.isSmallScreen, screenHeight: widget.screenHeight,
          text: "Login",
        onPressed: (){
          loginUsers();
        },)

      ],
    );
  }


}
class SignUpForm extends StatefulWidget {
  const SignUpForm({
  super.key,
  required this.screenHeight,
  required this.isSmallScreen,

  });

  final double screenHeight;

  final bool isSmallScreen;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>  with SingleTickerProviderStateMixin{
  late TextEditingController _textEditingControllerEmail;
  late TextEditingController _textEditingControllerPass;
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
  late final AnimationController _controller;
  final ApiClient _apiClient = ApiClient();
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    _controller=AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();

    _textEditingControllerEmail=TextEditingController();
    _textEditingControllerLname=TextEditingController();
    _textEditingControllerFname=TextEditingController();
    _textEditingControllerUname=TextEditingController();
    _textEditingControllerPass=TextEditingController();
    _textEditingControllerNationality=TextEditingController();
    dateRangePickerController= DateRangePickerController();

  }


  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    _textEditingControllerNationality.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerFname.dispose();
    _textEditingControllerLname.dispose();
    _textEditingControllerUname.dispose();
    _textEditingControllerPass.dispose();
    dateRangePickerController!.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    Future<void> handleRegister() async {

      showAlertDialog(context, _controller);
      Map<String, dynamic> userData = {
        "username":_textEditingControllerUname.text,
        "first_name":_textEditingControllerFname.text,
        "last_name":_textEditingControllerLname.text,
        "birth_date":DateFormat('yyyy-MM-dd').format(dateTime),
        "gender":tabIconIndexSelected==0?'m':'f',
        "nationality":_textEditingControllerNationality.text!=""?
        _textEditingControllerNationality.text:null,
        "role":roleIndexSelected==0?"fan":"manager",
        "email":_textEditingControllerEmail.text,
        "password":_textEditingControllerPass.text
      };
      try {
        User user= await AuthService().registerUser(
            userData
        );
        await authProvider.setUser(user);
        print(authProvider.user.token);
        SharedPreferences pref =await SharedPreferences.getInstance();
        pref.setString("token", user.token!);
        Globals.isLoggedIn=true;
        Globals.token=user.token!;

        Globals.isManager=user.role=="manager";
          Navigator.pop(context);
          Navigator.popAndPushNamed(context, "/home");

      }
      catch(e)
      {
        print(e);
        Navigator.pop(context);

      }


    }
    return Column(
      crossAxisAlignment: widget.isSmallScreen?CrossAxisAlignment.center:
      CrossAxisAlignment.center,
      mainAxisAlignment: widget.isSmallScreen?MainAxisAlignment.center:
      MainAxisAlignment.start,
      children: <Widget>[
        Text("Ya Hala!",
          style: TextStyle(
              color:Colors.black,
              fontSize: widget.isSmallScreen?40:50,
              fontFamily: "kalam",
              fontWeight: FontWeight.w700
          ),
        ),

        const SizedBox(height: 16,),

        Expanded(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !widget.isSmallScreen?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputAuth(screenHeight: widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: _textEditingControllerFname,
                          type: AuthInputType.firstName,),
                        const SizedBox(width: 4,),
                        InputAuth(screenHeight: widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController:_textEditingControllerLname,
                          type: AuthInputType.lastName,),
                      ],
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputAuth(screenHeight: widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: _textEditingControllerFname,
                          type: AuthInputType.firstName,),
                        const SizedBox(height: 16,),
                        InputAuth(screenHeight: widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController:_textEditingControllerLname,
                          type: AuthInputType.lastName,),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    InputAuth(screenHeight: widget.screenHeight,
                      isSmallScreen: widget.isSmallScreen,
                      textEditingController: _textEditingControllerUname,
                      type: AuthInputType.username,),
                    const SizedBox(height: 16,),
                    InputAuth(screenHeight: widget.screenHeight,
                      isSmallScreen: widget.isSmallScreen,
                      textEditingController: _textEditingControllerEmail,
                      type: AuthInputType.email,),
                    const SizedBox(height: 16,),
                    InputAuth(screenHeight: widget.screenHeight,
                      isSmallScreen:widget.isSmallScreen,
                      textEditingController: _textEditingControllerPass,
                      type: AuthInputType.password,),
                    const SizedBox(height: 16,),
                    !widget.isSmallScreen?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputAuth(screenHeight: 0.5*widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: TextEditingController(),
                          type: AuthInputType.age,
                          onClickingDate: (){
                          setState(() {
                            showDatePicker=true;
                          });
                          },
                          selectedDate: enteredDate?DateFormat('dd/MM/yyyy').format(dateTime)
                              :"Date of Birth",
                        ),
                        const SizedBox(width: 4,),
                        InputAuth(screenHeight: 0.5*widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: _textEditingControllerNationality,
                          type: AuthInputType.country,),
                      ],
                    ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InputAuth(screenHeight: 0.5*widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: TextEditingController(),
                          type: AuthInputType.age,
                          onClickingDate: (){
                            setState(() {
                              showDatePicker=true;
                            });
                          },
                          selectedDate: enteredDate?DateFormat('dd/MM/yyyy').format(dateTime)
                              :"Date of Birth",
                        ),
                        const SizedBox(height: 16,),
                        InputAuth(screenHeight: 0.5*widget.screenHeight,
                          isSmallScreen: widget.isSmallScreen,
                          textEditingController: _textEditingControllerNationality,
                          type: AuthInputType.country,),
                      ],
                    ),
                    const SizedBox(height: 16,),
                    !widget.isSmallScreen?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlutterToggleTab(
                          width: 10,
                          borderRadius: 15,
                          selectedBackgroundColors: const [mainRed],
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
                        const SizedBox(width: 16,),
                        FlutterToggleTab(
                          width: 12,
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
                            setState(() {
                              roleIndexSelected=index;
                            });
                          },
                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlutterToggleTab(
                          width: 16,
                          borderRadius: 15,
                          selectedBackgroundColors: const [mainRed],
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
                        const SizedBox(height: 16,),
                        FlutterToggleTab(
                          width: 16,
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
                            setState(() {
                              roleIndexSelected=index;
                            });
                          },
                          marginSelected: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        ),
                      ],

                    ),
                    const SizedBox(height: 32,),
                    AuthButton(isSmallScreen: widget.isSmallScreen, screenHeight: widget.screenHeight,
                      text: "Register",
                    onPressed: (){
                      handleRegister();

                    },),


                  ],
                ),
              ),
              showDatePicker?Container(
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
              ):Container(),
            ],
          ),
        )

      ],
    );
  }



}

class AuthButton extends StatelessWidget {
  AuthButton({
  super.key,
  required this.isSmallScreen,
  required this.screenHeight,
  required this.text,
  required this.onPressed,
  this.width=0.0,
  });
  final String text;
  final bool isSmallScreen;
  final double screenHeight;
  final VoidCallback onPressed;
  double width;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),

      child: Material(
        borderRadius: BorderRadius.circular(15),

        shadowColor: Colors.black.withOpacity(0.16),
        elevation: 5,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),

          onTap: (){
            onPressed.call();
          },

          overlayColor: MaterialStateProperty.all(Colors.white24),
          child: Ink(
            width: width!=0?width:!isSmallScreen?0.5*screenHeight:null,
            decoration:  BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 15,
                  offset: const Offset(0,3)
                )
              ],
                gradient: const LinearGradient(
                    colors: [
                      mainRed,
                      Color(0xffB64A5F),
                    ]
                )
            ),
            child: Center(
              child:  Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0,
                    horizontal: 32),
                child:  Text(text,
                  style:const TextStyle(
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
      ),
    );
  }
}

class InputAuth extends StatelessWidget {
  InputAuth({
  super.key,
  required this.screenHeight,
  required this.isSmallScreen,
  required TextEditingController textEditingController,
  required this.type,
  this.onClickingDate,
  this.selectedDate,
  this.enabled=true,
  this.defaultValue="",
  this.placeHolder="none",
  }) : _textEditingController = textEditingController;
  String placeHolder;
  final double screenHeight;
  final bool isSmallScreen;
  final TextEditingController _textEditingController;
  final AuthInputType type;
  VoidCallback? onClickingDate;
  String? selectedDate;
  String? defaultValue;
  bool?enabled;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(type==AuthInputType.age)
          {
            onClickingDate!.call();
          }
      },
      child: Container(
        width: (!isSmallScreen)?0.5*
            ((type==AuthInputType.lastName||type==AuthInputType.firstName)?0.5:1.0)*
        screenHeight:null,
        decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: mainRed,
              width: 2,

            )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (type!=AuthInputType.firstName&&type!=AuthInputType.lastName)?
            Padding(
              padding:const EdgeInsets.symmetric(horizontal: 16.0),
              child:
              Icon(
                type==AuthInputType.password?Icons.password:
                type==AuthInputType.email?
                Icons.email:type==AuthInputType.username?Icons.person:
                type==AuthInputType.age?Icons.cake:Icons.flag,
                color: mainRed, size: 20,),
            ):Container(
              width: 20,
            ),
            Expanded(
              child: TextFormField(
                enabled: enabled,
                obscuringCharacter: '⁕',
                obscureText: (type==AuthInputType.password)?true:false,
                controller: _textEditingController,
                keyboardType: (type==AuthInputType.email)?TextInputType.emailAddress:
                (type==AuthInputType.password)?TextInputType.visiblePassword:
                (type==AuthInputType.firstName)?TextInputType.text:
                (type==AuthInputType.lastName)?TextInputType.text:
                (type==AuthInputType.country)?TextInputType.text:
                (type==AuthInputType.username)?TextInputType.name:
                TextInputType.number,
                decoration:  InputDecoration(

                  hintText: placeHolder!="none"?placeHolder:
                  (type==AuthInputType.email)?"Email Address":
                  (type==AuthInputType.password)?"Password":
                  (type==AuthInputType.firstName)?"First Name":
                  (type==AuthInputType.lastName)?"Last Name":
                  (type==AuthInputType.username)?"Username":
                  (type==AuthInputType.age)?selectedDate:"Nationality",
                  enabledBorder: InputBorder.none,
                  enabled: !(type==AuthInputType.age),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  //contentPadding: EdgeInsets.only(right: 16),

                ),
                cursorColor: mainRed,
                cursorWidth: 1,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleContainerAuth extends StatelessWidget {
  const CircleContainerAuth({
  super.key,
  required this.screenHeight,
  required this.child,

  });

  final double screenHeight;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1.5*screenHeight,
        width: 1.5*screenHeight,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.75*screenHeight),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0,3),
                  blurRadius: 30
              )
            ]
        ),
        child: child

    );
  }
}

class IntroCircle extends StatelessWidget {
  const IntroCircle({
  super.key,
  required this.screenHeight,
  required VideoPlayerController controller,
  }) : _controller = controller;

  final double screenHeight;
  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenHeight*0.8),
      height: (screenHeight*0.8),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/circle_border.png",)
          )
      ),
      child: Padding(
        padding: EdgeInsets.all((145.0/700)*(screenHeight*0.8)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenHeight),
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width ,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
