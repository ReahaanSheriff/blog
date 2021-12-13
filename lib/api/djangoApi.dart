// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:blogone/sharedPreference/sharedPref.dart';

// var currentToken;
// // Login
// login(String username, String password) async {
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/login/');
//   final headers = {'Content-Type': 'application/json'};
//   var statusCode, responsebody, token;
//   Map<String, dynamic> body = {
//     "username": username,
//     "password": password,
//   };
//   String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');
//   var response;

//   try {
//     response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//     statusCode = response.statusCode;
//     responsebody = jsonDecode(response.body);

//     print(responsebody);
//     SharedPreferenceHelper().saveToken(responsebody["token"]);
//     token = responsebody["token"];
//     currentToken = responsebody["token"];

//     print(token);
//   } on Exception catch (e) {
//     print("error on login django api \n $e");
//   }
//   return statusCode;
// }

// ss() async {
//   print(await SharedPreferenceHelper().getToken());
// }

// // Signin
// signin(String username, String email, String password) async {
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/register/');
//   final headers = {'Content-Type': 'application/json'};
//   var statuscode, responseBody;

//   Map<String, dynamic> body = {
//     "username": username,
//     "email": email,
//     "password": password
//   };
//   String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');
//   var response;

//   try {
//     response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//     statuscode = response.statusCode;
//     responseBody = jsonDecode(response.body);

//     print(responseBody);
//     print(statuscode);
//   } on Exception catch (e) {
//     print("Error in signin django api $e");
//   }
//   return statuscode;
// }

// forgetpassword(String email) async {
//   final uri =
//       Uri.parse('http://manikandanblog.pythonanywhere.com/password_reset/');
//   final headers = {'Content-Type': 'application/json'};
//   var response, fstatuscode, forgetresponsebody;
//   Map<String, dynamic> body = {
//     "email": email,
//   };
//   String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');

//   try {
//     response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//     fstatuscode = response.statusCode;
//     forgetresponsebody = json.decode(response.body);
//     print(fstatuscode);
//   } on Exception catch (e) {
//     print(e);
//   }
//   return fstatuscode;
// }

// resetpassword(String password, String token) async {
//   final uri = Uri.parse(
//       'http://manikandanblog.pythonanywhere.com/password_reset/confirm/');
//   final headers = {'Content-Type': 'application/json'};

//   Map<String, dynamic> body = {"password": password, "token": token};
//   String jsonBody = json.encode(body);
//   final encoding = Encoding.getByName('utf-8');
//   var response, rstatuscode, resetresponsebody;

//   try {
//     response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       encoding: encoding,
//     );
//     rstatuscode = response.statusCode;
//     resetresponsebody = jsonDecode(response.body);

//     print(resetresponsebody);
//     print(rstatuscode);
//     //print(statusCode);
//   } on Exception catch (e) {
//     print("error in reset password django api $e");
//   }
//   return rstatuscode;
// }

// dynamic generateOrderId() {
//   var rnd = new Random();
//   var next = rnd.nextDouble() * 1000000;
//   while (next < 100000) {
//     next *= 10;
//   }

//   return ('ord' + next.toInt().toString());
// }

// createBlog(String blogTitle, String blogBody, String image) async {
//   var id = generateOrderId();
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/');
//   final headers = {
//     //'Content-Type': 'application/json',
//     'Authorization': 'Token ' + ss().toString()
//   };
//   Map<String, dynamic> body = {
//     "blog_id": id,
//     "user_id_id": 4,
//     "title": blogTitle,
//     "body": blogBody,
//     "image": image
//   };
//   String jsonBody = json.encode(body);
//   //final encoding = Encoding.getByName('utf-8');
//   var response;
//   int statusCode;
//   String responseBody;
//   try {
//     response = await http.post(
//       uri,
//       headers: headers,
//       body: jsonBody,
//       //encoding: encoding,
//     );
//     statusCode = response.statusCode;
//     responseBody = response.body;
//     print(responseBody);
//     print(statusCode);
//   } on Exception catch (e) {
//     print("error on create blog django api $e");
//   }
// }

// viewAllBlogs() async {
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/');

//   //final headers = {'Authorization': 'Token ' + getCurrentToken().toString()};
//   var response, statusCode, jsonData;
//   try {
//     response = await http.get(
//       uri,
//       //   headers: headers,
//     );
//     statusCode = response.statusCode;
//     jsonData = jsonDecode(response.body);

//     print(statusCode);
//     print(jsonData);
//   } on Exception catch (e) {
//     print("error on view all blogs django api $e");
//   }
//   return jsonData;
// }

// viewOneBlog(String blogId) async {
//   final uri =
//       Uri.parse('http://manikandanblog.pythonanywhere.com/getblog/${blogId}');

//   //final headers = {'Authorization': 'Token ' + getCurrentToken().toString()};
//   var vresponse, vjsonData;
//   try {
//     vresponse = await http.get(
//       uri,
//       //  headers: headers,
//     );
//     //statusCode = vresponse.statusCode;
//     vjsonData = jsonDecode(vresponse.body);

//     print(vjsonData);

//     //print(statusCode);
//   } on Exception catch (e) {
//     print("error on view one blog django api");
//   }
//   return vjsonData;
// }

// userBlogs(String userId) async {
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/userBlog/');

//   //final headers = {'Authorization': 'Token ' + getCurrentToken().toString()};
//   var vresponse, vjsonData;
//   try {
//     vresponse = await http.get(
//       uri,
//       //  headers: headers,
//     );
//     //statusCode = vresponse.statusCode;
//     vjsonData = jsonDecode(vresponse.body);

//     print(vjsonData);

//     //print(statusCode);
//   } on Exception catch (e) {
//     print("error on view one blog django api");
//   }
//   return vjsonData;
// }

// currentUser() async {
//   var token = await SharedPreferenceHelper().getToken();
//   final uri =
//       Uri.parse('http://manikandanblog.pythonanywhere.com/currentuser/');
//   final headers = {'Authorization': 'Token ' + token.toString()};
//   var currentuserresponse, responseBody;

//   try {
//     currentuserresponse = await http.get(
//       uri,
//       headers: headers,
//       //body: jsonBody,
//       //encoding: encoding,
//     );

//     responseBody = jsonDecode(currentuserresponse.body);

//     print(responseBody);

//     //print(responseBody['id']);
//   } on Exception catch (e) {
//     print(e);
//     print('error on current user');
//   }
//   return responseBody['username'];
// }

// deleteTokens() async {
//   final uri =
//       Uri.parse('http://manikandanblog.pythonanywhere.com/deletetokens/');
//   var currentuserresponse;

//   try {
//     currentuserresponse = await http.post(
//       uri,
//     );
//   } on Exception catch (e) {
//     print(e);
//   }
// }

// signout() async {
//   final uri = Uri.parse('http://manikandanblog.pythonanywhere.com/logout/');
//   //final headers = {'Authorization': 'Token ' + getCurrentToken().toString()};
//   var currentuserresponse;

//   try {
//     currentuserresponse = await http.post(
//       uri,
//       // headers: headers,
//       //body: jsonBody,
//       //encoding: encoding,
//     );
//   } on Exception catch (e) {
//     print(e);
//   }
// }
