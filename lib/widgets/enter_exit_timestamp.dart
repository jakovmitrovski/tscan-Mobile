import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';

class EnterExitTimestamp extends StatelessWidget {

  final texts;

  EnterExitTimestamp({this.texts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texts[0],
          style: font10Light.copyWith(
              color: colorGrayDark
          ),
        ),
        Row(
          children: [
            Text(
              texts[1],
              style: font12Bold.copyWith(
                  color: colorBlueDarkLight
              ),
            ),
            const SizedBox(width: 5.0,),
            Text(
              texts[2],
              style: font10Medium.copyWith(
                  color: colorGrayDark
              ),
            )
          ],
        )
      ],
    );
  }
}
