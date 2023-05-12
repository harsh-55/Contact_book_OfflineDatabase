import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neon/neon.dart';
import 'package:offlinedata_login/5-addcontact.dart';
import 'package:offlinedata_login/main.dart';
import 'package:offlinedata_login/6-thirdpagedatabase.dart';
import 'package:offlinedata_login/updatepageee.dart';
import 'package:sqflite/sqflite.dart';

class thirdpage extends StatefulWidget {
  const thirdpage({Key? key}) : super(key: key);

  @override
  State<thirdpage> createState() => _thirdpageState();
}

class _thirdpageState extends State<thirdpage> {
  Database? dbb;

  List<Map> hh = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getViewData();
  }

  void getViewData() {
    int userid = loginpage.Preferences!.getInt("loginid") ?? 0;

    thirdpagedatabase().getDatabase1().then((value) {
      setState(() {
        dbb = value;
        thirdpagedatabase().viewData(userid, dbb!).then((value) {
          setState(() {
            hh = value;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double theight = MediaQuery.of(context).size.height;
    double twidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return AddContact();
              },
            ));
          },
          child:
              Icon(Icons.add, color: Colors.white.withOpacity(0.8), size: 35),
          backgroundColor: Colors.cyan,
          elevation: 20,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: theight,
            width: twidth,
            color: Color(0xFF1B1B1D),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 13, right: 13, top: 40, bottom: 0.0),
                  child: Container(
                    height: theight * 0.07,
                    decoration: BoxDecoration(
                        color: Color(0xFF292E34),
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: twidth * 0.1,
                          child: Icon(
                            Icons.perm_contact_cal,
                            color: Colors.grey,
                            size: theight * 0.04,
                          ),
                        ),
                        Container(
                          width: twidth * 0.6,
                          child: Neon(
                              text: "Contacts",
                              color: Colors.grey,
                              font: NeonFont.NightClub70s),
                        ),
                        IconButton(
                            onPressed: () {
                              loginpage.Preferences!
                                  .setBool("loginstatus", false);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return loginpage();
                                },
                              ));
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.grey,
                              size: theight * 0.04,
                            ))
                      ],
                    ),
                  ),
                ),
                Container(
                  height: theight * 0.877,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: hh.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 5, bottom: 6, right: 5),
                        child: SizedBox(
                          height: theight * 0.095,
                          child: Card(
                            elevation: 50,
                            color: Colors.white.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              leading: Icon(Icons.account_circle,
                                  size: 35, color: Colors.white),
                              trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 70, vertical: 50),
                                          child: SimpleDialog(
                                            backgroundColor: Colors.transparent,
                                            elevation: 0,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return updatepage(
                                                          hh[index], dbb!);
                                                    },
                                                  ));
                                                },
                                                child: Text("UPDATE"),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors.green)),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  int id = hh[index]["ID"];
                                                  thirdpagedatabase()
                                                      .deleteData(id, dbb!);
                                                  Navigator.pop(context);
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                    builder: (context) {
                                                      return thirdpage();
                                                    },
                                                  ));
                                                },
                                                child: Text("DELETE"),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .redAccent)),
                                              ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(Icons.more_vert,
                                      size: 27, color: Colors.white)),
                              title: Text(
                                "${hh[index]['NAME']}",
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 1.4,
                              ),
                              subtitle: Text("${hh[index]['PHONE']}",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        return showExitPopup(context);
      },
    );
  }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
      context: context,
      builder: (context) {
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
                    width: 120,
                    child: Lottie.asset(
                        "Animation/113125-cat-crying-emojisticker-animation.json",
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Do you want to leave?",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          print('Yes selected');
                          exit(0);
                        },
                        child: Text("Yes"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade800),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('Yes selected');

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
