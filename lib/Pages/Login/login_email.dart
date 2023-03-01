import 'dart:io';
import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:lottie/lottie.dart';
import 'package:play_spots/Pages/Login/verification.dart';
import 'package:play_spots/utils/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Routes/route_helper.dart';
import '../../utils/dimensions.dart';
import '../Profile/profile_page.dart';
import 'login_screen.dart';

bool isSignUpScreen = true;
bool isPasswordField = false;
bool isPassworduppercase = false;
bool isPasswordnumber = false;
bool isPasswordspecialcharacter = false;
bool eyeTap = false;
bool successfulAnimation = false;

class LoginEmail extends StatefulWidget {
  @override
  State<LoginEmail> createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final auth = FirebaseAuth.instance;
  late String emailLogIn = "", _passwordLogIn = "";
  late String _emailSignUp = "", _passwordSignUp = "";

  final storage = new FlutterSecureStorage();

  final snackBar = SnackBar(
    dismissDirection: DismissDirection.down,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: transparent,
    content: AwesomeSnackbarContent(
      title: 'Wrong Credential',
      message: 'Re-Enter Email & Password !!',
      contentType: ContentType.failure,
    ),
  );

  final snackBarSignUpScs = SnackBar(
    dismissDirection: DismissDirection.down,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: transparent,
    content: AwesomeSnackbarContent(
      title: 'Account Created',
      message: 'Your account has been created successfully !!',
      contentType: ContentType.success,
    ),
  );

  final snackBarSignUpFail = SnackBar(
    dismissDirection: DismissDirection.down,
    elevation: 0,
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating,
    backgroundColor: transparent,
    content: AwesomeSnackbarContent(
      title: 'Invalid ID or Password',
      message: 'Check your Email ID or Password Again !!',
      contentType: ContentType.warning,
    ),
  );

  onPasswordChanged(String value) {
    final ucaseRegex = RegExp(r'[A-Z]');
    setState(() {
      isPassworduppercase = false;
      if (ucaseRegex.hasMatch(value)) isPassworduppercase = true;
    });
    final numberRegex = RegExp(r'[0-9]');
    setState(() {
      isPasswordnumber = false;
      if (numberRegex.hasMatch(value)) isPasswordnumber = true;
    });
    final specialcharacterRegex = RegExp(r"[!@#$%^&*()]");
    setState(() {
      isPasswordspecialcharacter = false;
      if (specialcharacterRegex.hasMatch(value))
        isPasswordspecialcharacter = true;
    });
  }

  final referenceDatabase = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
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
          SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(Dimensions.all1 * 30,
                          Dimensions.all1 * 10, Dimensions.all1 * 165, 0),
                      child: Container(
                        height: Dimensions.all1 * 35,
                        width: Dimensions.all1 * 190,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.all1 * 50),
                          border: Border.all(
                              color: mainColor, width: Dimensions.all1 * 3),
                          color: buttonBackgroundColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignUpScreen = false;
                                });
                              },
                              child: isSignUpScreen
                                  ? Container(
                                      height: Dimensions.all1 * 35,
                                      width: Dimensions.all1 * 91,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Log In",
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.ubuntu().fontFamily,
                                          fontSize: Dimensions.all1 * 13.0,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: Dimensions.all1 * 35,
                                      width: Dimensions.all1 * 91,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.all1 * 50)),
                                      child: Text(
                                        "Log In",
                                        style: TextStyle(
                                            color: black,
                                            fontFamily:
                                                GoogleFonts.ubuntu().fontFamily,
                                            fontSize: Dimensions.all1 * 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSignUpScreen = true;
                                  });
                                },
                                child: isSignUpScreen
                                    ? Container(
                                        height: Dimensions.all1 * 35,
                                        width: Dimensions.all1 * 91,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.all1 * 50)),
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                              color: black,
                                              fontFamily: GoogleFonts.ubuntu()
                                                  .fontFamily,
                                              fontSize: Dimensions.all1 * 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Container(
                                        height: Dimensions.all1 * 35,
                                        width: Dimensions.all1 * 91,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.ubuntu().fontFamily,
                                            fontSize: Dimensions.all1 * 13.0,
                                          ),
                                        ),
                                      ))
                          ],
                        ),
                      ),
                    ),
                    isSignUpScreen
                        ? Form(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  Dimensions.all1 * 30,
                                  Dimensions.all1 * 30,
                                  Dimensions.all1 * 30,
                                  Dimensions.all1 * 30),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontSize: Dimensions.all1 * 17,
                                          letterSpacing: Dimensions.all1 * 1.3,
                                          fontFamily: GoogleFonts.varelaRound()
                                              .fontFamily,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: Dimensions.all1 * 5,
                                        bottom: Dimensions.all1 * 5,
                                      ),
                                      child: Text(
                                          "Welcome to PlaySpots! Let`s Play Together..",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: Dimensions.all1 * 14,
                                            fontFamily:
                                                GoogleFonts.varelaRound()
                                                    .fontFamily,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 0),
                                      child: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              _emailSignUp = value.trim();
                                            });
                                          },
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            hintText: "Enter E-mail",
                                            labelText: "Email",
                                            labelStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                            hintStyle: TextStyle(
                                                fontSize: Dimensions.all1 * 16),
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Dimensions.all1 * 5),
                                      child: TextField(
                                          obscureText: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _passwordSignUp = value.trim();
                                              onPasswordChanged(value);
                                            });
                                          },
                                          onTap: () async {
                                            await Future.delayed(
                                                Duration(milliseconds: 500));
                                            setState(() {
                                              isPasswordField = true;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Enter Password",
                                            labelText: "Password",
                                            labelStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7)),
                                            hintStyle: TextStyle(
                                                fontSize: Dimensions.all1 * 16),
                                          )),
                                    ),
                                    isPasswordField
                                        ? AnimatedContainer(
                                            curve: Curves.easeInOut,
                                            margin: EdgeInsets.only(
                                                top: Dimensions.all1 * 20),
                                            duration: Duration(seconds: 1),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Make The Strong Password",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts
                                                                    .varelaRound()
                                                                .fontFamily,
                                                        letterSpacing:
                                                            Dimensions.all1 *
                                                                1.7,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Dimensions.all1 *
                                                                13)),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          Dimensions.all1 * 20),
                                                  child: Row(
                                                    children: [
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height:
                                                            Dimensions.all1 *
                                                                13,
                                                        width: Dimensions.all1 *
                                                            13,
                                                        decoration: BoxDecoration(
                                                            color: isPassworduppercase
                                                                ? mainColor
                                                                : Colors
                                                                    .transparent,
                                                            border: isPassworduppercase
                                                                ? Border.all(
                                                                    color: Colors
                                                                        .transparent)
                                                                : Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: Dimensions
                                                                            .all1 *
                                                                        1.2),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                            .all1 *
                                                                        10)),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions.all1 *
                                                            20,
                                                      ),
                                                      Text(
                                                          "Contains at least one uppercase",
                                                          style: TextStyle(
                                                              fontFamily: GoogleFonts
                                                                      .varelaRound()
                                                                  .fontFamily,
                                                              letterSpacing:
                                                                  Dimensions
                                                                          .all1 *
                                                                      1.2,
                                                              fontSize:
                                                                  Dimensions
                                                                          .all1 *
                                                                      12))
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          Dimensions.all1 * 15),
                                                  child: Row(
                                                    children: [
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height:
                                                            Dimensions.all1 *
                                                                13,
                                                        width: Dimensions.all1 *
                                                            13,
                                                        decoration: BoxDecoration(
                                                            color: isPasswordnumber
                                                                ? mainColor
                                                                : Colors
                                                                    .transparent,
                                                            border: isPasswordnumber
                                                                ? Border.all(
                                                                    color: Colors
                                                                        .transparent)
                                                                : Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: Dimensions
                                                                            .all1 *
                                                                        1.2),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                            .all1 *
                                                                        10)),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions.all1 *
                                                            Dimensions.all1 *
                                                            20,
                                                      ),
                                                      Text(
                                                          "Contains at least one number",
                                                          style: TextStyle(
                                                              fontFamily: GoogleFonts
                                                                      .varelaRound()
                                                                  .fontFamily,
                                                              letterSpacing:
                                                                  Dimensions
                                                                          .all1 *
                                                                      1.2,
                                                              fontSize:
                                                                  Dimensions
                                                                          .all1 *
                                                                      12))
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top:
                                                          Dimensions.all1 * 15),
                                                  child: Row(
                                                    children: [
                                                      AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height:
                                                            Dimensions.all1 *
                                                                13,
                                                        width: Dimensions.all1 *
                                                            13,
                                                        decoration: BoxDecoration(
                                                            color: isPasswordspecialcharacter
                                                                ? mainColor
                                                                : Colors
                                                                    .transparent,
                                                            border: isPasswordspecialcharacter
                                                                ? Border.all(
                                                                    color: Colors
                                                                        .transparent)
                                                                : Border.all(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: Dimensions
                                                                            .all1 *
                                                                        1.2),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    Dimensions
                                                                            .all1 *
                                                                        10)),
                                                      ),
                                                      SizedBox(
                                                        width: Dimensions.all1 *
                                                            20,
                                                      ),
                                                      Text(
                                                          "Contains at least one special character",
                                                          style: TextStyle(
                                                              fontFamily: GoogleFonts
                                                                      .varelaRound()
                                                                  .fontFamily,
                                                              letterSpacing:
                                                                  Dimensions
                                                                          .all1 *
                                                                      1.2,
                                                              fontSize:
                                                                  Dimensions
                                                                          .all1 *
                                                                      12))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: Dimensions.all1 * 5,
                                          ),
                                    Center(
                                      child: Image.asset(
                                        "assets/image/signup.png",
                                        scale: Dimensions.all1 * 4,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: Dimensions.all1 *
                                              Dimensions.all1 *
                                              50),
                                      child: Material(
                                        color: textColor2,
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.all1 *
                                                Dimensions.all1 *
                                                15),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.all1 *
                                                  Dimensions.all1 *
                                                  15),
                                          onTap: () async {
                                            try {
                                              await auth
                                                  .createUserWithEmailAndPassword(
                                                email: _emailSignUp,
                                                password: _passwordSignUp,
                                              );

                                              setState(() {
                                                successfulAnimation = true;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      snackBarSignUpScs);
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1100));

                                              await Get.offNamed(
                                                  RouteHelper.getEmailLogin());
                                              setState(() {
                                                isSignUpScreen = false;
                                                successfulAnimation = false;
                                              });
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      snackBarSignUpFail);
                                            }
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(seconds: 1),
                                            alignment: Alignment.center,
                                            height: Dimensions.all1 *
                                                Dimensions.all1 *
                                                60,
                                            width: Dimensions.all1 *
                                                Dimensions.all1 *
                                                400,
                                            child: Text(
                                              "Sign Up !! Let`s Go!",
                                              style: TextStyle(
                                                  color: white,
                                                  fontFamily:
                                                      GoogleFonts.ubuntu()
                                                          .fontFamily,
                                                  fontSize: Dimensions.all1 *
                                                      Dimensions.all1 *
                                                      22.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(Dimensions.all1 * 30,
                                Dimensions.all1 * 30, Dimensions.all1 * 30, 0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Log In",
                                    style: TextStyle(
                                        fontSize: Dimensions.all1 * 17,
                                        letterSpacing: Dimensions.all1 * 1.3,
                                        fontFamily: GoogleFonts.varelaRound()
                                            .fontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.all1 * 5),
                                    child: Text(
                                        "Welcome to PlaySpots please fill the details below to Log In",
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: Dimensions.all1 * 14,
                                          fontFamily: GoogleFonts.varelaRound()
                                              .fontFamily,
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.all1 * 10),
                                    child: TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            emailLogIn = value.trim();
                                            emailController.text = emailLogIn;
                                          });
                                        },
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: "Enter E-mail",
                                          labelStyle: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.7)),
                                          labelText: "Email",
                                          hintStyle: TextStyle(
                                              fontSize: Dimensions.all1 * 16),
                                        )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.all1 * 5),
                                    child: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          _passwordLogIn = value.trim();
                                        });
                                      },
                                      // obscureText: eyeTap ? true : false,
                                      decoration: InputDecoration(
                                        // suffixIcon: Icon(Icons.remove_red_eye,),
                                        hintText: "Enter Password",
                                        labelStyle: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                        hintStyle: TextStyle(
                                            fontSize: Dimensions.all1 * 16),
                                        labelText: "Password",
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child:
                                        Image.asset("assets/image/login.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: Dimensions.all1 * 50,
                                        bottom: Dimensions.all1 * 30),
                                    child: Material(
                                      color: textColor2,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.all1 * 15),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.all1 * 15),
                                        onTap: () async {
                                          try {
                                            await auth
                                                .signInWithEmailAndPassword(
                                              email: emailLogIn,
                                              password: _passwordLogIn,
                                            );
                                            setState(() {
                                              successfulAnimation = true;
                                            });
                                            await Future.delayed(const Duration(
                                                milliseconds: 1100));

                                            Get.offNamed(
                                                RouteHelper.getProfile());
                                            setState(() {
                                              successfulAnimation = false;
                                            });
                                            var user = FirebaseAuth
                                                .instance.currentUser!;
                                            ref.child(user.uid);
                                          } on FirebaseAuthException catch (e) {
                                            print(
                                                'Failed with error code: ${e.code}');
                                            print(e.message);
                                            ScaffoldMessenger.of(context)
                                              ..showSnackBar(snackBar);
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          alignment: Alignment.center,
                                          height: Dimensions.all1 * 60,
                                          width: Dimensions.all1 * 400,
                                          child: Text(
                                            "Log In !! Let`s Go!",
                                            style: TextStyle(
                                                color: white,
                                                fontFamily: GoogleFonts.ubuntu()
                                                    .fontFamily,
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                  ],
                ),
              )),
          successfulAnimation
              ? Center(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Lottie.asset("assets/lottie/successful.json")),
                )
              : Container(),
        ],
      ),
    );
  }
}
