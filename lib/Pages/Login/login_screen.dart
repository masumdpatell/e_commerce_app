import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:e_commerce_app/Pages/Login/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Routes/route_helper.dart';
import '../../utils/colors.dart';

TextEditingController phoneNumber = TextEditingController();
Country? _selectedCountry;
final countrycode = _selectedCountry!.callingCode;
bool loginBtnEnable = false;

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 80, 30, 0),
          child: Center(
              child: Column(
            children: [
              Image.asset(
                "assets/image/logo.png",
                width: 180,
                height: 120,
              ),
              Text(
                "Join the Play Spots community",
                style: TextStyle(
                  fontFamily: GoogleFonts.varelaRound().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone Number",
                    style: TextStyle(
                      fontFamily: GoogleFonts.varelaRound().fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w100,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onPressedShowBottomSheet,
                      child: Image.asset(
                        country!.flag,
                        package: countryCodePackageName,
                        width: 35,
                      ),
                    ),
                    InkWell(
                      onTap: onPressedShowBottomSheet,
                      child: Text(
                        '   ${country.callingCode}',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: GoogleFonts.varelaRound().fontFamily),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7),
                      color: grey,
                      width: 1.1,
                      height: 25,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: TextFormField(
                          controller: phoneNumber,
                          onChanged: (value) {
                            setState(() {
                              loginBtnEnable = value.length >= 9 ? true : false;
                            });
                          },
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.varelaRound().fontFamily),
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
                                fontSize: 16,
                                fontFamily:
                                    GoogleFonts.varelaRound().fontFamily),
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
                padding: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: loginBtnEnable == true
                        ? () async {
                            otpTimeOut = false;
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: '${countrycode + phoneNumber.text}',
                              verificationCompleted: (phoneAuthCredential) {},
                              verificationFailed: (FirebaseAuthException e) {},
                              codeSent:
                                  (String verificationId, forceResendingToken) {
                                LoginScreen.verify = verificationId;
                                ScaffoldMessenger.of(context)
                                  ..showSnackBar(snackBar);
                                Get.toNamed(RouteHelper.getOTP());
                              },
                              timeout: Duration(seconds: timeLeft),
                              codeAutoRetrievalTimeout: (verificationId) {
                                Duration(seconds: timeLeft);
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textColor2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Sign up with phone number",
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
                padding: const EdgeInsets.only(top: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
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
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(RouteHelper.getEmailLogin());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: SvgPicture.asset('assets/svg/facebook.svg'),
                    label: Text(
                      "Sign up with E-mail",
                      style: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
                          color: textColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: SvgPicture.asset('assets/svg/google.svg'),
                    label: Text(
                      "Continue with Google",
                      style: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
                          color: textColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: SvgPicture.asset('assets/svg/facebook.svg'),
                    label: Text(
                      "Continue with Facebook",
                      style: TextStyle(
                          fontFamily: GoogleFonts.varelaRound().fontFamily,
                          color: textColor),
                    ),
                  ),
                ),
              ),
            ],
          )),
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
