import 'package:fifa2022/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UnauthorizedWidget extends StatelessWidget {
  const UnauthorizedWidget({
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
              const Text("Oops! Private space!",
                style: TextStyle(
                    fontFamily: "kalam",
                    fontSize: 48,
                    color: mainRed,
                    fontWeight: FontWeight.w700
                ),
              ),
              SvgPicture.asset("assets/images/unauthorized.svg",width: 500,),
              const SizedBox(height: 16,),

              const Text("fine, we'll believe in you pure intention and that you just forgot to log in... have a good day :)",
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
