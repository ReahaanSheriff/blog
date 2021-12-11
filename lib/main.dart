import 'package:blogone/screens/card.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

var token;
void main() async {
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anni Blog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: token == null ? "signin" : "/",
      routes: {
        '/': (context) => CardView(value: token),
        "signin": (context) => SignIn()
      },
    );
  }
}
