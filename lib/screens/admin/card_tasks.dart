// ignore_for_file: deprecated_member_use

import 'package:country_flags/country_flags.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fifa2022/config/constants.dart';
import 'package:fifa2022/config/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardTaskData {
  final String label;
  final DateTime birthDate;
  final String label2;
  final bool isFan;
  String nationality;
  final Gender gender;
  final String email;

  CardTaskData({
    required this.label,
    required this.birthDate,
    required this.label2,
    required this.isFan,
    required this.email,
    required this.gender,
    this.nationality="",
  });
}

class CardTask extends StatelessWidget {
  const CardTask({
    required this.data,
    required this.primary,
    required this.onPrimary,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final CardTaskData data;
  final Color primary;
  final Color onPrimary;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        child: InkWell(
          onTap: () {},
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [mainRed, mainRed.withOpacity(.7)],
                begin: AlignmentDirectional.topCenter,
                end: AlignmentDirectional.bottomCenter,
              ),
            ),
            child: _BackgroundDecoration(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLabel(),
                          Expanded(child: _buildLabel2()),
                          Expanded(child: _buildLabel3()),
                          _buildGender(),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDate(data.birthDate, Colors.white),
                        SizedBox(
                          height: 20,
                          child: VerticalDivider(
                            thickness: 1,
                            color: onPrimary,
                          ),
                        ),
                        _buildRole(data.isFan),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        doneButton("Accept", Colors.white, mainRed,
                            EvaIcons.checkmarkCircle2Outline,onPressed

                        ),
                        CountryFlags.flag("eg",width: 20,height: 20,)

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      data.label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: "Montserrat",

        color: onPrimary,
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
  Widget _buildLabel2() {
    return Text(
      data.label2,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onPrimary,
        fontFamily: "Montserrat",
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLabel3() {
    return Text(
      data.email,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white70,
        fontFamily: "Montserrat",
        letterSpacing: 1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildGender() {
    return Container(
      decoration: BoxDecoration(
        color: onPrimary.withOpacity(.3),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(data.gender==Gender.female?Icons.female:Icons.male, size: 15,
          color: Colors.white,),
          const SizedBox(width: 2,),
          Text(
            data.gender.name,
            style: TextStyle(
              color: onPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }



  Widget _buildRole(bool isFan) {
    return IconLabel(
      color: onPrimary,
      iconData: isFan?Icons.people_alt_rounded:CupertinoIcons.person_crop_circle_fill,
      label: isFan?"Fan":"Manager",
    );
  }


}
Widget doneButton(String text, Color primary, Color onPrimary, IconData  icon, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
    primary: primary,
      onPrimary: onPrimary
    ),
    icon:  Icon(icon,
      color: onPrimary,),
    label:  Text(text, style: TextStyle(
        color: onPrimary
    ),),
  );
}
Widget buildDate(DateTime dateTime, Color color) {
  return IconLabel(
    color: color,
    iconData: Icons.cake,
    label: DateFormat('d MMM yy').format(dateTime),
  );
}
class IconLabel extends StatelessWidget {
  const IconLabel({
    required this.color,
    required this.iconData,
    required this.label,
    Key? key,
  }) : super(key: key);

  final Color color;
  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(.8),
          ),
        )
      ],
    );
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.child, Key? key})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Transform.translate(
            offset: const Offset(25, -25),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Transform.translate(
            offset: const Offset(-70, 70),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white.withOpacity(.1),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
