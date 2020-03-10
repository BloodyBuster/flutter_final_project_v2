import 'package:flutter/material.dart';
import 'package:flutter_app_final_v2/utilities/customDialogBox.dart';
import 'package:flare_flutter/flare_actor.dart';
class CustomLoadingScreen extends StatelessWidget{
  final String title, description, buttonTrueText, buttonFalseText;
  final Image image;

  CustomLoadingScreen({
    @required this.title,
    @required this.description,
    @required this.buttonTrueText,
    @required this.buttonFalseText,
    Widget action,
    Function function1,
    Icon dialogIcon,
    this.image,
  }) {

  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Center(
              child: Container(
                width: 250,
                height: 150,
                child: FlareActor("assets/flare/loading.flr", alignment:Alignment.topCenter, fit:BoxFit.cover, animation:'Untitled'),
              ),
            )

          ],
        ),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
