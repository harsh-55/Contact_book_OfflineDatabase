import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:offlinedata_login/3-DataBaseClass.dart';
import 'package:offlinedata_login/4-thirdpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '2-Signup page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    title: "Contacts",
    debugShowCheckedModeBanner: false,
    home: loginpage(),
  ));
}

class loginpage extends StatefulWidget {
  static SharedPreferences? Preferences;

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> with TickerProviderStateMixin {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _emailkey = GlobalKey<FormState>();
  final _passkey = GlobalKey<FormState>();

  bool isTapped = false;
  bool hidepassword = true;

  Database? databasee;

  bool login = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ForDatabase();
  }

  Future<void> ForDatabase() async {
    loginpage.Preferences = await SharedPreferences.getInstance();

    setState(() {
      login = loginpage.Preferences!.getBool("loginstatus") ?? false;
    });

    if (login) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return thirdpage();
        },
      ));
    } else {}

    DataBaseClass().GetDatabase().then((value) {
      setState(() {
        databasee = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: theight,
          width: twidth,
          color: Color(0xFF1F1A30),
          child: Column(
            children: [
              Container(
                height: theight * 0.37,
                width: twidth,
                child: Column(
                  children: [
                    Container(
                      height: theight * 0.05,
                      width: twidth,
                    ),
                    Container(
                      height: theight * 0.32,
                      width: twidth * 0.8,
                      child: Lottie.asset("Animation/38435-register.json",
                          fit: BoxFit.fill),
                    )
                  ],
                ),
              ),
              Container(
                height: theight * 0.073,
                width: twidth * 0.7,
                child: Text("Login",
                    style: GoogleFonts.alata(
                        color: Colors.white, fontSize: theight * 0.041)),
              ),
              Container(
                height: theight * 0.05,
                width: twidth * 0.7,
                child: Text("Please Fill the input below here",
                    style: GoogleFonts.aBeeZee(
                        color: Colors.grey, fontSize: theight * 0.021)),
              ),
              Container(
                height: theight * 0.17,
                width: twidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: theight * 0.07,
                        width: twidth * 0.85,
                        decoration: BoxDecoration(
                            color: Color(0xFF39304F),
                            borderRadius: BorderRadius.circular(12)),
                        child: Form(
                          key: _emailkey,
                          child: TextFormField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                icon: Icon(Icons.email_outlined,
                                    color: Colors.grey, size: 30),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "EMAIL........",
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
                              } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return "Please enter a valid email address";
                              }
                            },
                          ),
                        )),
                    Container(
                      height: theight * 0.07,
                      width: twidth * 0.85,
                      decoration: BoxDecoration(
                          color: Color(0xFF39304F),
                          borderRadius: BorderRadius.circular(12)),
                      child: Form(
                        key: _passkey,
                        child: TextFormField(
                          obscureText: hidepassword,
                          controller: passwordcontroller,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock_outlined,
                                  color: Colors.grey, size: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              labelText: "PASSWORD........",
                              suffixIcon: InkWell(
                                  onTap: _passwordview,
                                  child: Icon(Icons.visibility,
                                      color: Colors.white70, size: 26)),
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
                              return 'Please Enter Your Password......';
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(height: theight * 0.035),
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
                    if (_emailkey.currentState!.validate()) {}
                    if (_passkey.currentState!.validate()) {}

                    String email = emailcontroller.text;
                    String password = passwordcontroller.text;

                    DataBaseClass()
                        .Loginuser(email, password, databasee!)
                        .then((value) {
                      if (value.length == 1) {
                        loginpage.Preferences!.setBool("loginstatus", true);

                        String fullname = value[0]['NAME'];
                        String phonenumber = value[0]['NUMBER'];
                        String emaill = value[0]['EMAIL'];
                        String passwoord = value[0]['PASSWORD'];
                        int Id = value[0]['ID'];

                        loginpage.Preferences!.setInt("loginid", Id);
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return thirdpage();
                          },
                        ));

                        MotionToast.success(
                            description: Text(
                          "Login SuccessFully",
                          style: TextStyle(fontSize: 20),
                        )).show(context);
                      } else {
                        MotionToast.error(
                            description: Text(
                          "User Not Found",
                          style: TextStyle(fontSize: 20),
                        )).show(context);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(microseconds: 100),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: isTapped ? 56 : 56,
                    width: isTapped ? 140 : 160,
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
                        'LOGIN',
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
              Container(
                height: theight * 0.05,
                width: twidth,
                child: Center(
                    child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.aBeeZee(
                      color: Colors.cyanAccent[100], fontSize: 15),
                )),
              ),
              Container(
                height: theight * 0.097,
                width: twidth * 0.63,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: 75,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('photos/whatsapp.png'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      height: 80,
                      width: 75,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('photos/facebook.png'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      height: 80,
                      width: 75,
                      child: Container(
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('photos/google.png'),
                                fit: BoxFit.contain)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: theight * 0.08,
                width: twidth,
                child: Column(
                  children: [
                    Container(
                      width: twidth * 0.65,
                      child: Center(
                        child: Text("Don't have an account?",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.grey, fontSize: 16)),
                      ),
                    ),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return secpage();
                            },
                          ));
                        },
                        child: Text(" Sign up",
                            style: GoogleFonts.aBeeZee(
                                color: Colors.cyanAccent[100], fontSize: 16)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _passwordview() {
    setState(() {
      if (hidepassword == true) {
        hidepassword = false;
      } else {
        hidepassword = true;
      }
    });
  }
}
