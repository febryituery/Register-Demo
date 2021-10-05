import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:register_project/constant.dart';
import 'package:register_project/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Registration Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var _emailController = TextEditingController();
  var _passController = TextEditingController();

  var isLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //pengecekan status login
    checkUser();
  }

  void checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getBool(Constant.isLogin) ?? false) {
      setState(() {
        isLogin = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isLogin) {
      return Container(
        color: Colors.white,
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        hintText: "Masukkan email yang valid"
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        hintText: "Masukkan password yang valid"
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Email: ${_emailController
                          .text}, Pass: ${_passController.text}");
                      enterLogin(_emailController.text, _passController.text);
                    },
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text("REGISTRASI"),
                    ),
                  ),
                )
              ],
            ),
          )
      );
    }
  }

  void enterLogin(String email, String password) async {
    var url = Uri.parse("https://reqres.in/api/register");
    Map<String, String> body = {"email": email, "password": password};
    http.Response response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      },
      body: body
    );
    if(response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var id = jsonResponse['id'];
      var token = jsonResponse['token'];
      getUser(id, email, token);
    } else {
      print("Error ${response.statusCode}");
    }
  }

  void getUser(int id, String email, String token) async {
    var url = Uri.parse("https://reqres.in/api/users/$id");
    http.Response response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
        }
    );
    if(response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      var email = jsonResponse['data']['email'];
      var firstName = jsonResponse['data']['first_name'];
      var lastName = jsonResponse['data']['last_name'];
      var avatar = jsonResponse['data']['avatar'];
      print("Email: ${email}, FirstName: ${firstName}, LastName: ${lastName}, Avatar: ${avatar}");
      saveData(id, email, token, firstName, lastName, avatar);
    } else {
      print("Error ${response.statusCode}");
    }
  }

  void saveData(int id, String email, String token, String firstName, String lastName, String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(Constant.isLogin, true);
    await prefs.setInt(Constant.id, id);
    await prefs.setString(Constant.email, email);
    await prefs.setString(Constant.firstName, firstName);
    await prefs.setString(Constant.lastName, lastName);
    await prefs.setString(Constant.avatar, avatar);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }
}
