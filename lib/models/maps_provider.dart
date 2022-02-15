import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/utils/helpers/distance.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/utils/helpers/parse_utils.dart';

class MapsProvider extends ChangeNotifier {
  List<Parking> _parkings = [];
  Position? _currentPosition;

  Position? getCurrentPosition() {
    return _currentPosition;
  }

  void updateParkings(List<Parking> parkings) {
    _parkings = parkings;
    notifyListeners();
  }

  void updateCurrentPosition(Position position) {
    _currentPosition = position;
    notifyListeners();
  }

  Future<List<Parking>> getParkingsFromApi(BuildContext context, double price,
      bool openNow, bool freeSpaces, Position currentLocation,
      {String? keyword}) async {
    late Uri uri;
    if (keyword != null) {
      uri = Uri.parse(
          '$baseEndpoint/parkings/explore?priceTo=${price == 250 ? 10000 : price ~/ 1}&openNow=$openNow&freeSpaces=$freeSpaces&keyword=$keyword');
    } else {
      uri = Uri.parse(
          '$baseEndpoint/parkings/explore?priceTo=${price == 250 ? 10000 : price ~/ 1}&openNow=$openNow&freeSpaces=$freeSpaces');
    }
    final parkingsData = await NetworkHelper(uri).getParkings(context);
    if (parkingsData != null) {
      _parkings = await ParseUtils.parseParkingData(parkingsData);
      for (int i = 0; i < _parkings.length; i++) {
        _parkings[i].distance = await DistanceHelper().getDistAsString(
            currentLocation.latitude,
            currentLocation.longitude,
            _parkings[i].latitude,
            _parkings[i].longitude);
      }
    }
    return _parkings;
  }

  List<Parking> getLoadedParkings() {
    return _parkings;
  }

  int get count {
    return _parkings.length;
  }
}
