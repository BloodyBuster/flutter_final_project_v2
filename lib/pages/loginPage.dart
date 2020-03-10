import 'dart:convert';
import 'dart:io';


import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app_final_v2/utilities/customDialogBox.dart';

import 'package:flutter_app_final_v2/utilities/customLoadingScreen.dart';

import 'package:flutter_app_final_v2/pages/mainMenu.dart';

import 'package:keyboard_visibility/keyboard_visibility.dart';

import 'package:flare_flutter/flare_actor.dart';

import 'package:flutter_app_final_v2/main.dart';

import 'package:flutter_app_final_v2/utilities/bubble_painter.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();

    } else {
      _isButtonDisable = false;
      setState(() {
        _isLoading = false;
      });
    }
  }

  login() async {
    try {
      final response = await http.post("https://sislogwarehouse.000webhostapp.com/flutter/login.php",
          body: {"email": email, "password": password});
      final data = jsonDecode(response.body);
      int value = data['value'];
      String pesan = data['message'];
      print(pesan);
      String emailAPI = data['email'];
      print(emailAPI);
      String namaAPI = data['nama'];
      print(namaAPI);
      String id = data['id'];

      if (value == 1) {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, emailAPI, namaAPI, id);
        });
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "Success",
            description:
            "Welcome $namaAPI \nYou are now logged in",
            buttonText: "Okay",
          ),
        );
        _isButtonDisable = false;
        setState(() {
          _isLoading = false;
        });


      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
            title: "Login Failed",
            description:
            "Please make sure all you credential is correct",
            buttonText: "Okay",
          ),
        );
        _isButtonDisable = false;
        setState(() {
          _isLoading = false;
        });


      }
    } on Exception catch (_) {
      print("throwing new error");
      setState(() {
        _isLoading = false;
      });
      _isButtonDisable = false;
      showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog(
          title: "No Internet Connection",
          description:
          "Hmmmm.... It looks like you don't have internet connection, try reseting you connection",
          buttonText: "Okay",
        ),
      );
      throw Exception("Error on server");
    }

  }

  savePref(int value, String email, String nama, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nama", nama);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }
  @protected
  void initState() {
    // TODO: implement initState
    getPref();
    _pageController = PageController();
    _isButtonDisable = false;
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        // Add state updating code
        setState(() {
          animatedContainer();
        });
      },
    );  super.initState();

  }
  bool _isButtonDisable = false;
  bool _isLoading =false;
  PageController _pageController;
  animatedContainer() {
    setState(() {
      _loginPageHeighNormal = _loginPageHeighNormal == EdgeInsets.only(top: 223.8) ? EdgeInsets.only(top: 0) : EdgeInsets.only(top: 223.8);
      _backPageTopLeftRadius = _backPageTopLeftRadius == Radius.circular(60) ? Radius.circular(0) : Radius.circular(60);
      _loginPageSelector = _loginPageSelector == EdgeInsets.only(top: 0) ? EdgeInsets.only(top: 20) : EdgeInsets.only(top: 0);
    });
  }
  animatedSelector() {
    setState(() {
      _selectorBackgroundColor = _selectorBackgroundColor == LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      ) ? LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ) : LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
      );
    });
  }
  EdgeInsets _loginPageHeighNormal = EdgeInsets.only(top: 223.8);
  Radius _backPageTopLeftRadius = Radius.circular(60);
  EdgeInsets _loginPageSelector = EdgeInsets.only(top: 0);
  void _onSignInButtonPress() {
    animatedSelector();
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
  void _onSignUpButtonPress() {
    animatedSelector();
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }
  Color _rightSelectorColor = Colors.white;
  Color _leftSelectorColor = Colors.black;
  LinearGradient _selectorBackgroundColor = LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
  );
  @override
  Widget _buildMenuBar(BuildContext context) {
    return AnimatedContainer(
      width: 300.0,
      height: 50.0,
      duration: Duration(milliseconds:200),
      decoration: BoxDecoration(
        gradient: _selectorBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        border: Border.all(
          color: Colors.white,
          width: 0.25
        )
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Existing",
                  style: TextStyle(
                    color: _rightSelectorColor,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "New",
                  style: TextStyle(
                    color: _leftSelectorColor,
                      fontSize: 16.0,
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Color.fromRGBO(40, 40, 79,1),
              body: WillPopScope(
                  onWillPop: ()  {
                    Future.value(
                        false
                    );
                    exit(0);
                  },
                child:SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: ProgressHUD(
                    child: Column(
                      children: <Widget>[
                        Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height/3.0 + 45,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(27, 27, 54,1),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(-90)
                                  )
                              ),
                              child:flare1,
                            ),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 175),
                              margin: _loginPageHeighNormal,
                              padding: _loginPageSelector,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(40, 40, 79,1),
                                borderRadius: BorderRadius.only(
                                    topLeft: _backPageTopLeftRadius
                                ),
                                //boxShadow: [
                                //BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 2)
                                //],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height >= 775.0
                                        ? MediaQuery.of(context).size.height
                                        : 775.0,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: _buildMenuBar(context),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: PageView(
                                            controller: _pageController,
                                            physics: NeverScrollableScrollPhysics(),
                                            onPageChanged: (i) {
                                              if (i == 0) {
                                                setState(() {

                                                  _leftSelectorColor = Colors.black;
                                                  _rightSelectorColor = Colors.white;
                                                });
                                              } else if (i == 1) {
                                                setState(() {
                                                  _leftSelectorColor = Colors.white;
                                                  _rightSelectorColor = Colors.black;

                                                });
                                              }
                                            },
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.only(top: 0,left: 20,bottom: 0,right: 20),
                                                        margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                                                        constraints: BoxConstraints.expand(height: 240),
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(51, 51, 102,1),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          boxShadow: [
                                                            BoxShadow(color: Colors.black12,
                                                                blurRadius: 10.0,
                                                                offset: Offset(0.0, 10.0))
                                                          ],
                                                        ),
                                                        child: Container(
                                                          child: Form(
                                                            key: _key,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Center(
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(top: 15,left: 20,bottom: 15,right: 20),
                                                                    child: Text(
                                                                      "Sign-In",
                                                                      style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(bottom: 10,top: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(17.0),
                                                                    color: Color.fromRGBO(31, 31, 56,0.5),
                                                                  ),
                                                                  child: TextFormField(
                                                                    /*validator: (e) {
                                                    if (e.isEmpty) {
                                                      return "Please insert email";
                                                    }
                                                  },*/
                                                                    onSaved: (e) => email = e,
                                                                    style: TextStyle(
                                                                        color: Colors.white
                                                                    ),
                                                                    //focusNode: ,
                                                                    decoration: InputDecoration(
                                                                      labelText: "E-mail",
                                                                      labelStyle: TextStyle(
                                                                        color: Colors.grey,
                                                                        fontSize: 15,
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      hasFloatingPlaceholder: false,
                                                                      // fillColor: Colors.greenAccent,
                                                                      prefixIcon: Icon(Icons.email,color: Colors.white,),
                                                                      focusedBorder:OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.white, width: 0.75),
                                                                        borderRadius: BorderRadius.circular(17.0),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:  BorderRadius.circular(17.0),
                                                                        borderSide:  BorderSide(
                                                                          color: Colors.white,
                                                                          width: 0.75,
                                                                        ),
                                                                      ),

                                                                      //labelText: "E-mail",
                                                                    ),

                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(bottom: 20,top: 10),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(17.0),
                                                                    color: Color.fromRGBO(31, 31, 56,0.5),
                                                                  ),
                                                                  child: TextFormField(
                                                                    obscureText: _secureText,
                                                                    onSaved: (e) => password = e,
                                                                    style: TextStyle(
                                                                        color: Colors.white
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      labelStyle: TextStyle(
                                                                        color: Colors.grey,
                                                                        fontSize: 15,
                                                                      ),
                                                                      labelText: "Password",
                                                                      hasFloatingPlaceholder: false,
                                                                      fillColor: Colors.white,
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      prefixIcon: Icon(Icons.vpn_key,color: Colors.white,),
                                                                      focusedBorder:OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.white, width: 0.75),
                                                                        borderRadius: BorderRadius.circular(17.0),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:  BorderRadius.circular(17.0),
                                                                        borderSide:  BorderSide(
                                                                          color: Colors.white,
                                                                          width: 0.75,
                                                                        ),
                                                                      ),
                                                                      suffixIcon: IconButton(
                                                                        onPressed: showHide,
                                                                        icon: Icon(_secureText
                                                                            ? Icons.visibility_off
                                                                            : Icons.visibility,color: Colors.white,),
                                                                      ),
                                                                    ),

                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          bottom: -25,
                                                          left: Consts.padding-20,
                                                          right: Consts.padding-20,
                                                          child:Container(
                                                            margin: EdgeInsets.only(left: 95, right: 95),
                                                            height: 55,
                                                            child: RaisedButton(
                                                              onPressed: () {
                                                                FocusScopeNode currentFocus = FocusScope.of(context);
                                                                if (!currentFocus.hasPrimaryFocus) {
                                                                  currentFocus.unfocus();
                                                                }
                                                                if(_isButtonDisable == false) {
                                                                  setState(() {
                                                                    _isLoading = true;
                                                                  });
                                                                  _isButtonDisable = true;
                                                                  check();
                                                                }
                                                              },
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                    gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                                                      begin: Alignment.centerLeft,
                                                                      end: Alignment.centerRight,
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(17.0)
                                                                ),
                                                                child: Container(
                                                                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    "LOGIN",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        letterSpacing: 3.0,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ),

                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(top: 20,bottom: 5),
                                                    margin: EdgeInsets.only(top: 20),
                                                    child: Text(
                                                      "Forget Password?",
                                                      style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(children: <Widget>[
                                                    Expanded(
                                                      child: new Container(
                                                          margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                                                          child: Divider(
                                                            color: Colors.white70,
                                                            height: 50,
                                                            thickness: 1.0,
                                                            indent: 90,
                                                          )),
                                                    ),
                                                    Text(
                                                      "Or",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: new Container(
                                                          margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                                                          child: Divider(
                                                            color: Colors.white70,
                                                            height: 50,
                                                            thickness: 1.0,
                                                            endIndent: 90,
                                                          )),
                                                    ),
                                                  ]),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 0, right: 40.0),
                                                        child: GestureDetector(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(10.0),
                                                            decoration: new BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.white,
                                                            ),
                                                            child: new Icon(
                                                              FontAwesomeIcons.facebookF,
                                                              color: Color(0xFF0084ff),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 0),
                                                        child: GestureDetector(
                                                          child: Container(
                                                            padding: const EdgeInsets.all(10.0),
                                                            decoration: new BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Color.fromRGBO(255, 255, 255,1),
                                                            ),
                                                            child: new Icon(
                                                              FontAwesomeIcons.google,
                                                              color: Colors.redAccent,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Stack(
                                                    overflow: Overflow.visible,
                                                    children: <Widget>[
                                                      Container(
                                                        padding: EdgeInsets.only(top: 0,left: 20,bottom: 0,right: 20),
                                                        margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                                                        constraints: BoxConstraints.expand(height: 240),
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(51, 51, 102,1),
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          boxShadow: [
                                                            BoxShadow(color: Colors.black12,
                                                                blurRadius: 10.0,
                                                                offset: Offset(0.0, 10.0))
                                                          ],
                                                        ),
                                                        child: Container(
                                                          child: Form(
                                                            //key: _key,
                                                            child: Column(
                                                              children: <Widget>[
                                                                Center(
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(top: 15,left: 20,bottom: 15,right: 20),
                                                                    child: Text(
                                                                      "Sign-Up",
                                                                      style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(bottom: 10,top: 5),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(17.0),
                                                                    color: Color.fromRGBO(31, 31, 56,0.5),
                                                                  ),
                                                                  child: TextFormField(
                                                                    onSaved: (e) => email = e,
                                                                    style: TextStyle(
                                                                        color: Colors.white
                                                                    ),
                                                                    //focusNode: ,
                                                                    decoration: InputDecoration(
                                                                      labelText: "First Name",
                                                                      labelStyle: TextStyle(
                                                                        color: Colors.grey,
                                                                        fontSize: 15,
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      hasFloatingPlaceholder: false,
                                                                      // fillColor: Colors.greenAccent,
                                                                      prefixIcon: Icon(Icons.person,color: Colors.white,),
                                                                      focusedBorder:OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.white, width: 0.75),
                                                                        borderRadius: BorderRadius.circular(17.0),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:  BorderRadius.circular(17.0),
                                                                        borderSide:  BorderSide(
                                                                          color: Colors.white,
                                                                          width: 0.75,
                                                                        ),
                                                                      ),

                                                                      //labelText: "E-mail",
                                                                    ),

                                                                  ),
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets.only(bottom: 20,top: 10),
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(17.0),
                                                                    color: Color.fromRGBO(31, 31, 56,0.5),
                                                                  ),
                                                                  child: TextFormField(
                                                                    onSaved: (e) => password = e,
                                                                    style: TextStyle(
                                                                        color: Colors.white
                                                                    ),
                                                                    decoration: InputDecoration(
                                                                      labelStyle: TextStyle(
                                                                        color: Colors.grey,
                                                                        fontSize: 15,
                                                                      ),
                                                                      labelText: "Last Name",
                                                                      hasFloatingPlaceholder: false,
                                                                      fillColor: Colors.white,
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      prefixIcon: Icon(Icons.person,color: Colors.white,),
                                                                      focusedBorder:OutlineInputBorder(
                                                                        borderSide: const BorderSide(color: Colors.white, width: 0.75),
                                                                        borderRadius: BorderRadius.circular(17.0),
                                                                      ),
                                                                      enabledBorder: OutlineInputBorder(
                                                                        borderRadius:  BorderRadius.circular(17.0),
                                                                        borderSide:  BorderSide(
                                                                          color: Colors.white,
                                                                          width: 0.75,
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          bottom: -25,
                                                          left: Consts.padding-20,
                                                          right: Consts.padding-20,
                                                          child:Container(
                                                            margin: EdgeInsets.only(left: 95, right: 95),
                                                            height: 55,
                                                            child: RaisedButton(
                                                              onPressed: () {
                                                                FocusScopeNode currentFocus = FocusScope.of(context);
                                                                if (!currentFocus.hasPrimaryFocus) {
                                                                  currentFocus.unfocus();
                                                                }
                                                                if(_isButtonDisable == false) {
                                                                  setState(() {
                                                                    _isLoading = true;
                                                                  });
                                                                  _isButtonDisable = true;
                                                                  check();
                                                                }
                                                              },
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.0)),
                                                              padding: EdgeInsets.all(0.0),
                                                              child: Ink(
                                                                decoration: BoxDecoration(
                                                                    gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                                                      begin: Alignment.centerLeft,
                                                                      end: Alignment.centerRight,
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(17.0)
                                                                ),
                                                                child: Container(
                                                                  constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                                                  alignment: Alignment.center,
                                                                  child: Text(
                                                                    "NEXT",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        letterSpacing: 3.0,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    inAsyncCall: _isLoading,
                    opacity: 0.0,
                  ),
                )

              )
          ),
        );
        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
        break;
    }
  }
}


// class _RegisterState extends State<Register> {



class ProgressHUD extends StatelessWidget {

  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Animation<Color> valueColor;

  ProgressHUD({
    Key key,
    @required this.child,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = new Stack(
        children: [
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Consts.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child:Column(
              children: <Widget>[
                Container(
                  child: CustomLoadingScreen(
                    title: "XX",
                    buttonFalseText: "xxx",
                    buttonTrueText: "X",
                    description: "xxxxX",
                  ),
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/2-25,),
                )

              ],
             )

          ),

        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}