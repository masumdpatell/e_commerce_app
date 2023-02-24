import 'package:play_spots/Pages/Home/sports_group_button.dart';
import 'package:play_spots/Widgets/big_text.dart';
import 'package:play_spots/Widgets/small_text.dart';
import 'package:play_spots/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:play_spots/utils/colors.dart';

import 'food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    print("current height => " + MediaQuery.of(context).size.height.toString());
    print("current width => " + MediaQuery.of(context).size.width.toString());
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height5 * 10,
                bottom: Dimensions.height5 * 4,
              ),
              padding: EdgeInsets.only(
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/image/logo_name.png",
                    height: 30,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BigText(
                              text: "Mumbai",
                              color: textColor,
                              size: 18,
                            ),
                            SmallText(
                              text: "Maharashtra, India",
                              color: black54,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        "assets/image/placeholder.png",
                        height: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(color: white, child: SportsGroupButton()),
                )),
          ),
          Expanded(
              child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: FoodPageBody(),
          )),
        ],
      ),
    );
  }
}
