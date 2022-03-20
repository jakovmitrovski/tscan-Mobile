import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';

class AvailableSpacesIcon extends StatelessWidget {
  final int numberOfFreeSpaces;
  final int size;
  final bool isOpen;

  const AvailableSpacesIcon({Key? key, required this.numberOfFreeSpaces, required this.size, required this.isOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Icon(IconlyBold.danger,
          color: (numberOfFreeSpaces == 0 || !isOpen) ? colorRed : colorGreen, size: size.toDouble()),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: (numberOfFreeSpaces == 0 || !isOpen)
              ? Text(
                  'X',
                  style: size==15 ? font12Medium.copyWith(fontSize: 12.0, color: Colors.white) : font14Medium.copyWith(fontSize: 14.0, color: Colors.white),
                )
              : Text(
                  'P',
                  style: font12Medium.copyWith(fontSize: 12.0, color: Colors.white),
                ),
        ),
      ),
    ]);
  }
}
