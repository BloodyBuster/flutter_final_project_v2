import 'package:flutter/material.dart';
import 'package:flutter_app_final_v2/pages/tabs/first_tab.dart';
import 'package:flutter/gestures.dart';
class POTD extends StatelessWidget{
  Widget build(BuildContext context) {
    print(POAD_url);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Hero(
                    tag: 'dash',
                    child: Image.network((POAD_url
                    ))
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 35,
                    ),
                  )
                )
              ],
            ),
            Container(
              color: Color.fromRGBO(27, 27, 54,1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(POAD_title),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}