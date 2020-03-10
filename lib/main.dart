import 'package:flutter/material.dart';
import 'package:flutter_app_final_v2/utilities/navigator.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';
bool notStop = true;
var loadingSplash = "Loading Assets ";
FlareActor flare1;
FlareActor flare2;
FlareActor flare3;
Image image2;
Image image3;
Image image4;
void main() async {
  // initial settings
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MaterialApp(
    theme:
    ThemeData(primaryColor: Colors.white, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes,
  ));

}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getMessage();
    flare1 = FlareActor("assets/flare/space_demo.flr", alignment:Alignment.topCenter, fit:BoxFit.cover, animation:"idle");
    flare2 = FlareActor("assets/flare/sapce.flr", alignment:Alignment.topCenter, fit:BoxFit.cover, animation:'idle');
    Timer(Duration(seconds: 8), () => MyNavigator.goToLogin(context));
    Timer(Duration(seconds: 5), () => changeState());

  }

  changeState() {
    setState(() {
      notStop = false;
    }) ;

  }

  getMessage() {
    if(notStop) {
      setState(() {
        loadingSplash += ".";
      }) ;
      Timer(Duration(microseconds: 500000), () => getMessage());
      if(loadingSplash.length > 25) {
        setState(() {
          loadingSplash = "Loading Assets ";
        }) ;
      }
    }

  }
  Widget build(BuildContext context) {
    return  Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            Future.value(
                false
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Color.fromRGBO(40, 40, 79,1),),
                child: flare2
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: FlareActor("assets/flare/EARTH.flr", alignment:Alignment.topCenter, fit:BoxFit.cover, animation:'roll'),
                            height: 200,
                            width: 200,
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            "Astronomy",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: FlareActor("assets/flare/loading3.flr", alignment:Alignment.topCenter, fit:BoxFit.cover, animation:'Alarm'),
                          width: 100,
                          height: 100,
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 20),
                        ),
                        Text(loadingSplash,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),)
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}