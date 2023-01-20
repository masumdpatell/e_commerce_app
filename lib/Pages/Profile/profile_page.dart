import 'package:intl/intl.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:group_button/group_button.dart';

import '../../utils/Colors.dart';

final formkey = GlobalKey<FormState>();
TextEditingController emailController = TextEditingController();
TextEditingController birthDate = TextEditingController();
String genderController = "";
String genderImg = "";

List buttons = [
  "Male",
  "Female",
  "Other",
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(color: mainColor, width: 5),
              borderRadius: BorderRadius.circular(200),
              color: black,
            ),
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                border: Border.all(color: iconColor1, width: 4),
                borderRadius: BorderRadius.circular(200),
                color: black,
              ),
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: white, width: 2),
                  borderRadius: BorderRadius.circular(200),
                  color: black,
                ),
                child: CircleAvatar(
                  radius: 50,
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
                                    leading:
                                        new Icon(Icons.photo_library_outlined),
                                    title: new Text('Upload From Gallery'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading:
                                        new Icon(Icons.add_a_photo_outlined),
                                    title: new Text('Use Camera'),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });
                      }),
                      child: SvgPicture.asset(
                        "assets/image/man.svg",
                      ),
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
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
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
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
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
                        height: 25,
                        width: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: _buildGenderSelection(),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 25),
                  //       child: SizedBox(
                  //         width: 130,
                  //         height: 35,
                  //         child: InkWell(
                  //           child: ElevatedButton(
                  //             autofocus: true,
                  //             onPressed: () {
                  //               Navigator.pushNamed(
                  //                   context, MyRoutes.homeNavBar);
                  //             },
                  //             style: ElevatedButton.styleFrom(
                  //               elevation: 0,
                  //               backgroundColor: buttonColor,
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(5),
                  //               ),
                  //             ),
                  //             child: Text(
                  //               "Continue",
                  //               style: TextStyle(
                  //                   color: white,
                  //                   fontFamily: 'Ubuntu',
                  //                   fontSize: 16.0,
                  //                   fontWeight: FontWeight.w600),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

InputDecoration _buildInputDecoration(String hint, IconData icon) {
  return InputDecoration(
    border: InputBorder.none,
    prefixIconConstraints: BoxConstraints(minWidth: 0),
    hintText: hint,
    hintStyle: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
    prefixIcon: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(
        icon,
        size: 28,
        color: textColor,
      ),
    ),
  );
}

Widget _buildUsername() {
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
    inputFormatters: [LengthLimitingTextInputFormatter(15)],
    style: TextStyle(
        fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
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
        fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
    textAlignVertical: TextAlignVertical.top,
    decoration:
        _buildInputDecoration("Type something about you", Icons.article),
  );
}

Widget _buildContactNumber() {
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
    keyboardType: TextInputType.phone,
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10)
    ],
    style: TextStyle(
        fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
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
        fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
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
        fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w400),
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
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      unselectedTextStyle: TextStyle(
        fontFamily: 'Roboto',
        color: textColor.withAlpha(180),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      unselectedBorderColor: grey,
      selectedBorderColor: grey,
      spacing: 10,
      unselectedColor: transparent,
      selectedColor: grey,
    ),
    buttons: buttons,
    isRadio: true,
  );
}
