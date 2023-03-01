import 'package:play_spots/Controllers/popular_spot_controller.dart';
import 'package:play_spots/Pages/Login/login_email.dart';
import 'package:play_spots/Pages/Cart/cart_history.dart';
import 'package:play_spots/Pages/Cart/cart_page.dart';
import 'package:play_spots/Pages/Spot/popular_spot_details.dart';
import 'package:play_spots/Pages/Spot/recommended_spot_details.dart';
import 'package:play_spots/Pages/Home/home_page.dart';
import 'package:play_spots/Pages/Home/main_spot_page.dart';
import 'package:play_spots/Pages/Splash/splash_screen.dart';
import 'package:play_spots/Routes/route_helper.dart';
import 'package:play_spots/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Controllers/recommended_spot_controller.dart';
import 'helper/Dependencies.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dep.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Get.find<CartController>().getCartData();
    return GetBuilder<PopularProductController>(
      builder: (_) {
        return GetBuilder<RecommendedProductController>(builder: (_) {
          return GetMaterialApp(
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            initialRoute: RouteHelper.getSplashScreen(),
            getPages: RouteHelper.routes,
          );
        });
      },
    );
  }
}
