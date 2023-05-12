import 'dart:io';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:offlinedata_login/3-DataBaseClass.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

class secpage extends StatefulWidget {
  const secpage({Key? key}) : super(key: key);

  @override
  State<secpage> createState() => _secpageState();
}

class _secpageState extends State<secpage> with TickerProviderStateMixin {
  TextEditingController fullnamecontro = TextEditingController();
  TextEditingController phonecontro = TextEditingController();
  TextEditingController emailcontro = TextEditingController();
  TextEditingController passcontro = TextEditingController();
  TextEditingController confpasscontro = TextEditingController();

  final countryPicker = const FlCountryCodePicker();
  CountryCode? countryCode;

  final _fullnamekey = GlobalKey<FormState>();
  final _pnumberkey = GlobalKey<FormState>();
  final _emailllkey = GlobalKey<FormState>();
  final _passwordkey = GlobalKey<FormState>();
  final _Cpasskey = GlobalKey<FormState>();

  bool isTapped = false;
  bool hideepassword = true;
  bool passwordhidee = true;

  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ForDatabase();
  }

  void ForDatabase() {
    DataBaseClass().GetDatabase().then((value) {
      setState(() {
        db = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;

    return WillPopScope(child: Scaffold(
      body: SingleChildScrollView(
          child: Container(
            height: theight,
            width: twidth,
            color: Color(0xFF1F1A30),
            child: Column(
              children: [
                Container(
                    height: theight * 0.21,
                    width: twidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                            child: Text("Create Account",
                                style: GoogleFonts.aBeeZee(
                                  color: Colors.white,
                                  fontSize: 30,
                                ))),
                        Center(
                            child: Text("Please Fill the input below here",
                                style: GoogleFonts.aBeeZee(
                                    color: Colors.grey, fontSize: 20)))
                      ],
                    )),
                SizedBox(
                  height: theight * 0.05,
                ),
                Container(
                  height: theight * 0.5,
                  width: twidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: theight * 0.075,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _fullnamekey,
                          child: TextFormField(
                            controller: fullnamecontro,
                            decoration: InputDecoration(
                                icon: Icon(Icons.perm_identity,
                                    color: Colors.grey, size: 30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "FULL NAME.....",
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold)),
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              } else if (!RegExp(r'^[a-zA-Z0-9&%=]+$')
                                  .hasMatch(value)) {
                                return 'Please Enter Full Name.....';
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: theight * 0.075,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: theight * 0.075,
                              width: twidth * 0.28,
                              child: GestureDetector(
                                onTap: () async {
                                  final code = await countryPicker.showPicker(
                                      context: context);
                                  setState(() {
                                    countryCode = code;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   child: countryCode != null
                                    //       ? countryCode!.flagImage
                                    //       : Icon(
                                    //     Icons.call,
                                    //     color: Colors.white60,
                                    //   ),
                                    // ),
                                    SizedBox(width: 5),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1, vertical: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.cyanAccent[100],
                                            borderRadius: BorderRadius.circular(6)),
                                        child: Row(
                                          children: [
                                            Icon(Icons.keyboard_double_arrow_down,
                                                color: Colors.black, size: 18),
                                            Text(
                                              countryCode?.dialCode ?? "+1",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: theight * 0.075,
                              width: twidth * 0.56,
                              child: Form(
                                key: _pnumberkey,
                                child: TextFormField(
                                  cursorColor: Colors.lightBlueAccent,
                                  controller: phonecontro,
                                  keyboardType: TextInputType.number,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: "PHONE......",
                                      labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.bold)),
                                  style: GoogleFonts.aBeeZee(
                                    color: Colors.white,
                                    fontSize: 21,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Your Phone Number...';
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: theight * 0.075,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _emailllkey,
                          child: TextFormField(
                            controller: emailcontro,
                            decoration: InputDecoration(
                                icon: Icon(Icons.mail_outline_outlined,
                                    color: Colors.grey, size: 30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "EMAIL.....",
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis)),
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: theight * 0.075,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _passwordkey,
                          child: TextFormField(
                            obscureText: hideepassword,
                            controller: passcontro,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outlined,
                                    color: Colors.grey, size: 30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "PASSWORD......",
                                suffixIcon: InkWell(
                                  onTap: _hiddenpassword,
                                  child: Icon(Icons.visibility,
                                      color: Colors.white70, size: 26),
                                ),
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Password....";
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: theight * 0.075,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _Cpasskey,
                          child: TextFormField(
                            obscureText: passwordhidee,
                            controller: confpasscontro,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock_outlined,
                                    color: Colors.grey, size: 30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: InkWell(
                                    onTap: _ishiddenpassword,
                                    child: Icon(
                                      Icons.visibility,
                                      color: Colors.white70,
                                      size: 26,
                                    )),
                                labelText: "CONFIRM PASSWORD.....",
                                labelStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold)),
                            style: GoogleFonts.aBeeZee(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The password confirmation not match... ";
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: theight * 0.04,
                ),
                Center(
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onHighlightChanged: (value) {
                      setState(() {
                        isTapped = value;
                      });
                    },
                    onTap: () {

                      if (_fullnamekey.currentState!.validate()) {}
                      if (_pnumberkey.currentState!.validate()) {}
                      if (_emailllkey.currentState!.validate()) {}
                      if (_passwordkey.currentState!.validate()) {}
                      if (_Cpasskey.currentState!.validate()) {}

                      if (passcontro.text != confpasscontro.text) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("BOTH PASSWORD ARE NOT SAME")));

                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        //     content: Text("Please Select a Country")));
                      }
                      else{

                        String fullname = fullnamecontro.text;
                        String phonenum = phonecontro.text;
                        String email = emailcontro.text;
                        String password = passcontro.text;
                        String conpass = confpasscontro.text;

                        DataBaseClass()
                            .Insertuserdata(fullname, phonenum, email, password, conpass,db!)
                            .then((value) {
                          if (value.length == 0) {
                            DataBaseClass()
                                .Insertvaliduser(
                                fullname, phonenum, email, password,conpass ,db!)
                                .then((value) {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) {
                                  return loginpage();
                                },
                              ));
                            });
                          } else {
                            MotionToast.warning(
                                description: Text(
                                  "User Already Exist",
                                  style: TextStyle(fontSize: 20),
                                )).show(context);
                          }
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(microseconds: 100),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: isTapped ? 56 : 56,
                      width: isTapped ? 140 : 170,
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent[100],
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 30,
                            offset: Offset(3, 7),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                Container(
                  height: theight * 0.08,
                  width: twidth,
                  child: Column(
                    children: [
                      Container(
                        height: theight * 0.03,
                        width: twidth * 0.65,
                        child: Center(
                          child: Text("Already Have a account?",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.grey, fontSize: 17)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return loginpage();
                            },
                          ));
                        },
                        child: Container(
                          child: Text(" Login",
                              style: GoogleFonts.aBeeZee(
                                  color: Colors.cyanAccent[100], fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    ), onWillPop: () {
      return showExitPopup(context);
    },);
  }

  void _hiddenpassword() {
    setState(() {
      if (hideepassword == true) {
        hideepassword = false;
      } else {
        hideepassword = true;
      }
    });
  }

  void _ishiddenpassword() {
    setState(() {
      if (passwordhidee == true) {
        passwordhidee = false;
      } else {
        passwordhidee = true;
      }
    });
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
      context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        content: Container(
          height: 190,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 95,
                  width: 200,
                  child: Lottie.asset("Animation/132080-jelly-back-button.json",fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Go to login page?",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1.5,
              ),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: () {
                    print('Yes selected');
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                     return loginpage();
                   },));
                  }, child: Text("Yes"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade800),
                  ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(child: ElevatedButton(onPressed: () {
                    print('Yes selected');

                    Navigator.of(context).pop();
                  },
                    child: Text('No', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green),))
                ],
              )
            ],
          ),
        ),
      );
    },);
  }
}
