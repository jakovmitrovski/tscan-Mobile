import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  static const String id = "/map";

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  int count = 0;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(child: Text('Map Screen')),
    );
  }
}
