import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_final_v2/main.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_app_final_v2/pages/tabs/potd_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
Future<Post> fecthPost() async {
  final String apiKey = "F4WoitUqCpM5YGr8Mz5uMgCEF6ZrT4X8eFZd3b90";
  //final String apiKey = "DEMO_KEY";
  final String baseUrl =
      "https://api.nasa.gov/planetary/apod?api_key=";
  final String URL = baseUrl + apiKey;
  final response = await http.get(URL);

  if(response.statusCode == 200) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}

class Post {
  final String title;
  final String story;
  final String copyright;
  final String picURL;

  Post({this.title,this.story,this.copyright,this.picURL});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      story: json['explanation'],
      picURL: json['url'],
      copyright: json['copyright']
    );
  }
}
class FirstTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeView(),
    );
  }

}
var POAD_title;
var POAD_exlanation;
var POAD_url;
class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);  @override
  _HomeViewState createState() => _HomeViewState();
}class _HomeViewState extends State<HomeView> {
  Alignment childAlignment = Alignment.bottomCenter;@override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        // Add state updating code
        setState(() {
          childAlignment = visible ? Alignment.topCenter : Alignment.bottomCenter;
        });
      },
    );  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(232, 124, 188, 1.0),
        title: Text(
          "NASA PORD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        color: Color.fromRGBO(124, 232, 168, 1.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FutureBuilder(
                      future: fecthPost(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          POAD_url = snapshot.data.picURL;
                          POAD_exlanation = snapshot.data.story;
                          POAD_title = snapshot.data.title;
                          return Column(
                            children: <Widget>[
                              Card(
                                elevation: 75,
                                margin: EdgeInsets.all(10),
                                child: Hero(
                                  tag: 'dash',
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => POTD())),
                                    child: Image.network((snapshot.data.picURL
                                    )),
                                  )
                                )
                                ,
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top:  BorderSide(
                                      color: Color.fromRGBO(232, 124, 188, 1),
                                      width: 20,
                                    )
                                  )
                                ),
                                child: Text(
                                  snapshot.data.title,
                                  style: TextStyle(
                                    fontSize: 26,
                                    background: Paint(),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color.fromRGBO(232, 124, 188, 1),
                                        width: 20,
                                      )
                                    )
                                  ),
                                  padding: EdgeInsets.all(22),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "~STORY~\n",
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 10
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.story,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        } else if(snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

