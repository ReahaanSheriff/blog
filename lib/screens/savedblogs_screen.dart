import 'dart:async';

import 'package:blogone/screens/cardview.dart';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blogone/sharedPreference/sharedPref.dart';
import 'package:load/load.dart';

var jsonData;

class SavedBlogs extends StatefulWidget {
  const SavedBlogs({Key? key}) : super(key: key);

  @override
  _SavedBlogsState createState() => _SavedBlogsState();
}

class _SavedBlogsState extends State<SavedBlogs> {
  savedBlogs() async {
    var token = await SharedPreferenceHelper().getToken();
    final uri =
        Uri.parse('http://manikandanblog.pythonanywhere.com/savedBlog/');

    final headers = {'Authorization': 'Token ' + token.toString()};
    var response, statusCode;
    try {
      response = await http.get(
        uri,
        headers: headers,
      );
      statusCode = response.statusCode;
      jsonData = jsonDecode(response.body);
      setState(() {
        jsonData;
      });
      print(statusCode);
      print(jsonData);
    } on Exception catch (e) {
      print(e);
      print("error on saved blogs django api");
    }
    return jsonData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    savedBlogs();
    Timer(Duration(seconds: 1), () {
      hideLoadingDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Blogs'),
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
                        // avatar: GFAvatar(
                        //   backgroundImage: AssetImage('assets/images/blog1.jpg'),
                        // ),
                        titleText: '${i['title']}',
                        subTitleText: "${i['username']}",

                        icon: Container(
                            child: Row(
                          children: [
                            if ('${i['liked']}' == "false")
                              Icon(Icons.favorite_border),
                            if ('${i['liked']}' == "true") Icon(Icons.favorite),
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
