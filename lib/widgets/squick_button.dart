import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';

class SquickButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String buttonText;
  final VoidCallback? onTap;
  bool disabled = false;

  SquickButton(
      {this.backgroundColor = colorBlueDark,
      this.textColor = Colors.white,
      required this.buttonText,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    disabled = (onTap == null);
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(backgroundColor),
          backgroundColor: disabled ? MaterialStateProperty.all(colorGrayDark) : MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: font16Bold.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
