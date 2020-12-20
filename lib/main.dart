import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  String myText = "40";

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
      debugShowCheckedModeBanner: false,
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
                  SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        minimum: 0,
                        maximum: 150,
                        interval: 10,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0, endValue: 50, color: Colors.green),
                          GaugeRange(
                              startValue: 50,
                              endValue: 100,
                              color: Colors.orangeAccent),
                          GaugeRange(
                              startValue: 100, endValue: 150, color: Colors.red)
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                              value: double.parse('$myText'),
                              enableAnimation: true)
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Text('$myText' + 'db',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25)),
                              positionFactor: 0.3,
                              angle: 90)
                        ]),
                  ]),
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
