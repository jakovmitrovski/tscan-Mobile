import 'package:flutter/material.dart';


class SelectedParkingProvider extends ChangeNotifier {
  int selectedParking = -1;

  int get selected {
    return selectedParking;
  }

  void updateValue(int value) {
    selectedParking = value;
    notifyListeners();
  }
}