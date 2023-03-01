import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottie/lottie.dart';
import 'package:play_spots/Pages/Login/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:play_spots/Services/auth_service.dart';

import '../../Routes/route_helper.dart';
import '../../Utils/Dimensions.dart';
import '../../utils/colors.dart';

Country? _selectedCountry;
final countrycode = _selectedCountry!.callingCode;
bool loginBtnEnable = false;
bool loadingAnimation = false;
TextEditingController emailController = TextEditingController();
TextEditingController userName = TextEditingController();
TextEditingController birthDate = TextEditingController();
TextEditingController phoneNumber = TextEditingController();

class LoginScreen extends StatefulWidget {
  @override
  static String verify = "";

  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final snackBar = SnackBar(
    dismissDirection: DismissDirection.down,
    elevation: 0,
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
    backgroundColor: transparent,
    content: AwesomeSnackbarContent(
      title: 'OTP Sent Successfully!',
      message: 'Please, Enter OTP ASAP..',
      contentType: ContentType.success,
    ),
  );

  final snackBarWrongNo = SnackBar(
    dismissDirection: DismissDirection.down,
    elevation: 0,
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    backgroundColor: transparent,
    content: AwesomeSnackbarContent(
      title: 'Invalid Mobile Number',
      message:
          'Please, Enter Valid Mobile Number.., This Mobile Number is not Exist !',
      contentType: ContentType.failure,
    ),
  );

  int timeLeft = 20;

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  @override
  Widget build(BuildContext context) {
    final country = _selectedCountry;
    return Scaffold(
      body: GestureDetector(
        onLongPress: () {
          print("current height => " +
              MediaQuery.of(context).size.height.toString());
          print("current width => " +
              MediaQuery.of(context).size.width.toString());
          setState(() {
            loadingAnimation = false;
          });
        },
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimensions.width10 * 3,
                    Dimensions.height10 * 8,
                    Dimensions.width10 * 3,
                    0,
                  ),
                  child: Center(
                      child: Column(
                    children: [
                      Image.asset(
                        "assets/image/logo.png",
                        width: Dimensions.width10 * 18,
                        height: Dimensions.width10 * 12,
                      ),
                      Text(
                        "Join the Play Spots community",
                        style: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font20,
                          color: textColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.width10 * 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                              fontFamily: GoogleFonts.varelaRound().fontFamily,
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w100,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Dimensions.width15,
                          left: Dimensions.width1 * 7,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: onPressedShowBottomSheet,
                              child: Image.asset(
                                country!.flag,
                                package: countryCodePackageName,
                                width: Dimensions.width10 * 3.5,
                              ),
                            ),
                            InkWell(
                              onTap: onPressedShowBottomSheet,
                              child: Text(
                                '   ${country.callingCode}',
                                style: TextStyle(
                                    fontSize: Dimensions.font16,
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: Dimensions.width1 * 7),
                              color: grey,
                              width: Dimensions.all1 * 1.1,
                              height: Dimensions.all1 * 25,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: Dimensions.all1 * 7),
                                child: TextFormField(
                                  controller: phoneNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      loginBtnEnable =
                                          value.length >= 9 ? true : false;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: Dimensions.all1 * 16,
                                      fontFamily:
                                          GoogleFonts.varelaRound().fontFamily),
                                  textAlignVertical: TextAlignVertical.center,
                                  // autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone Number",
                                    hintStyle: TextStyle(
                                        fontSize: Dimensions.all1 * 16,
                                        fontFamily: GoogleFonts.varelaRound()
                                            .fontFamily),
                                    suffixIcon: Icon(
                                      Icons.phone_enabled,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: grey,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.all1 * 20),
                        child: SizedBox(
                          width: Dimensions.width10 * 30,
                          height: Dimensions.width10 * 5,
                          child: ElevatedButton(
                            onPressed: loginBtnEnable == true
                                ? () async {
                                    setState(() {
                                      loadingAnimation = true;
                                    });
                                    otpTimeOut = false;
                                    await FirebaseAuth.instance
                                        .verifyPhoneNumber(
                                      phoneNumber:
                                          '${countrycode + phoneNumber.text}',
                                      verificationCompleted:
                                          (phoneAuthCredential) {
                                        setState(() {
                                          loadingAnimation = false;
                                        });
                                      },
                                      verificationFailed:
                                          (FirebaseAuthException e) {
                                        setState(() {
                                          loadingAnimation = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                          ..showSnackBar(snackBarWrongNo);
                                      },
                                      codeSent: (String verificationId,
                                          forceResendingToken) {
                                        LoginScreen.verify = verificationId;
                                        ScaffoldMessenger.of(context)
                                          ..showSnackBar(snackBar);
                                        Get.offNamed(RouteHelper.getOTP());
                                      },
                                      timeout: Duration(seconds: timeLeft),
                                      codeAutoRetrievalTimeout:
                                          (verificationId) {
                                        Duration(seconds: timeLeft);
                                      },
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textColor2,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.all1 * 5),
                              ),
                            ),
                            child: Text(
                              "Sign up with phone number",
                              style: TextStyle(
                                  color: white,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                  fontSize: Dimensions.all1 * 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.all1 * 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: grey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.all1 * 7),
                              child: Text("OR"),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.all1 * 25),
                        child: SizedBox(
                          width: Dimensions.all1 * 300,
                          height: Dimensions.all1 * 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.toNamed(RouteHelper.getEmailLogin());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.all1 * 5),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/svg/gmail.svg',
                              height: Dimensions.all1 * 30,
                              width: Dimensions.all1 * 30,
                            ),
                            label: Text(
                              "Sign up with E-mail",
                              style: TextStyle(
                                  fontSize: Dimensions.all1 * 16,
                                  fontFamily:
                                      GoogleFonts.varelaRound().fontFamily,
                                  color: textColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.all1 * 25),
                        child: SizedBox(
                          width: Dimensions.all1 * 300,
                          height: Dimensions.all1 * 50,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                loadingAnimation = true;
                              });
                              await FirebaseServices()
                                  .signInWithGoogle(context);
                              setState(() {
                                loadingAnimation = false;
                                successfulAnimation = true;
                                photoGoogle = true;
                                userName.text = FirebaseAuth
                                    .instance.currentUser!.displayName
                                    .toString();
                                // phoneNumber.text = FirebaseAuth
                                //     .instance.currentUser!.phoneNumber
                                //     .toString();
                                emailController.text = FirebaseAuth
                                    .instance.currentUser!.email
                                    .toString();
                              });
                              await Future.delayed(
                                  const Duration(milliseconds: 1100));
                              setState(() {
                                successfulAnimation = false;
                              });
                              await Get.offNamed(RouteHelper.getProfile());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.all1 * 5),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/svg/google.svg',
                              height: Dimensions.all1 * 30,
                              width: Dimensions.all1 * 30,
                            ),
                            label: Text(
                              "Continue with Google",
                              style: TextStyle(
                                  fontSize: Dimensions.all1 * 16,
                                  fontFamily:
                                      GoogleFonts.varelaRound().fontFamily,
                                  color: textColor),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: Dimensions.all1 * 25),
                        child: SizedBox(
                          width: Dimensions.all1 * 300,
                          height: Dimensions.all1 * 50,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: white.withOpacity(0.9),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Dimensions.all1 * 5),
                              ),
                            ),
                            icon: SvgPicture.asset(
                              'assets/svg/facebook.svg',
                              height: Dimensions.all1 * 30,
                              width: Dimensions.all1 * 30,
                            ),
                            label: Text(
                              "Continue with Facebook",
                              style: TextStyle(
                                  fontSize: Dimensions.all1 * 16,
                                  fontFamily:
                                      GoogleFonts.varelaRound().fontFamily,
                                  color: textColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              ),
            ),
            loadingAnimation
                ? Center(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Lottie.asset(
                          "assets/lottie/loading_animation2.json",
                          height: Dimensions.all1 * 250,
                          width: Dimensions.all1 * 250,
                        )),
                  )
                : Container(),
            successfulAnimation
                ? Center(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Lottie.asset("assets/lottie/successful.json")),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheet(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }
}

class PickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CountryPickerWidget(
          showSeparator: true,
          onSelected: (country) => Navigator.pop(context, country),
        ),
      ),
    );
  }
}
