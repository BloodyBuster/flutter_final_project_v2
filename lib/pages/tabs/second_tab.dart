import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_final_v2/main.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
var dataJSON;
List data;
Future<Post> fecthPost() async {
  final String baseUrl =
      "https://spaceflightnewsapi.net/api/v1/blogs";
  final String URL = baseUrl;
  final response = await http.get(URL);

  if(response.statusCode == 200) {
    dataJSON = json.decode(response.body);
    data = dataJSON['docs'];
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load post');
  }
}
class Post {
  final String title;
  final String published_Date;
  final String url;
  final String featured_Image;

  Post({this.title,this.published_Date,this.url,this.featured_Image,});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        title: json['docs'][0]['title'],
        published_Date: json['published_date'],
        featured_Image: json['featured_image'],
        url: json['url']
    );
  }
}
class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeView(),
    );
  }

}

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
          print("XX");
        });
      },
    );  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(124, 232, 168, 1.0),
            child: FutureBuilder(
            future: fecthPost(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Scrollbar(
                    child: ListView.builder(
                        itemCount: data == null ? 0 : data.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(data[index]['title']);
                          return Container();
                        }
                    ),
                  );
                } else if(snapshot.hasError) {
                return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }
            )
      ),
    );
  }
}

