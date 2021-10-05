import 'package:flutter/material.dart';
import 'package:register_project/constant.dart';
import 'package:register_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var avatar = "";
  var firstName = "";
  var email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callData();
  }

  void callData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      avatar = prefs.getString(Constant.avatar) ?? "";
      firstName = prefs.getString(Constant.firstName) ?? "";
      email = prefs.getString(Constant.email) ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  avatar != ""?
                  Image.network(avatar,
                    width: 100,
                    height: 100,
                  ): Container(),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, $firstName"),
                      Text("$email")
                    ],
                  )
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text("LOGOUT"),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyApp()));
                },
              ),
            ],
          )
      ),
    );
  }
}