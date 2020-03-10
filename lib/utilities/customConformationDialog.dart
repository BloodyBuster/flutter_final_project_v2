import 'package:flutter/material.dart';
class XConsts {
  XConsts._();

  static const double padding = 8.0;
  static const double avatarRadius = 44.0;
}
class CustomConformationDialog extends StatelessWidget{
  final String title, description, buttonTrueText, buttonFalseText;
  Icon _dialogIcon;
  Function function_1;
  Function function_2;
  Widget _action;
  final Image image;

  CustomConformationDialog({
    @required this.title,
    @required this.description,
    @required this.buttonTrueText,
    @required this.buttonFalseText,
    Widget action,
    Function function1,
    Icon dialogIcon,
    this.image,
  }) {
    function_1 = function1;
    _action = action;
    _dialogIcon = dialogIcon;
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: XConsts.avatarRadius + XConsts.padding,
            bottom: XConsts.padding,
            left: XConsts.padding,
            right: XConsts.padding,
          ),
          margin: EdgeInsets.only(top: XConsts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(XConsts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[

              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 0.0),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 26.0),
              _action,
            ],
          ),
        ),

        Positioned(
          left: XConsts.padding,
          right: XConsts.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: XConsts.avatarRadius,
            child: Center(
              child: Container(
                child: _dialogIcon,
                padding: EdgeInsets.only(left: 0),
              ),
            )
          ),
        ),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XConsts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
