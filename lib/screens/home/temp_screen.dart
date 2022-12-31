import 'package:fifa2022/config/globals.dart';
import 'package:fifa2022/models/user.dart';
import 'package:fifa2022/providers/user/user_provider.dart';
import 'package:fifa2022/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TempScreen extends StatefulWidget {
  final Widget child;
  const TempScreen({Key? key, required this.child}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    animationController=   AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
    getUserInfo();

  }
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();

    super.dispose();
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
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
