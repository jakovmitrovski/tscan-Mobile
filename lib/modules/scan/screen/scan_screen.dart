import 'package:flutter/material.dart';

class ScanScreen extends StatefulWidget {
  static const String id = "/scan";

  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
          'Scan screen'),
    );
  }
}
