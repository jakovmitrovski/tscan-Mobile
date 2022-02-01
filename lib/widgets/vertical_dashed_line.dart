import 'package:flutter/material.dart';

class VerticalDashedLine extends StatelessWidget {

  Color color;
  int length;

  VerticalDashedLine({required this.color, required this.length});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          length ~/ 10,
              (index) => Expanded(
            child: Container(
              color: index % 2 == 0
                  ? Colors.transparent
                  : color,
              width: 1,
            ),
          )
      ),
    );
  }
}
