import 'package:flutter/material.dart';


class FilterDataModel extends ChangeNotifier {
  Map<String, dynamic> _items = {
    "price": 250.0,
    "openNow": false,
    "freeSpaces": false,
    "keyword": "%",
  };

  dynamic getValue(String key) {
    return _items[key];
  }

  void resetValues() {
    _items["price"] = 250.0;
    _items["openNow"] = false;
    _items["freeSpaces"] = false;
    notifyListeners();
  }

  void changeAllValues(double price, bool openNow, bool freeSpaces) {
    _items['price'] = price;
    _items['openNow'] = openNow;
    _items['freeSpaces'] = freeSpaces;
    notifyListeners();
  }

  void change(String key, dynamic value) {
    _items[key] = value;
    notifyListeners();
  }
}