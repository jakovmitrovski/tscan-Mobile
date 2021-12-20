import 'package:flutter/material.dart';
import 'package:squick/modules/scan/screen/scan_screen.dart';
import 'package:squick/widgets/menu.dart';

class MapScreen extends StatefulWidget {
  static const String id = "/map";

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text('hi'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 60.0,
          width: 60.0,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {},
              child: Image.asset('assets/images/scan_ticket.png'),
            ),
          ),
        ),
        bottomNavigationBar: MenuWidget(),
      ),
    );
  }
}
