import 'package:flutter/material.dart';
import 'package:squick/modules/map/screen/map_screen.dart';

class ExploreScreen extends StatefulWidget {
  static const String id = "/explore";

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  Widget? screen;
  String? selected;

  @override
  void initState() {
    screen = MapScreen();
    selected = "map";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Explore Screen')),
    );
  }
}
