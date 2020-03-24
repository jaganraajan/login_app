import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String url = 'http://10.0.0.79:5000/api/auth/signin';
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  int statusCode;

  Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    Future _makePostRequest() async {
      // set up POST request arguments
      Map<String, String> headers = {"Content-type": "application/json"};
      String json = '{"email": "$_email", "password": "$_password"}';
      print(json);
      // make POST request
      Response response = await post(url, headers: headers, body: json);
      // check the status code for the result
      int statusCode = response.statusCode;
      // if not found
      if(statusCode == 400){
        _buildErrorDialog(context, "Invalid Credentials");
      }
    }



    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            // save the fields..
            final form = _formKey.currentState;
            form.save();
            _makePostRequest();
          },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: 105.0,
                      child: Image.asset(
                        "assets/logo2.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: 10.0),
                    Text(
                      'Login Information',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40.0),
                    TextFormField(
                        onSaved: (value) => _email = value,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email Address",
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                        )),
                    SizedBox(height: 20.0),
                    TextFormField(
                        onSaved: (value) => _password = value,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                        )),
                    SizedBox(height: 20.0),
                    loginButton,
                    FlatButton(
                      child: Text('New user? Create an account.'),
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                    )
                  ]))),
        ));
  }
}
