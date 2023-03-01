import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:play_spots/utils/colors.dart';

import '../../Utils/Dimensions.dart';

List buttons = [
  "Cricket",
  "Basketball",
  "Handball",
  "Badminton",
  "Hockey",
  "Football",
  "Vollyball",
  "Golf",
  "Swimming",
  "Tennis",
  "Baseball",
  "Ice Hockey",
  "Rugby",
  "Archery",
  "Cycling",
  "Surfing",
  "Boxing",
  "Shooting",
];

Widget SportsGroupButton() {
  return Container(
    color: white,
    child: GroupButton(
      options: GroupButtonOptions(
        selectedTextStyle: TextStyle(
          fontFamily: GoogleFonts.varelaRound().fontFamily,
          fontWeight: FontWeight.bold,
          color: white,
        ),
        unselectedTextStyle: TextStyle(
          fontFamily: GoogleFonts.varelaRound().fontFamily,
          color: textColor.withAlpha(180),
        ),
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.all1 * 7)),
        unselectedBorderColor: mainColor,
        selectedBorderColor: mainColor,
        spacing: Dimensions.all1 * 10,
        unselectedColor: transparent,
        selectedColor: mainColor,
      ),
      buttons: buttons,
      isRadio: true,
    ),
  );
}
