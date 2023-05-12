

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offlinedata_login/main.dart';
import 'package:offlinedata_login/4-thirdpage.dart';
import 'package:offlinedata_login/6-thirdpagedatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  TextEditingController name = TextEditingController();
  TextEditingController phonenumber = TextEditingController();

  Database? dbb;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fordatabase();
  }

  void fordatabase() {
    thirdpagedatabase().getDatabase1().then((value) {
      setState(() {
        dbb = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF1B1B1D),
          leading: IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return thirdpage();
            },));
          }, icon: Icon(Icons.arrow_back_sharp)),
          title: Text('Create contact', style: TextStyle(fontSize: 24)),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Color(0xFF1B1B1D),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 50, 15, 25),
                  child: TextField(
                    controller: name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.account_circle,
                          color: Colors.grey,
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 40),
                  child: TextField(
                    controller: phonenumber,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                        labelText: 'Phone',
                        labelStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.add_call,
                          color: Colors.grey,
                          size: 25,
                        )),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                    int userid = loginpage.Preferences!.getInt("loginid") ?? 0;

                    thirdpagedatabase().insertData(name.text, phonenumber.text,"$userid", dbb!).then((value) {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                        return thirdpage();
                      },));
                    });
                  },
                  child: Text('Save',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      )),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.lightBlue),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(26, 10, 26, 10)),
                  ),
                )
              ],
            ),
          ),
        )), onWillPop: () {
          return showExitPopup(context);
        },);
  }
  OutlineInputBorder myinputborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.7,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.7,
        ));
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
                  width: 120,
                  child: Lottie.asset("Animation/75823-arrow-left-circle.json",fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: Text(
                  "Use Back Button....",
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
                  SizedBox(width: 150,),
                  Expanded(child: ElevatedButton(onPressed: () {
                    print('Yes selected');

                    Navigator.of(context).pop();
                  },
                    child: Text('OK', style: TextStyle(color: Colors.white),),
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
