import 'package:flutter/material.dart';

const Color mainRed= Color(0xff96253C);
const Color backGround= Color(0xffFBFBFB);
const kFontColorPallets = [
  Color.fromRGBO(26, 31, 56, 1),
  Color.fromRGBO(72, 76, 99, 1),
  Color.fromRGBO(149, 149, 163, 1),
];
const kBorderRadius = 10.0;
const kSpacing = 20.0;
class Font {
  static const nunito = 'Nunito';
}

class ImageAnimationPath {
  // you can get free animation image from rive or lottiefiles

  // Example:
  // static const _folderPath = "assets/images/animation";
  // static const myAnim = "$_folderPath/my_anim.json";
}

class ImageRasterPath {
  static const _folderPath = "assets/images/raster";
  static const man = "$_folderPath/man.png";
// static const myRaster2 = "$_folderPath/my_raster2.jpg";
// static const myRaster3 = "$_folderPath/my_raster3.jpeg";
}

class ImageVectorPath {
  // Example:
  // static const _folderPath = "assets/images/vector";
  // static const myVector = "$_folderPath/vector/my_vector.svg";
}
