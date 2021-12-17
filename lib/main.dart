import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/card.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:blogone/screens/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

var token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  token = await SharedPreferenceHelper().getToken();

  print('---------------------------');
  print(token);
  print('---------------------------');
  //runApp(MyApp());
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingProvider(
          themeData:
              LoadingThemeData(animDuration: Duration(milliseconds: 800)),
          child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  currentUser() async {
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + token.toString()};
    var currentuserresponse, responseBody, statusCode;

    try {
      currentuserresponse = await http.get(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );
      statusCode = currentuserresponse.statusCode;
      responseBody = jsonDecode(currentuserresponse.body);

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
    return statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: currentUser() != 201 ? "signin" : "/",
      routes: {
        '/': (context) => CardView(value: token),
        "signin": (context) => SignIn()
      },
    );
  }
}
