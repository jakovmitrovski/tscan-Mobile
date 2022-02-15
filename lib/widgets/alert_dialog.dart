import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String alertTitle;
  final String alertContent;
  List<Widget> actions = [];

  CustomAlertDialog(
      {Key? key,
      required this.alertTitle,
      required this.alertContent,
      required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        alertTitle,
        textAlign: TextAlign.center,
      ),
      content: Text(
        alertContent,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: font22Medium.copyWith(
        color: Colors.black54,
      ),
      contentTextStyle: font20Regular.copyWith(
        color: Colors.black26,
      ),
      actions: [
        Row(
          mainAxisAlignment: actions.length == 1
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
          children: actions,
        ),
      ],
    );
  }
}
