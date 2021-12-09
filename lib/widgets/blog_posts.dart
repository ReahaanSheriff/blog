import 'dart:async';

import 'package:blogone/models/author_model.dart';
//import 'package:blogone/models/blog_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/screens/blog_screen.dart';
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

var jsonData, username;

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
  for (var i in jsonData)
    Blog(
      imageUrl: 'http://manikandanblog.pythonanywhere.com${i['image']}',
      name: '${i['title']}',
      author: '${i['username']}',
      liked: '${i['like']}',
      created_at: "${i['created']}",
      content: '${i['body']}',
    )
];

class BlogPosts extends StatefulWidget {
  const BlogPosts({Key? key}) : super(key: key);

  @override
  _BlogPostsState createState() => _BlogPostsState();
}

class _BlogPostsState extends State<BlogPosts> {
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

      print(responseBody);
      setState(() {
        username = responseBody['username'];
      });

      //print(responseBody['id']);
    } on Exception catch (e) {
      print(e);
      print('error on current user');
    }
    return responseBody;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    viewAllBlogs();

    currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (jsonData != null)
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            height: MediaQuery.of(context).size.width * 0.90,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: blogs.length,
              itemBuilder: (BuildContext context, int index) {
                final Blog blog = blogs[index];
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlogScreen(blog: blog)))
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: MediaQuery.of(context).size.width * 0.90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0.0, 4.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.10)
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Image(
                                image: NetworkImage(blog.imageUrl),
                                fit: BoxFit.cover,
                              ),
                            )),
                        Positioned(
                          bottom: 10.0,
                          left: 10.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.60,
                                child: Text(
                                  blog.name,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                      radius: 10.0,
                                      backgroundImage:
                                          NetworkImage(blog.imageUrl)),
                                  SizedBox(width: 8.0),
                                  Text(blog.name,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.0)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.timer,
                                size: 10.0,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5.0),
                              Text(blog.created_at.substring(0, 6),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                  ))
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: Icon(Icons.bookmark,
                              size: 26.0, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        SizedBox(height: 5.0)
      ],
    );
  }
}
