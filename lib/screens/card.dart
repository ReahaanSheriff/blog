import 'dart:async';
import 'dart:convert';
import 'package:blogone/screens/add_blog.dart';
import 'package:blogone/screens/myblog.dart';
import 'package:blogone/screens/savedblogs_screen.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/cardview.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardView extends StatefulWidget {
  final String value;
  const CardView({Key? key, required this.value}) : super(key: key);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  var jsonData, username, dresponseBody;

  GlobalKey<ScaffoldState> _key = GlobalKey();

  currentUser() async {
    var token = await SharedPreferenceHelper().getToken();
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + token.toString()};
    var currentuserresponse, responseBody;

    try {
      currentuserresponse = await http.get(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );

      responseBody = jsonDecode(currentuserresponse.body);
      setState(() {
        username = responseBody['username'];
      });
      print(responseBody);

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
  }

  viewAllBlogs() async {
    var token = await SharedPreferenceHelper().getToken();
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/');

    final headers = {'Authorization': 'Token ' + token.toString()};
    var response, statusCode;
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);

      print(statusCode);
      print(jsonData);
      for (var i in jsonData) {
        print(i['image']);
      }
      setState(() {
        jsonData;
      });
    } on Exception catch (e) {
      print("error on view all blogs django api");
    }
    return jsonData;
  }

  deleteTokens() async {
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/deletetokens/');
    var currentuserresponse;

    try {
      currentuserresponse = await http.post(
        uri,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  signout() async {
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/logout/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
    var currentuserresponse;

    try {
      currentuserresponse = await http.post(
        uri,
        headers: headers,
        //body: jsonBody,
        //encoding: encoding,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
    viewAllBlogs();
    Timer(Duration(seconds: 1), () {
      viewAllBlogs();
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(username == null ? "" : username),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app.
                // ...
                // Then close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardView(value: widget.value)));
              },
            ),
            ListTile(
              title: const Text('Saved Blogs'),
              onTap: () {
                // Update the state of the app.
                // ...
                // Then close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedBlogs()));
              },
            ),
            ListTile(
              title: const Text('My Blogs'),
              onTap: () {
                // Update the state of the app.
                // ...
                // Then close the drawer
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyBlog()));
              },
            ),
            IconButton(
                onPressed: () {
                  signout().then((_) async {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    deleteTokens();
                  });
                },
                icon: Icon(
                  Icons.logout,
                  size: 32.0,
                  color: Colors.black,
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddBlog(value: widget.value)));
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Blog app"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (jsonData == null) Text("No Blogs"),
              if (jsonData != null)
                for (var i in jsonData.reversed.toList())
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CardFullView(blogid: i['blog_id'])));
                    },
                    child: GFCard(
                      boxFit: BoxFit.cover,
                      titlePosition: GFPosition.end,
                      image: Image.network(
                        "http://manikandanblog.pythonanywhere.com${i['image']}",
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      showImage: true,
                      title: GFListTile(
                        avatar: GFAvatar(
                          backgroundImage: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfUbi5bgcsNaRtcbmG7dR3R8e_kLca43xIg&usqp=CAU'),
                        ),
                        titleText: '${i['title']}',
                        subTitleText: "${i['username']}",
                        icon: Container(
                            child: Row(
                          children: [
                            if ('${i['liked']}' == "false" &&
                                '${i['username']}' != username)
                              Icon(Icons.favorite_border),
                            if ('${i['liked']}' == "true" &&
                                '${i['username']}' != username)
                              Icon(Icons.favorite),
                            SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.share)),
                            Padding(padding: EdgeInsets.only(top: 50))
                          ],
                        )),
                      ),
                      content: Text("${i['body']}\n"),
                      buttonBar: GFButtonBar(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 220)),
                          InkWell(
                            child: Text("Read More"),
                            onTap: () {
                              print("j");
                            },
                          ),
                          Icon(
                            Icons.double_arrow,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
