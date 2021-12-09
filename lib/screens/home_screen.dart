import 'dart:async';

import 'package:blogone/api/djangoApi.dart';
import 'package:blogone/screens/add_blog.dart';
import 'package:blogone/screens/signin_screen.dart';
import 'package:blogone/widgets/blog_posts.dart';
import 'package:blogone/widgets/fav_authors.dart';
import 'package:blogone/widgets/recent_posts.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String value;
  HomeScreen({required this.value});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Anni Blog",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      SizedBox(width: 20.0),
                      Icon(
                        Icons.menu,
                        size: 32.0,
                        color: Colors.black,
                      ),
                      IconButton(
                          onPressed: () {
                            signout().then((_) async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignIn()));
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
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                //FavAuthors(),
                Padding(
                  padding: const EdgeInsets.only(right: 280.0),
                  child: Text(
                    "My Blogs",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                BlogPosts(),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "TimeLine",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   "See all",
                        //   style: TextStyle(
                        //       color: Colors.lightBlueAccent, fontSize: 16.0),
                        // )
                      ],
                    ),
                  ),
                ),
                RecentPosts(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
