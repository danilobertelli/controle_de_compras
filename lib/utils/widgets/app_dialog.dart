import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title, description, buttonTextConfirm, buttonTextNegative;
  final Image image;

  CustomAlertDialog({
    @required this.title,
    @required this.description,
    @required this.buttonTextConfirm,
    @required this.buttonTextNegative,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        _cardContent(context),
        _icon(context),
      ],
    );
  }

  _icon(context) {
    return Positioned(
      left: 16.0,
      right: 16.0,
      child: CircleAvatar(
        child: CircleAvatar(
          child: Image.asset("assets/images/success.png", fit: BoxFit.fitHeight, height: 50.0,),
          backgroundColor: Theme.of(context).accentColor,
          radius: 40.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        radius: 40.0,
      ),
    );
  }

  _cardContent(context) {
    return Container(
      padding: EdgeInsets.only(
        top: 40.0 + 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      margin: EdgeInsets.only(top: 40.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // To close the dialog
                  },
                  child: Text(
                    buttonTextNegative,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // To close the dialog
                  },
                  child: Text(
                    buttonTextConfirm,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}