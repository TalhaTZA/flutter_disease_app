import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/Disease.dart';
import 'dart:math';

class Klimatic extends StatefulWidget {
  final String name;
  final List<dynamic> diseasesDynamic;

  Klimatic({Key key, this.name , this.diseasesDynamic}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  List<Disease> _listDisease;
  String _diseaseName = "";

  @override
  Widget build(BuildContext context) {

    parseList();

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Welcome ${widget.name}"),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.refresh), onPressed: () => debugPrint('refresh pressed'))
        ],
      ),
      body: new GestureDetector(
        onTap: changeDisease,
        child: new Center(
          child: new Text(
            "$_diseaseName",
            style: new TextStyle(
                fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      ),
    );
  }

  void parseList(){
    _listDisease = List<Disease>.from(widget.diseasesDynamic.map((i) => Disease.fromJson(i)));
    changeDisease();
  }

  Future<List> getDiesasesList() async {
    http.Response response = await http.get("http://10.17.0.19:8888/list");

    //var dis =new Disease.fromJson(json.decode(response.body));

    //debugPrint(dis.name);

    //debugPrint(response.body);

    if (response.statusCode == 200) {
      var parsed = json.decode(response.body);

      _listDisease = List<Disease>.from(parsed.map((i) => Disease.fromJson(i)));
      changeDisease();
    } else {
      debugPrint("${response.statusCode}");
    }
    //debugPrint("${list[2].name}");

    return json.decode(response.body);
  }

  void changeDisease() {
    setState(() {
      _diseaseName =
          _listDisease[new Random().nextInt(_listDisease.length)].number;
    });
  }
}
