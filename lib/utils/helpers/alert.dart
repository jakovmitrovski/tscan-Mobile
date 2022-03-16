import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:squick/constants/app_constants.dart';


class AlertHelper {

  static bool _isDialogShowing = false;

  static void showAlert(BuildContext context, {required String title,
      required String description, required String buttonText, required VoidCallback onTap}) {

      if (buttonText == 'Затвори ја TScan') {
        if (_isDialogShowing) {
          return;
        }
        _isDialogShowing = true;
      }

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
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: onTap,
            color: colorBlueDark,
          ),
        ]).show();
  }
}