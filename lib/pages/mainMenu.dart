
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_app_final_v2/utilities/customConformationDialog.dart';
import 'package:flutter_app_final_v2/main.dart';
import 'package:flutter_app_final_v2/pages/tabs/first_tab.dart';
import 'package:flutter_app_final_v2/pages/tabs/second_tab.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with SingleTickerProviderStateMixin {

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  getMessage() {
    print("WIRGH");
  }

  String email = "",
      nama = "";

//  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
      nama = preferences.getString("nama");
    });
  }

  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    getPref();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  TabBar getTabBar() {
    return TabBar(
      tabs: <Widget>[
        Tab(
          icon: Icon(Icons.videogame_asset),
        ),
        Tab(
          icon: Icon(MdiIcons.trophyVariant),
        ),
        Tab(
          icon: Icon(Icons.settings),
        ),

      ],
      controller: tabController,
    );
  }

  TabBarView getTabBarView(var tabs) {
    return TabBarView(
      physics: NeverScrollableScrollPhysics(),
      controller: tabController,
      children: tabs,
    );
  }

  Future<bool> _onBackPressed() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return CustomConformationDialog(
          title: "Exit",
          description: "You are going to\n close this application",
          buttonTrueText: "Confirm",
          buttonFalseText: "Cancel",
          dialogIcon: Icon(Icons.exit_to_app, size: 50, color: Colors.white,),
          action: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                      side: BorderSide(color: Colors.green),
                    ),
                    color: Colors.green,
                    onPressed: () {
                      Navigator.of(context).pop();
                      signOut();
                    },
                    child: Text("Confirm",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                  margin: const EdgeInsets.only(right: 5.5),
                ),
                Container(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0),
                      side: BorderSide(color: Colors.grey),
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                      style: TextStyle(
                          color: Colors.white
                      ),),
                  ),
                  margin: const EdgeInsets.only(left: 5.5),
                ),


              ],
            ),
          ),

        );
      },
    );
  }
  int pageIndex= 2;



  Widget _showPage =  new FirstTab();
  final FirstTab _FirstTab = FirstTab();
  final SecondTab _SecondTab = SecondTab();
  Widget _pageChooser(int page) {
    switch(page) {
      case 0:
        return _FirstTab;
        break;
      case 1:
        print("1");
        return _SecondTab;
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: pageIndex,
        items: <Widget>[
          Icon(Icons.add, size: 30,),
          Icon(Icons.book, size: 30,),
          Icon(Icons.home, size: 30,),
          Icon(Icons.shopping_cart, size: 30,),
          Icon(Icons.settings, size: 30,),
        ],
        color: Colors.indigo,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.easeIn,
        height:50,
        onTap: (int tappedIndex) {
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });

        },
      ),
      body: getTabBarView(<Widget>[
        WillPopScope(
            onWillPop: _onBackPressed,
            child: Container(
              color: Colors.blue,
              child: _showPage
            )
        ),
        FirstTab(),
        FirstTab()
      ]),
    );
  }
  }
