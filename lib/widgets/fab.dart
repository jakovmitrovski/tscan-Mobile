import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FloatingMenuButton extends StatelessWidget {

  final VoidCallback onPressed;
  FloatingMenuButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 67.5,
      width: 67.5,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 0,
          onPressed: onPressed,
          child: SvgPicture.asset('assets/images/scan_ticket.svg'),
        ),
      ),
    );
  }
}
