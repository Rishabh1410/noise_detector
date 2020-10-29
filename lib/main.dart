import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Post {
  dynamic sound;

  Post({this.sound});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(sound: json['sound']);
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["sound"] = sound;
    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  return http.post(url, body: body).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Failed to fetch");
    }
    return Post.fromJson(json.decode(response.body));
  });
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  String myText = "0";

  static final CREATE_POST_URL = 'http://192.168.4.1/convertDataToJson';

  void initState() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      changesound();
    });
  }

  void changesound() async {
    Post p = await createPost(CREATE_POST_URL);

    setState(() {
      myText = p.sound.toString();
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "WEB SERVICE",
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('sound Reader'),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new SizedBox(
                height: 20,
              ),
              new Text(
                'Current sound in decible',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.pink,
                  fontFamily: 'Pacifico',
                ),
              ),
              new SizedBox(
                height: 20,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "${myText}",
                    style: TextStyle(
                      fontSize: 45,
                      fontFamily: 'Bitter-Regular',
                    ),
                  ),
                  new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            "db",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Bitter-Regular',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              new SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
