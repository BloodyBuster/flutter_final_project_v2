import 'package:flutter/material.dart';
import 'package:flutter_app_final_v2/pages/loginPage.dart';

var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => Login(),

};

class MyNavigator {
  static void goToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

}