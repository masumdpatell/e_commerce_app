import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:play_spots/utils/Dimensions.dart';

class NoDataPage extends StatelessWidget {
  final String text;
  final String imgPath;
  const NoDataPage(
      {Key? key,
      required this.text,
      this.imgPath = "assets/image/empty_cart.png"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: Dimensions.all1 * 0.1,
        ),
        Image.asset(
          imgPath,
          height: Dimensions.all1 * 0.22,
          width: Dimensions.all1 * 0.22,
        ),
        SizedBox(
          height: Dimensions.all1 * 0.03,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: Dimensions.all1 * 0.0175,
            color: Theme.of(context).disabledColor,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
