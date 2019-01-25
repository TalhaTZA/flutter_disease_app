import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/User.dart' as user;
import 'package:flutter/services.dart';
import 'kilmatic.dart' as k;

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  final TextEditingController _userController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  String _welcome = "";
  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.blueGrey,
      body: new Container(
        alignment: Alignment.topCenter,
        child: new ListView(
          children: <Widget>[
            new Image.asset(
              "images/face.png",
              width: 90.0,
              height: 90.0,
              color: Colors.lightGreen,
            ),

            //form
            new Container(
              height: 180.0,
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: _userController,
                    decoration: new InputDecoration(
                        hintText: 'UserName', icon: new Icon(Icons.person)),
                  ),
                  new TextField(
                    controller: _passwordController,
                    decoration: new InputDecoration(
                        hintText: 'Password', icon: new Icon(Icons.lock)),
                    obscureText: true,
                  ),
                  new Padding(padding: EdgeInsets.all(10.5)),
                  new Center(
                    child: new Row(
                      children: <Widget>[
                        new Builder(builder: (BuildContext context) {
                          return new Container(
                            margin: new EdgeInsets.only(left: 38.0),
                            child: new RaisedButton(
                              onPressed: () => _showWelcome(
                                  cxt: context, route: 'users/login'),
                              color: Colors.redAccent,
                              child: new Text(
                                "Login",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16.9),
                              ),
                            ),
                          );
                        }),
                        new Builder(builder: (BuildContext context) {
                          return new Container(
                            margin: new EdgeInsets.only(left: 120),
                            child: new RaisedButton(
                              onPressed: () => _showWelcome(
                                  cxt: context, route: 'users/register'),
                              color: Colors.redAccent,
                              child: new Text(
                                "Register",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16.9),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            ),

            new Padding(padding: EdgeInsets.all(14.0)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Welcome, $_welcome",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 19.4,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _erase() {
    hideKeyPad();
    setState(() {
      _userController.clear();
      _passwordController.clear();
      _welcome = "";
    });
  }

  void hideKeyPad() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void _showWelcome({BuildContext cxt, String route}) {
    _context = cxt;

    hideKeyPad();

    setState(() {
      if (_userController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        //_welcome = _userController.text;

        getUser(route: route);
      } else {
        Scaffold.of(cxt).showSnackBar(new SnackBar(
          content: new Text(
            "Fields empty",
            textAlign: TextAlign.center,
          ),
          duration: Duration(milliseconds: 1000),
        ));
        _welcome = "Nothing";
      }
    });
  }

  Future<Map> getUserFromServer({String route}) async {
    http.Response response = await http.post("http://localhost:3000/$route",
        body: {
          "name": "${_userController.text}",
          "password": "${_passwordController.text}"
        });

    if (response.statusCode == 200) {
      debugPrint("${response.body}");

      return json.decode(response.body);
    } else {
      debugPrint("${response.statusCode}");
    }
  }

  user.User getUser({String route}) {
    getUserFromServer(route: route).then((data) {
      var check = user.User.fromJson(data);
      debugPrint("${check.name}");
      showSnackBar(content: "${check.name}", indUser: check);

      var router = new MaterialPageRoute(
          builder: (BuildContext context) => new k.Klimatic(
                name: check.name,
                diseasesDynamic: check.diseases,
              ));

      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.of(context).push(router);
      });

      return check;
    }).catchError((err) {
      debugPrint("error while parsing the request.. $err");

      showSnackBar(
          content:
              "something went wrong.. have you entered correct user name and password ");
    });
  }

  void showSnackBar({String content, user.User indUser}) {
    Scaffold.of(_context).showSnackBar(new SnackBar(
      content: new Text(
        "$content",
        textAlign: TextAlign.center,
      ),
      duration: Duration(milliseconds: 500),
    ));

    setState(() {
      _welcome = "Nothing";
      if (indUser != null) {
        _welcome = indUser.name;
      }
      _userController.clear();
      _passwordController.clear();
    });
  }
}
