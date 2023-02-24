import 'package:play_spots/Pages/Login/login_email.dart';
import 'package:play_spots/Pages/Cart/cart_page.dart';
import 'package:play_spots/Pages/Food/popular_food_details.dart';
import 'package:play_spots/Pages/Food/recommended_food_details.dart';
import 'package:play_spots/Pages/Home/home_page.dart';
import 'package:play_spots/Pages/Login/login_screen.dart';
import 'package:play_spots/Pages/Login/verification.dart';
import 'package:play_spots/Pages/Payment/razor_pay.dart';
import 'package:play_spots/Pages/Profile/profile_page.dart';
import 'package:play_spots/Pages/Splash/splash_screen.dart';
import 'package:get/get.dart';

import '../Pages/Home/main_food_page.dart';

class RouteHelper {
  static const String splashScreen = "/splash=screen";
  static const String authentication = "/authntication";
  static const String emailLogin = "/email-login";
  static const String otpVerify = "/otp-verify";
  static const String profilePage = "/profile-page";
  static const String razorPayment = "/razorPayment";
  static const String initial = "/navigation-bar";
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";

  static String getSplashScreen() => '$splashScreen';
  static String getAuthentication() => '$authentication';
  static String getEmailLogin() => '$emailLogin';
  static String getOTP() => '$otpVerify';
  static String getProfile() => '$profilePage';
  static String getInitial() => '$initial';
  static String getRazorPayment() => '$razorPayment';
  static String getPopularFood(int pageId, String page) =>
      '$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page) =>
      '$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage() => '$cartPage';

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: authentication, page: () => LoginScreen()),
    GetPage(name: emailLogin, page: () => LoginEmail()),
    GetPage(name: otpVerify, page: () => MyVerify()),
    GetPage(name: profilePage, page: () => MyProfilePage()),
    GetPage(name: initial, page: () => HomePage()),
    GetPage(name: razorPayment, page: () => RazorPayment()),
    GetPage(
        name: popularFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters["page"];
          return PopularFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
        name: recommendedFood,
        page: () {
          var pageId = Get.parameters['pageId'];
          var page = Get.parameters["page"];
          return RecommendedFoodDetail(pageId: int.parse(pageId!), page: page!);
        },
        transition: Transition.fadeIn),
    GetPage(
      name: cartPage,
      page: () {
        return CartPage();
      },
      transition: Transition.fadeIn,
    )
  ];
}
