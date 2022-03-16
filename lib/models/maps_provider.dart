import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/utils/helpers/distance.dart';
import 'package:squick/utils/helpers/location.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/utils/helpers/parse_utils.dart';

class MapsProvider extends ChangeNotifier {
  List<Parking> _parkings = [];
  Position? _currentPosition;

  Future<Position?> getCurrentPosition() async {
    if (_currentPosition == null) {
      try {
        await updateCurrentPosition();
      }catch(e) {
        rethrow;
      }
    }

    return _currentPosition;
  }

  void updateParkings(List<Parking> parkings) {
    _parkings = parkings;
    notifyListeners();
  }

  Future<void> updateCurrentPosition() async {
    try {
      _currentPosition = await LocationHelper().getCurrentLocation();
    }catch(e) {
      rethrow;
    }
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
        _parkings[i].sortingDistance = await DistanceHelper().getDistance(
            currentLocation.latitude,
            currentLocation.longitude,
            _parkings[i].latitude,
            _parkings[i].longitude);
        _parkings[i].distance = DistanceHelper().getDistAsString(_parkings[i].sortingDistance);
      }
    }

    _parkings.sort((a, b) {
      double p1 = a.sortingDistance;
      double p2 = b.sortingDistance;
      if (p1 > p2) {
        return 1;
      } else if (p1 < p2) {
        return -1;
      } else {
        return 0;
      }
    });

    return _parkings;
  }

  List<Parking> getLoadedParkings() {
    return _parkings;
  }

  int get count {
    return _parkings.length;
  }
}
