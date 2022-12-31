import 'package:adaptive_navbar/adaptive_navbar.dart';
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/router/fluru.dart';
import 'package:fifa2022/services/utils.dart';
import 'package:flutter/material.dart';
import 'dart:js'as js;

import 'package:provider/provider.dart';
class AppBarDemo extends StatelessWidget {
  const AppBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(page: Pages.home,),
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        color: Colors.red,
      ),
    );
  }
}

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget{

  const AppBarCustom({Key? key,required this.page}) : preferredSize = const Size.fromHeight(80), super(key: key);
  final Pages page;
  @override
  final Size preferredSize;
  @override
  _AppBarCustomState createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  @override
  void initState() {
    // TODO: implement initState
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10),
      child: AdaptiveNavBar(
        screenWidth: MediaQuery.of(context).size.width-450,
        leading: Container(),
        leadingWidth: 0,
        title: Image.asset(widget.page==Pages.register||widget.page==Pages.login||widget.page==Pages.match?"assets/images/logo_white.png":"assets/images/logo2.png",height: 45,),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        iconTheme:  IconThemeData(
          color: (widget.page==Pages.register||widget.page==Pages.login||widget.page==Pages.match)?Colors.white:mainRed,
        ),

        flexibleSpace: Image.asset("assets/images/playing.png",height: 80,
        ),
        backgroundColor: widget.page==Pages.register||widget.page==Pages.login||widget.page==Pages.match?mainRed:Colors.white,
        toolbarTextStyle: TextStyle(
          color: (widget.page==Pages.register||widget.page==Pages.login||widget.page==Pages.match)?Colors.white:mainRed,
          fontSize: 14,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.w600
        ),
        canTitleGetTapped: true,
        onTitleTapped: (){},

        navBarItems:Globals.isLoggedIn==false?
        [
          NavBarItem(
            text: "Home",

            onTap: () {
              if(widget.page!=Pages.home)
                {
                  Navigator.pushNamed(context, '/home');
                }
            },
          ),
          NavBarItem(
            text: "Matches",
            onTap: () {
              if(widget.page!=Pages.allMatches)
              {
              Navigator.pushNamed(context, '/matches');
              }
            },
          ),
          NavBarItem(
            text: "Login",
            onTap: () {
              if(widget.page!=Pages.login)
              {
               Navigator.pushNamed(context, '/login');
              }
            },
          ),
          NavBarItem(
            text: "Sign Up",
            onTap: () {
              if(widget.page!=Pages.register)
              {
               Navigator.pushNamed(context, '/register');
              }
            },
          ),
          NavBarItem(
            text: "About",
            onTap: () {
              js.context.callMethod('open', ['https://github.com/Raghad-Khaled/FIFA_World_Cup']);
            },
          ),
        ]:Globals.isManager?[
          NavBarItem(
          text: "Profile",
          onTap: () {
            Navigator.pushNamed(context, "/profile");
          },
          ),
          NavBarItem(
          text: "Home",

          onTap: () {
          if(widget.page!=Pages.home)
          {
          Navigator.pushNamed(context, '/home');
          }
          },
          ),
          NavBarItem(
          text: "Matches",
          onTap: () {
          if(widget.page!=Pages.allMatches)
          {
          Navigator.pushNamed(context, '/matches');
          }
          },
          ),
          NavBarItem(
          text: "Create",
          onTap: () {
          if(widget.page!=Pages.addMatch)
          {
          Navigator.pushNamed(context, '/addMatch');
          }
          },
          ),
          NavBarItem(
          text: "Log out",
          onTap: () {
            logOut();
          },
          ),
          NavBarItem(
          text: "About",
          onTap: () {
          js.context.callMethod('open', ['https://github.com/Raghad-Khaled/FIFA_World_Cup']);
          },
          ),
      ]:[
    NavBarItem(
    text: "Profile",
    onTap: () {
    Navigator.pushNamed(context, "/profile");
    },
    ),
    NavBarItem(
    text: "Home",

    onTap: () {
    if(widget.page!=Pages.home)
    {
    Navigator.pushNamed(context, '/home');
    }
    },
    ),
    NavBarItem(
    text: "Matches",
    onTap: () {
    if(widget.page!=Pages.allMatches)
    {
    Navigator.pushNamed(context, '/matches');
    }
    },
    ),

    NavBarItem(
    text: "Log out",
    onTap: () {
    logOut();
    },
    ),
    NavBarItem(
    text: "About",
    onTap: () {
    js.context.callMethod('open', ['https://github.com/Raghad-Khaled/FIFA_World_Cup']);
    },
    ),]
        ,
      ),
    );
  }
  void logOut()async{
    showAlertDialog(context, animationController);
    bool success=
        await Provider.of<AuthProvider>(context, listen: false).logoutUsers();
    Navigator.pop(context);
    if(success)
    {
      await Navigator.popAndPushNamed(context, '/login');
      const snackBar = SnackBar(
        content: Text('Successfully logged out!',
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
    else{
      const snackBar = SnackBar(
        content: Text('Failed to logout, try again later',
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

  }
}

