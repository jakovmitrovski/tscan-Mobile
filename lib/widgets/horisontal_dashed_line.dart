import 'package:flutter/material.dart';

class HorizontalDashedLine extends StatelessWidget {

  Color color;
  int length;

  HorizontalDashedLine({required this.color, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          length ~/ 10,
              (index) => Expanded(
            child: Container(
              color: index % 2 == 0
                  ? Colors.transparent
                  : color,
              height: 1,
            ),
          )),
    );
  }
}
