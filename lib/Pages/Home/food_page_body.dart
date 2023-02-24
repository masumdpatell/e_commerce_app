import 'package:google_fonts/google_fonts.dart';
import 'package:play_spots/Controllers/popular_product_controller.dart';
import 'package:play_spots/Models/product_model.dart';
import 'package:play_spots/Pages/Food/popular_food_details.dart';
import 'package:play_spots/Routes/route_helper.dart';
import 'package:play_spots/Widgets/app_column.dart';
import 'package:play_spots/Widgets/big_text.dart';
import 'package:play_spots/Widgets/icon_text_widget.dart';
import 'package:play_spots/Widgets/small_text.dart';
import 'package:play_spots/utils/colors.dart';
import 'package:play_spots/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Controllers/recommended_product_controller.dart';

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.9);
  var currentPageValue = 0.0;
  var scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BigText(
                text: "Top picks for you",
                textWeight: FontWeight.bold,
                color: textColor.withAlpha(220),
              ),
              BigText(
                text: "View All",
                color: mainColor,
                size: 16,
              )
            ],
          ),
        ),
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return popularProducts.isLoaded
              ? SizedBox(
                  height: Dimensions.pageView,
                  child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: pageController,
                      itemCount: popularProducts.popularProductList.length,
                      itemBuilder: (context, position) {
                        return BuildPageItem(position,
                            popularProducts.popularProductList[position]);
                      }),
                )
              : CircularProgressIndicator(
                  color: mainColor,
                );
        }),
        GetBuilder<PopularProductController>(builder: (popularProducts) {
          return SmoothPageIndicator(
            onDotClicked: (index) {},
            controller: pageController,
            count: popularProducts.popularProductList.isEmpty
                ? 1
                : popularProducts.popularProductList.length,
            effect: WormEffect(
              dotHeight: 10,
              dotWidth: 10,
              spacing: 10,
              dotColor: black26,
              activeDotColor: mainColor,
              type: WormType.normal,
              // strokeWidth: 5,
            ),
          );
        }),
        SizedBox(
          height: Dimensions.height30,
        ),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            BigText(text: "Recommended"),
            SizedBox(
              width: Dimensions.width10,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 3),
              child: BigText(
                text: ".",
                color: black26,
              ),
            ),
            SizedBox(width: Dimensions.width10),
            Container(
                margin: EdgeInsets.only(bottom: 2),
                child: SmallText(text: "Food Pairing"))
          ]),
        ),
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct) {
          return recommendedProduct.isLoaded
              ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recommendedProduct.recommendedProductList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            RouteHelper.getRecommendedFood(index, "home"));
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20,
                            bottom: Dimensions.width10),
                        child: Row(children: [
                          Container(
                            height: Dimensions.listViewImgSize,
                            width: Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                color: white38,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      // AssetImage("assets/image/food1.jpg"),

                                      NetworkImage(recommendedProduct
                                          .recommendedProductList[index].img!),
                                )),
                          ),
                          Expanded(
                            child: Container(
                              height: Dimensions.listViewTextContSize,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                      Radius.circular(Dimensions.radius20),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.width10,
                                  right: Dimensions.width20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BigText(
                                      text: recommendedProduct
                                          .recommendedProductList[index].name!,
                                      size: Dimensions.font20,
                                    ),
                                    SizedBox(
                                      height: Dimensions.height10,
                                    ),
                                    SmallText(
                                        text: "With chinese characteristics"),
                                    SizedBox(
                                      height: Dimensions.height10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconTextWidget(
                                            icon: Icons.currency_rupee_rounded,
                                            text: recommendedProduct
                                                .recommendedProductList[index]
                                                .price!
                                                .toString(),
                                            size: Dimensions.font16,
                                            iconColor: paraColor),
                                        IconTextWidget(
                                            icon: Icons.restaurant,
                                            text: 'Shreeji',
                                            iconColor: iconColor2),
                                        Container(
                                          height: Dimensions.iconSize24,
                                          width: Dimensions.iconSize24,
                                          decoration: BoxDecoration(
                                            color: white38,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(recommendedProduct
                                                          .recommendedProductList[
                                                              index]
                                                          .vegNonVeg ==
                                                      "veg"
                                                  ? "assets/image/veg.png"
                                                  : "assets/image/non_veg.png"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    );
                  })
              : CircularProgressIndicator(
                  color: mainColor,
                );
        }),
      ],
    );
  }

  Widget BuildPageItem(int index, ProductModel popularProduct) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == currentPageValue.floor()) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() + 1) {
      var currScale =
          scaleFactor + (currentPageValue - index + 1) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else if (index == currentPageValue.floor() - 1) {
      var currScale = 1 - (currentPageValue - index) * (1 - scaleFactor);
      var currTrans = _height * (1 - currScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, currTrans, 0);
    } else {
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)
        ..setTranslationRaw(0, _height * (1 - scaleFactor) / 2, 1);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
                height: Dimensions.pageViewTextContainer,
                width: Dimensions.screenWidth / 1.6,
                margin: EdgeInsets.only(
                  left: Dimensions.width10,
                  right: Dimensions.width10,
                  // bottom: Dimensions.height30,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffe8e8e8),
                        offset: Offset(0, 5),
                        blurRadius: 5.0,
                      ),
                      BoxShadow(
                        color: Color(0xffe8e8e8),
                        offset: Offset(-5, 0),
                        blurRadius: 3.0,
                      ),
                      BoxShadow(
                        color: Color(0xffe8e8e8),
                        offset: Offset(5, 0),
                        blurRadius: 3.0,
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 10, 20, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        text: popularProduct.name!,
                        size: 16,
                      ),
                      SmallText(
                        text: popularProduct.name!,
                        color: black26,
                        size: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 15,
                            width: 100,
                            child: Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularProduct.id,
                                  itemBuilder: (context, position) {
                                    return Container(
                                      margin: EdgeInsets.only(right: 5),
                                      height: 15,
                                      width: 15,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              popularProduct.img.toString()),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: textColor2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                "Book",
                                style: TextStyle(
                                    color: white,
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(RouteHelper.getPopularFood(index, "home"));
              },
              child: Container(
                height: Dimensions.pageViewContainer,
                width: Dimensions.pageViewContainer,
                margin: EdgeInsets.only(
                    // left: Dimensions.width10,
                    // right: Dimensions.width45 * 4,
                    ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffe8e8e8),
                      offset: Offset(5, 0),
                      blurRadius: 3.0,
                    ),
                    BoxShadow(
                      color: Color(0xffe8e8e8),
                      offset: Offset(-5, 0),
                      blurRadius: 7.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: index.isEven ? Color(0xFF69C5DF) : Color(0xff9294cc),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(popularProduct.img!),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
