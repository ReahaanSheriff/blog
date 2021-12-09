import 'package:blogone/api/djangoApi.dart';
import 'package:blogone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var emailcontroller = new TextEditingController();
  var tokencontroller = new TextEditingController();
  var passwordcontroller = new TextEditingController();
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget password"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Forget Password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: emailcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  forgetpassword(emailcontroller.text.trim()).then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Mail Send Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      emailcontroller.text = "";
                    } else {
                      Fluttertoast.showToast(
                          msg: "Error in reset password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Get Token")),
            SizedBox(
              height: 10,
            ),
            TextFormField(
                controller: tokencontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Token',
                )),
            TextFormField(
                obscureText: _isObscure,
                controller: passwordcontroller,
                onFieldSubmitted: (String str) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                  ),
                )),
            ElevatedButton(
                onPressed: () {
                  resetpassword(passwordcontroller.text.trim(),
                          tokencontroller.text.trim())
                      .then((value) {
                    if (value == 200) {
                      Fluttertoast.showToast(
                          msg: "Reset Password Successful",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 4,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    } else {
                      Fluttertoast.showToast(
                          msg: "Error in reset Password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 6,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
