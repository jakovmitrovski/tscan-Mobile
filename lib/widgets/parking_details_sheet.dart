import 'package:flutter/material.dart';

class ParkingDetailsSheet extends StatefulWidget {
  const ParkingDetailsSheet({Key? key}) : super(key: key);

  @override
  _ParkingDetailsSheetState createState() => _ParkingDetailsSheetState();
}

class _ParkingDetailsSheetState extends State<ParkingDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('DETAILS!'),
      ),
    );
  }
}
