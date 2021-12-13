import 'package:blogone/screens/cardview.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyBlog extends StatefulWidget {
  final String value;
  const MyBlog({Key? key, required this.value}) : super(key: key);

  @override
  _MyBlogState createState() => _MyBlogState();
}

class _MyBlogState extends State<MyBlog> {
  var jsonData, username;
  currentUser() async {
    //var token = await SharedPreferenceHelper().getToken();
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/currentuser/');
    final headers = {'Authorization': 'Token ' + widget.value.toString()};
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

  viewUserBlogs() async {
    //var token = await SharedPreferenceHelper().getToken();
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/userBlog/');

    final headers = {'Authorization': 'Token ' + widget.value.toString()};
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
      print("error on view all blogs django api $e");
    }
    return jsonData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser();
    viewUserBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(username == null ? "" : username + ' blogs'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              if (jsonData == null) Text("No Blogs"),
              if (jsonData != null)
                for (var i in jsonData)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CardFullView(
                                  blogid: i['blog_id'], value: widget.value)));
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
                        // avatar: GFAvatar(
                        //   backgroundImage: AssetImage('assets/images/blog1.jpg'),
                        // ),
                        titleText: '${i['title']}',
                        subTitleText: "${i['username']}",

                        icon: Container(
                            child: Row(
                          children: [
                            Icon(Icons.favorite_border),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.share),
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