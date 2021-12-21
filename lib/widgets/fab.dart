import 'package:flutter/material.dart';

class FloatingMenuButton extends StatelessWidget {
  const FloatingMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 67.5,
      width: 67.5,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {},
          child: Image.asset('assets/images/scan_ticket.png'),
        ),
      ),
    );
  }
}
