import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:play_spots/Services/auth_service.dart';

import '../../Data/Repository/cart_repo.dart';
import '../../Routes/route_helper.dart';
import '../../Widgets/big_text.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../Login/login_screen.dart';

final formkey = GlobalKey<FormState>();
String genderController = "";
String genderImg = "";
bool initialProfile = true;

List buttons = [
  "Male",
  "Female",
  "Other",
];

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance;
  final user = FirebaseAuth.instance.currentUser!;

  get sharedPreferences => sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
              top: Dimensions.all1 * 60,
              left: Dimensions.all1 * 30,
              right: Dimensions.all1 * 30,
              bottom: Dimensions.all1 * 30),
          child: Column(
            children: [
              Container(
                height: Dimensions.all1 * 120,
                width: Dimensions.all1 * 120,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: mainColor, width: Dimensions.all1 * 5),
                  borderRadius: BorderRadius.circular(Dimensions.all1 * 200),
                  color: black,
                ),
                child: Container(
                  height: Dimensions.all1 * 140,
                  width: Dimensions.all1 * 140,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: gradientColor2, width: Dimensions.all1 * 4),
                    borderRadius: BorderRadius.circular(Dimensions.all1 * 200),
                    color: black,
                  ),
                  child: Container(
                    height: Dimensions.all1 * 120,
                    width: Dimensions.all1 * 120,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: white, width: Dimensions.all1 * 2),
                      borderRadius:
                          BorderRadius.circular(Dimensions.all1 * 200),
                      color: black,
                    ),
                    child: CircleAvatar(
                      radius: Dimensions.all1 * 50,
                      backgroundColor: mainColor.withOpacity(0.5),
                      child: ClipOval(
                        child: InkWell(
                          onTap: (() {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: new Icon(
                                            Icons.photo_library_outlined),
                                        title: new Text('Upload From Gallery'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: new Icon(
                                            Icons.add_a_photo_outlined),
                                        title: new Text('Use Camera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }),
                          child: user.photoURL == null
                              ? SvgPicture.asset(
                                  "assets/svg/man.svg",
                                )
                              : Image.network(user.photoURL!),
                        ),
                        // decoration: BoxDecoration(
                        //     color: gradientColor1,
                        //     borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.all1 * 10),
                child: GestureDetector(
                  onTap: (() {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: new Icon(Icons.photo_library_outlined),
                                title: new Text('Upload From Gallery'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: new Icon(Icons.add_a_photo_outlined),
                                title: new Text('Use Camera'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  }),
                  child: Text(
                    "Change Profile Image",
                    style: TextStyle(
                        color: mainColor,
                        fontFamily: 'Ubuntu',
                        fontSize: Dimensions.all1 * 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.all1 * 10),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [
                      _buildUsername(),
                      Divider(
                        thickness: 1.5,
                      ),
                      _buildPersonBio(),
                      Divider(
                        thickness: 1.5,
                      ),
                      _buildContactNumber(),
                      Divider(
                        thickness: 1.5,
                      ),
                      _buildEmail(context),
                      Divider(
                        thickness: 1.5,
                      ),
                      _buildBirthDate(context),
                      Divider(
                        thickness: 1.5,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/image/gender.png",
                            height: Dimensions.all1 * 25,
                            width: Dimensions.all1 * 25,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: Dimensions.all1 * 15),
                            child: _buildGenderSelection(),
                          )
                        ],
                      ),
                      initialProfile
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.all1 * 25),
                                  child: SizedBox(
                                    width: Dimensions.all1 * 130,
                                    height: Dimensions.all1 * 35,
                                    child: InkWell(
                                      child: ElevatedButton(
                                        autofocus: true,
                                        onPressed: () async {
                                          Get.offNamed(
                                              RouteHelper.getInitial());
                                          setState(() {
                                            initialProfile = false;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor: buttonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          "Continue",
                                          style: TextStyle(
                                              color: white,
                                              fontFamily:
                                                  GoogleFonts.varelaRound()
                                                      .fontFamily,
                                              fontSize: Dimensions.all1 * 16.0,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  EdgeInsets.only(top: Dimensions.all1 * 30),
                              child: GestureDetector(
                                onTap: () {
                                  auth.signOut().then((_) {
                                    Get.toNamed(
                                        RouteHelper.getAuthentication());
                                  });
                                  FirebaseServices()
                                      .signOutWithGoogle(context)
                                      .then((_) {
                                    Get.toNamed(
                                        RouteHelper.getAuthentication());
                                  });
                                  ;
                                  setState(() {
                                    initialProfile = true;
                                  });

                                  CartRepo(
                                      sharedPreferences: sharedPreferences
                                          .remove(AppConstants.CART_LIST));
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Dimensions.width20 * 3,
                                    Dimensions.height20 * 0.75,
                                    Dimensions.width20 * 3,
                                    Dimensions.height20 * 0.75,
                                  ),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.all1 * 10)),
                                  child: BigText(
                                    text: "Log Out",
                                    color: white,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _buildInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    border: InputBorder.none,
    prefixIconConstraints: BoxConstraints(minWidth: 0),
    hintText: hint,
    hintStyle: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily),
    prefixIcon: Padding(
      padding: EdgeInsets.only(right: Dimensions.all1 * 12),
      child: Icon(
        icon,
        size: Dimensions.all1 * 28,
        color: textColor,
      ),
    ),
  );
}

Widget _buildUsername() {
  return TextFormField(
    controller: userName,
    onChanged: (value) {
      print(value);
      if (value == null) {
        SnackBar(
          content: Text("Try"),
        );
      }
      null;
    },
    inputFormatters: [LengthLimitingTextInputFormatter(15)],
    style: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    textCapitalization: TextCapitalization.words,
    decoration: _buildInputDecoration("Username", Icons.person),
  );
}

Widget _buildPersonBio() {
  return TextFormField(
    onChanged: (value) {
      print(value);
      if (value == null) {
        SnackBar(
          content: Text("Try"),
        );
      }
      null;
    },
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: 5,
    style: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    decoration:
        _buildInputDecoration("Type something about you", Icons.article),
  );
}

Widget _buildContactNumber() {
  return TextFormField(
    controller: FirebaseAuth.instance.currentUser!.phoneNumber == null
        ? null
        : phoneNumber,
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10)
    ],
    style: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    textCapitalization: TextCapitalization.words,
    decoration: _buildInputDecoration("Your contact number", Icons.call),
  );
}

Widget _buildEmail(BuildContext context) {
  return TextFormField(
    controller: emailController,
    onFieldSubmitted: (value) {
      final form = formkey.currentState;
      if (form!.validate()) {
      } else {
        ScaffoldMessenger.of(context)..showSnackBar(snackBar);
      }
    },
    validator: (email) => email != null && !EmailValidator.validate(email)
        ? "Your Email is not Valid!"
        : null,
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [],
    style: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    decoration: _buildInputDecoration("Your Email ID", Icons.mail),
  );
}

final snackBar = SnackBar(
  dismissDirection: DismissDirection.down,
  elevation: 0,
  behavior: SnackBarBehavior.floating,
  backgroundColor: transparent,
  content: AwesomeSnackbarContent(
    title: 'Invalid Format!',
    message: 'Enter Valid Email ID',
    contentType: ContentType.failure,
  ),
);

Widget _buildBirthDate(BuildContext context) {
  return TextFormField(
    focusNode: DisabledFocusNode(),
    textInputAction: TextInputAction.done,
    controller: birthDate,
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now())
          .then((selectedDate) {
        if (selectedDate != null) {
          birthDate.text = DateFormat.yMMMMd().format(selectedDate);
        }
      });
      // if (pickedDate != null) {
      //   birthDate.text = DateTime.now() as String;
      // }
    },
    style: TextStyle(
        fontSize: Dimensions.all1 * 16,
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    textCapitalization: TextCapitalization.words,
    decoration:
        _buildInputDecoration("Enter your birthday", Icons.calendar_month),
  );
}

class DisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

Widget _buildGenderSelection() {
  return GroupButton(
    onSelected: ((value, index, isSelected) {
      genderController = value as String;
    }),
    options: GroupButtonOptions(
      selectedTextStyle: TextStyle(
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      unselectedTextStyle: TextStyle(
        fontFamily: GoogleFonts.varelaRound().fontFamily,
        color: textColor.withAlpha(180),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      unselectedBorderColor: grey,
      selectedBorderColor: grey,
      spacing: Dimensions.all1 * 10,
      unselectedColor: transparent,
      selectedColor: grey,
    ),
    buttons: buttons,
    isRadio: true,
  );
}
