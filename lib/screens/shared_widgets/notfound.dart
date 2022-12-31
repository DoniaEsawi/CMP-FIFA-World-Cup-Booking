import 'package:fifa2022/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotFound extends StatelessWidget {
  const NotFound({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sorry, Not Found",
                  style: TextStyle(
                      fontFamily: "kalam",
                      fontSize: 48,
                      color: mainRed,
                      fontWeight: FontWeight.w700
                  ),
                ),
                SvgPicture.asset("assets/images/notfound.svg",width: 500,),
                const SizedBox(height: 16,),
                const Text("maybe you have a typo? kindly, recheck and try again ..",
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
