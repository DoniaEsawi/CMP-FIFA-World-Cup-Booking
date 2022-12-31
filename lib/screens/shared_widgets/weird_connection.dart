import 'package:fifa2022/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeirdConnection extends StatelessWidget {
  const WeirdConnection({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("This is weird connection, really",
                style: TextStyle(
                    fontFamily: "kalam",
                    fontSize: 48,
                    color: mainRed,
                    fontWeight: FontWeight.w700
                ),
              ),
              SvgPicture.asset("assets/images/weirdconnection.svg",width: 500,),
              const SizedBox(height: 16,),

              const Text("kindly, check your internet connection, I'll give you a hint; restart the router :D",
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
    );
  }
}
