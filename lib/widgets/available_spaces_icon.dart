import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';

class AvailableSpacesIcon extends StatelessWidget {
  final int numberOfFreeSpaces;
  final int size;

  const AvailableSpacesIcon({Key? key, required this.numberOfFreeSpaces, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Icon(numberOfFreeSpaces == 0 ? IconlyBold.danger : IconlyBold.danger,
          color: numberOfFreeSpaces == 0 ? colorRed : colorGreen, size: size.toDouble()),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: numberOfFreeSpaces == 0
              ? Text(
                  'X',
                  style: size==15 ? font12Medium.copyWith(color: Colors.white) : font14Medium.copyWith(color: Colors.white),
                )
              : Text(
                  'P',
                  style: font12Medium.copyWith(color: Colors.white),
                ),
        ),
      ),
    ]);
  }
}
