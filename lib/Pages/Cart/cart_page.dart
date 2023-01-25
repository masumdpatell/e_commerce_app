import 'package:e_commerce_app/Controllers/popular_product_controller.dart';
import 'package:e_commerce_app/Models/cart_model.dart';
import 'package:e_commerce_app/Pages/Home/main_food_page.dart';
import 'package:e_commerce_app/Routes/route_helper.dart';
import 'package:e_commerce_app/Widgets/app_icon.dart';
import 'package:e_commerce_app/Widgets/big_text.dart';
import 'package:e_commerce_app/Widgets/small_text.dart';
import 'package:e_commerce_app/utils/colors.dart';
import 'package:e_commerce_app/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../Base/no_data_page.dart';
import '../../Controllers/recommended_product_controller.dart';
import '../../Controllers/cart_controller.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final referenceDatabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: Dimensions.height20 * 3,
            left: Dimensions.width20,
            right: Dimensions.width20,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIcon(
                      icon: Icons.arrow_back_ios_rounded,
                      iconColor: white,
                      backgroundColor: mainColor,
                      iconSize: Dimensions.iconSize16,
                    ),
                    SizedBox(width: Dimensions.width30 * 6),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getInitial());
                      },
                      child: AppIcon(
                        icon: Icons.home_rounded,
                        iconColor: white,
                        backgroundColor: mainColor,
                        iconSize: Dimensions.iconSize20,
                      ),
                    ),
                    AppIcon(
                      icon: Icons.shopping_cart_rounded,
                      iconColor: white,
                      backgroundColor: mainColor,
                      iconSize: Dimensions.iconSize20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GetBuilder<CartController>(
            builder: (_cartController) {
              return _cartController.getItems.length > 0
                  ? Positioned(
                      top: Dimensions.height20 * 6,
                      left: Dimensions.width20,
                      right: Dimensions.width20,
                      bottom: 0,
                      child: Container(
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: GetBuilder<CartController>(
                            builder: (cartController) {
                              var _cartList = cartController.getItems;
                              return ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: _cartList.length,
                                itemBuilder: (_, index) {
                                  return Container(
                                    height: Dimensions.height20 * 5,
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            var popularIndex = Get.find<
                                                    PopularProductController>()
                                                .popularProductList
                                                .indexOf(
                                                    _cartList[index].product!);

                                            if (popularIndex >= 0) {
                                              Get.toNamed(
                                                  RouteHelper.getPopularFood(
                                                      popularIndex,
                                                      "cartPage"));
                                            } else {
                                              var recommendedIndex = Get.find<
                                                      RecommendedProductController>()
                                                  .recommendedProductList
                                                  .indexOf(_cartList[index]
                                                      .product!);
                                              if (recommendedIndex < 0) {
                                                Get.snackbar(
                                                  "History Product",
                                                  "Product review is not available for history products!",
                                                  backgroundColor: mainColor,
                                                  colorText: white,
                                                );
                                              } else {
                                                Get.toNamed(RouteHelper
                                                    .getRecommendedFood(
                                                        recommendedIndex,
                                                        "cartPage"));
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: Dimensions.width20 * 5,
                                            height: Dimensions.height20 * 5,
                                            margin: EdgeInsets.only(
                                                bottom: Dimensions.height10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radius20),
                                              color: white,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    cartController
                                                        .getItems[index].img!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: Dimensions.width10),
                                        Expanded(
                                          child: Container(
                                            height: Dimensions.height20 * 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                BigText(
                                                  text: cartController
                                                      .getItems[index].name!,
                                                  color: black54,
                                                ),
                                                SmallText(text: "Spicy"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    BigText(
                                                      text: "\₹ " +
                                                          cartController
                                                              .getItems[index]
                                                              .price!
                                                              .toString(),
                                                      color: redAccent,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                        Dimensions.width10,
                                                        Dimensions.height10,
                                                        Dimensions.width10,
                                                        Dimensions.height10,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          Dimensions.radius20,
                                                        ),
                                                        color: white,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartController.addItem(
                                                                  _cartList[
                                                                          index]
                                                                      .product!,
                                                                  -1);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .remove_rounded,
                                                              color: signColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: Dimensions
                                                                .width5,
                                                          ),
                                                          BigText(
                                                              text: _cartList[
                                                                      index]
                                                                  .quantity
                                                                  .toString()),
                                                          SizedBox(
                                                            width: Dimensions
                                                                .width5,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              cartController.addItem(
                                                                  _cartList[
                                                                          index]
                                                                      .product!,
                                                                  1);
                                                            },
                                                            child: Icon(
                                                              Icons.add_rounded,
                                                              color: signColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  : NoDataPage(text: "Your Cart Is Empty!");
            },
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (cartController) {
          return Container(
              height: Dimensions.bottomNavBarHeight,
              padding: EdgeInsets.fromLTRB(
                Dimensions.width20,
                Dimensions.height30,
                Dimensions.width20,
                Dimensions.height30,
              ),
              decoration: BoxDecoration(
                color: cartController.getItems.length > 0
                    ? buttonBackgroundColor
                    : transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2),
                ),
              ),
              child: cartController.getItems.length > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            Dimensions.width20,
                            Dimensions.height20,
                            Dimensions.width20,
                            Dimensions.height20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.radius20,
                            ),
                            color: white,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                              BigText(
                                  text: "\₹ " +
                                      cartController.totalAmount.toString()),
                              SizedBox(
                                width: Dimensions.width5,
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteHelper.getRazorPayment());

                            final user = FirebaseAuth.instance.currentUser;

                            ref.child(user!.uid).get();
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              Dimensions.width20,
                              Dimensions.height20,
                              Dimensions.width20,
                              Dimensions.height20,
                            ),
                            child: BigText(
                              text: "Pay Now",
                              color: white,
                              size: Dimensions.font20,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius20),
                              color: mainColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container());
        },
      ),
    );
  }
}
