import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final String value;
  final String blogid;
  const Report({Key? key, required this.value, required this.blogid})
      : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  var msgController = new TextEditingController();
  var statusCode;

  report() async {
    final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/report/');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token ' + widget.value.toString()
    };
    Map<String, dynamic> body = {
      "blog_id": widget.blogid,
      "message": msgController.text,
    };
    String jsonBody = json.encode(body);
    //final encoding = Encoding.getByName('utf-8');
    var response;
    String responseBody;
    try {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonBody,
        //encoding: encoding,
      );
      statusCode = response.statusCode;
      responseBody = response.body;
      print(responseBody);
      print(statusCode);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e);
      print("error on report blog func");
    }
    return statusCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Action will be taken only if blog content involves any nudity, violence, harrassment, hate speech, terrorism",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              enabled: false,
              controller: TextEditingController()..text = widget.blogid,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Blog Id"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: msgController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your message..."),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if (msgController.text != "") {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Report'),
                      content: Text('Are you sure you want to report?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                          child: const Text('Back'),
                        ),
                        TextButton(
                          onPressed: () {
                            try {
                              report().then((value) {
                                if (value == 201) {
                                  Fluttertoast.showToast(
                                      msg: "Reported Successfully",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 4,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  msgController.text = '';
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Cannot Report",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 4,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong, Please try later",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 4,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }

                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                      msg: "Message field cannot be empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 4,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: Text("Report"))
        ],
      ),
    );
  }
}
