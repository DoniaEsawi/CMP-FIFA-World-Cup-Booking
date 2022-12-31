
// ignore_for_file: library_private_types_in_public_api

import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/router/fluru.dart';
import 'package:fifa2022/screens/Auth/auth_widgets.dart';
import 'package:fifa2022/screens/shared_widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:video_player/video_player.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key,
    required this.isLogin
  }) : super(key: key);
  final bool isLogin;
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {


  late VideoPlayerController _controller;
  late bool isSignUp;
  late int tabSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSignUp=!widget.isLogin;
    tabSelected= (isSignUp?2:1);
    _controller = VideoPlayerController.asset(
        'assets/videos/intro.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
        });
      });
    _controller.play();
    _controller.setLooping(true);
    _controller.setVolume(0);

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;

    return NotificationListener(
      onNotification: (SizeChangedLayoutNotification notification){
        if(screenWidth<=1366) {
          _controller.pause();
        }
        else
          {
            if(_controller.value.isPlaying==false)
              {
                _controller.play();
              }
          }
        return true;
      },
      child: SizeChangedLayoutNotifier(

        child: Scaffold(
          backgroundColor: backGround,
          extendBodyBehindAppBar: true,
          appBar: AppBarCustom(page:widget.isLogin?Pages.login:Pages.register,),
          body: screenWidth>1366?
          Stack(
            alignment: Alignment.center,
            children: [

              Positioned(left: 50,child: IntroCircle(screenHeight: screenHeight, controller: _controller)),
              Positioned(
                right: -0.5*screenHeight,
                child: CircleContainerAuth(screenHeight: screenHeight,
                child: Container(
                  margin: EdgeInsets.only(right: 0.5*screenHeight, top:  (isSignUp?0.4:0.5)
                      *screenHeight),
                  child: Center(
                    child: !isSignUp?LoginForm(screenHeight: screenHeight,
                        isSmallScreen: false,
                        ):
                    SignUpForm(screenHeight: screenHeight,
                        isSmallScreen: false,
                        ),
                  ),
                ),),
              )
            ],
          ):Center(
            child: SizedBox(
              width: screenWidth,
              child: Center(
                child: SizedBox(
                  width: 375,
                  child: Container(
                    height: 500,
                    width: 375,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0,3),
                                blurRadius: 30
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(child: !isSignUp?
                        LoginForm(screenHeight: screenHeight,
                            isSmallScreen:true,):
                        SignUpForm(screenHeight: screenHeight,
                          isSmallScreen:true,
                        ))
                          )

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

