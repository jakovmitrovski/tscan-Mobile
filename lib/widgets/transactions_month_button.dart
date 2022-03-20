import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';

class TransactionsMonthButton extends StatelessWidget {
  Color backgroundColor;
  Color textColor;
  bool selected;
  double? width;

  final Color borderColor = colorBlueDark;
  final String buttonText;
  final VoidCallback? onTap;

  TransactionsMonthButton({
    this.backgroundColor = Colors.white,
    this.textColor = colorBlueDark,
    required this.buttonText,
    this.selected = false,
    this.onTap,
    this.width = 100,});

  @override
  Widget build(BuildContext context) {
    backgroundColor = (selected ? colorBlueDark : Colors.white);
    textColor = (selected ? Colors.white : colorBlueDark);

    return SizedBox(
      width: width,
      height: 48,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(backgroundColor),
          backgroundColor:MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor,
                width: 1,
                style: BorderStyle.solid
              ),
              borderRadius: BorderRadius.circular(10.0)
          )),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: font16Regular.copyWith(
            color: textColor
          ),
        ),
      ),
    );
  }
}
