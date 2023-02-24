import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Utils/Dimensions.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  FontWeight textWeight;

  BigText(
      {Key? key,
      this.color = const Color(0xff332d2b),
      this.overFlow = TextOverflow.ellipsis,
      this.size = 0,
      this.textWeight = FontWeight.normal,
      required this.text,
      String? fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? 20 : size,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: textWeight,
      ),
    );
  }
}
