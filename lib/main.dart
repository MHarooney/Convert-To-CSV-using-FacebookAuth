import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'dart:io';

import 'package:simpleappauth/csv_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();


  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v10.0/me?fields=id,name,picture,email,name_format,birthday,hometown&access_token=${token}'));

        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

//in Your case
  List<List<dynamic>> csvData= [
    ["ID","username","email"],
    [123,"user 1","user1@email.com"]
  ];

  Future<File> csvFile = CsvController.getCsvFromList(csvData);
  if(csvFile != null){
  print("File created here :"+csvFile.path);
  }else{
  print("file not created");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: _isLoggedIn
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  userProfile["picture"]["data"]["url"],
                  height: 100.0,
                  width: 100.0,
                ),
                Text(userProfile["id"]),
                Text(userProfile["name"]),
                Text(userProfile["email"]),
                Text(userProfile["name_format"]),
                Text(userProfile["birthday"] ?? 'Birthday: empty'),
                Text(userProfile["hometown"] ?? 'Hometown: empty'),
                OutlinedButton(
                  child: Text("Logout"),
                  onPressed: () {
                    _logout();
                  },
                )
              ],
            )
                : Center(
              child: OutlinedButton(
                child: Text("Login with Facebook"),
                onPressed: () {
                  _loginWithFB();
                },
              ),
            )),
      ),
    );
  }
}
