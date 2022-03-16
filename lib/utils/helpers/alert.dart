import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:squick/constants/app_constants.dart';


class AlertHelper {

  static void showAlert(BuildContext context, String title,
      String description, ) {
    Alert(
        context: context,
        type: AlertType.error,
        title: title,
        desc: description,
        style: AlertStyle(
            titleStyle: font16Medium.copyWith(color: colorBlueDark),
            descStyle: font14Regular.copyWith(color: colorBlueDarkLight)),
        buttons: [
          DialogButton(
            child: const Text(
              "Назад",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.grey.shade400,
          ),
        ]).show();
  }
}