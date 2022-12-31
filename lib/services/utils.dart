import 'dart:math';

import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context,AnimationController controller)
async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (dialogContext) {
      return AnimatedBuilder(
        animation: controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: controller.value * 2 * pi,
            child: child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120,
                height: 120,
                child: Image.asset("assets/images/football_3d.png",width: 120,height: 120,)),
          ],
        ),
      );
    },
  );
}
void showErrorSnackBar(BuildContext context,String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message,
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
void showSuccessSnackBar(BuildContext context,String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message,
      style: const TextStyle(
          color: Colors.white
      ),
    ),
    backgroundColor: Colors.green,
    showCloseIcon: true,
    closeIconColor: Colors.black,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
