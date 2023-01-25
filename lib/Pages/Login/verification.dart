import 'dart:async';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:e_commerce_app/Pages/Login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../Routes/route_helper.dart';
import '../../Utils/colors.dart';

bool verifyBtn = false;
bool otpTimeOut = false;
bool successfulAnimation = false;

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int timeLeft = 20;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      dismissDirection: DismissDirection.down,
      elevation: 0,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      content: AwesomeSnackbarContent(
        title: 'Invalid OTP!',
        message: 'Wrong OTP! Please Enter Valid OTP..',
        contentType: ContentType.failure,
      ),
    );

    final snackBarResend = SnackBar(
      dismissDirection: DismissDirection.down,
      elevation: 0,
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: transparent,
      content: AwesomeSnackbarContent(
        title: 'OTP Sent',
        message: 'New otp sent on ${countrycode} ${phoneNumber.text}',
        contentType: ContentType.success,
      ),
    );

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: textColor2,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: textColor2, width: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: mainColor),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: pinBgColor,
      ),
    );

    var code = "";

    final CountdownController _countDownController =
        new CountdownController(autoStart: true);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.offNamed(RouteHelper.getAuthentication());
            loginBtnEnable = false;
            otpTimeOut = true;
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: textColor,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter OTP",
                        style: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: textColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter the verification code send to,",
                            style: TextStyle(
                              fontFamily: GoogleFonts.varelaRound().fontFamily,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${countrycode} ${phoneNumber.text}",
                            style: TextStyle(
                              fontFamily: GoogleFonts.varelaRound().fontFamily,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Pinput(
                          length: 6,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          showCursor: true,
                          onChanged: (value) {
                            code = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          height: 45,
                          width: 330,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 1,
                              backgroundColor: textColor2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              _countDownController.start();
                              try {
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: LoginScreen.verify,
                                        smsCode: code);
                                await auth.signInWithCredential(credential);

                                setState(() {
                                  successfulAnimation = true;
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 1100));
                                // ignore: use_build_context_synchronously
                                Get.offNamed(RouteHelper.getProfile());
                                setState(() {
                                  successfulAnimation = false;
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Text(
                              "Verify",
                              style: TextStyle(
                                  color: white,
                                  fontFamily: GoogleFonts.ubuntu().fontFamily,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.offNamed(RouteHelper.getAuthentication());
                              },
                              child: Text(
                                "Change number",
                                style: TextStyle(
                                    color: textColor,
                                    fontFamily:
                                        GoogleFonts.varelaRound().fontFamily,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                otpTimeOut
                                    ? Text("")
                                    : Countdown(
                                        controller: _countDownController,
                                        seconds: timeLeft,
                                        build: (_, double time) => Text(
                                          time.toInt().toString(),
                                          style: TextStyle(
                                              color: textColor,
                                              fontFamily:
                                                  GoogleFonts.varelaRound()
                                                      .fontFamily,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        interval: Duration(milliseconds: 100),
                                        onFinished: () {
                                          setState(() {
                                            print("OTP TRUE" +
                                                otpTimeOut.toString());
                                            otpTimeOut = true;
                                          });
                                        },
                                      ),
                                Text(
                                  otpTimeOut ? "" : " | ",
                                  style: TextStyle(
                                      color: textColor,
                                      fontFamily:
                                          GoogleFonts.varelaRound().fontFamily,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                InkWell(
                                  highlightColor: mainColor,
                                  splashColor: mainColor,
                                  child: GestureDetector(
                                      child: Text(
                                        "Resend OTP",
                                        style: TextStyle(
                                            color:
                                                otpTimeOut ? textColor : grey,
                                            fontFamily:
                                                GoogleFonts.varelaRound()
                                                    .fontFamily,
                                            fontSize: 18.0,
                                            fontWeight: otpTimeOut
                                                ? null
                                                : FontWeight.bold),
                                      ),
                                      onTap: () async {
                                        await FirebaseAuth.instance
                                            .verifyPhoneNumber(
                                          phoneNumber:
                                              '${countrycode + phoneNumber.text}',
                                          verificationCompleted:
                                              (phoneAuthCredential) {},
                                          verificationFailed:
                                              (FirebaseAuthException e) {},
                                          codeSent: (String verificationId,
                                              forceResendingToken) {
                                            LoginScreen.verify = verificationId;
                                            ScaffoldMessenger.of(context)
                                              ..showSnackBar(snackBarResend);
                                            Get.offNamed(RouteHelper.getOTP());
                                            setState(() {
                                              otpTimeOut = false;
                                            });
                                          },
                                          timeout: Duration(seconds: timeLeft),
                                          codeAutoRetrievalTimeout:
                                              (verificationId) {
                                            Duration(seconds: timeLeft);
                                          },
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          successfulAnimation
              ? Center(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Lottie.asset("assets/lottie/successful.json")),
                )
              : Container()
        ],
      ),
    );
  }
}
