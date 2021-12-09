import 'dart:async';

import 'package:blogone/models/author_model.dart';
//import 'package:blogone/models/blog_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/blog_screen.dart';
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

var vjsonData, username;

class Blog {
  String imageUrl;
  String name;
  String author;
  String liked;
  String created_at;
  String content;

  Blog(
      {required this.imageUrl,
      required this.name,
      required this.author,
      required this.liked,
      required this.created_at,
      required this.content});
}

final List<Blog> blogs = [
  for (var i in vjsonData)
    Blog(
      imageUrl: 'http://manikandanblog.pythonanywhere.com${i['image']}',
      name: '${i['title']}',
      author: '${i['username']}',
      liked: '${i['like']}',
      created_at: "${i['created']}",
      content: '${i['body']}',
    )
];

class RecentPosts extends StatefulWidget {
  const RecentPosts({Key? key}) : super(key: key);

  @override
  _RecentPostsState createState() => _RecentPostsState();
}

class _RecentPostsState extends State<RecentPosts> {
  otherUserBlogs() async {
    var token = await SharedPreferenceHelper().getToken();
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/otherUserBlog/');

    final headers = {'Authorization': 'Token ' + token.toString()};
    var vresponse;
    try {
      vresponse = await http.get(
        uri,
        headers: headers,
      );
      //statusCode = vresponse.statusCode;
      vjsonData = jsonDecode(vresponse.body);
      setState(() {
        vjsonData;
      });
      print("test");
      print(vjsonData);

      //print(statusCode);
    } on Exception catch (e) {
      print("error on view one blog django api");
    }
    return vjsonData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    otherUserBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (vjsonData == null)
          Container(
            child: Text("no data"),
          ),
        if (vjsonData != null)
          Container(
            color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: blogs
                    .map((blog) => Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration:
                              BoxDecoration(color: Colors.white, boxShadow: [
                            BoxShadow(
                                color: Color(0xFFFAFAFA),
                                offset: Offset(0.0, 10.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.5)
                          ]),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.22,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image(
                                      image: NetworkImage(blog.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.66,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 5.0),
                                      Text(
                                        blog.author,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(height: 5.0),
                                      Container(
                                        height: 65,
                                        child: Text(
                                          blog.name,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.timer,
                                                color: Colors.grey,
                                                size: 12.0,
                                              ),
                                              SizedBox(width: 5.0),
                                              Text(
                                                blog.created_at,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 20.0),
                                          Row(
                                            children: <Widget>[
                                              // Icon(
                                              //   Icons.remove_red_eye,
                                              //   color: Colors.grey,
                                              //   size: 12.0,
                                              // ),
                                              // SizedBox(width: 5.0),
                                              // Text(
                                              //   "7k Views",
                                              //   style: TextStyle(
                                              //     color: Colors.grey,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList()),
          ),
      ],
    );
  }
}
