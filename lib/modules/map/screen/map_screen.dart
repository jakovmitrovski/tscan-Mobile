import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/widgets/squick_button.dart';

class MapScreen extends StatefulWidget {
  static const String id = "/map";

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          children: [
            Center(child: Text('Map Screen')),
            SquickButton(buttonText: 'buttonText', onTap: () {
              print('hi');
            },)
          ]
      ),
    );
  }
}
