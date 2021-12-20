import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({Key? key}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.white60,
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/explore_inactive.png',
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/map_active.png',
              ),
            ),
            Expanded(
              child: Container(
                width: 40,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/transactions_inactive.png',
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/wallet_inactive.png',
              ),
            )
          ],
        ),
      ),
      notchMargin: 14.0,
      // notchedShape: CircularNotchedRectangle(),
    );
  }
}
