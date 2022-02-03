import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DistanceHelper {
  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> _getDistance(double lat1, double lon1, double lat2, double lon2) async {


    PolylinePoints polylinePoints = PolylinePoints();

    String googleAPiKey = "AIzaSyAxlN9Hz4FSr2lGxQ8Zks_Kh4-xae_4M8Y";

    LatLng startLocation = LatLng(lat1, lon1);
    LatLng endLocation = LatLng(lat2, lon2);

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }

    return totalDistance;
  }

  Future<String> getDistAsString(double lat1, double lon1, double lat2, double lon2) async {
    double dist = await _getDistance(lat1, lon1, lat2, lon2);

    if (dist < 1) {
      return '${(dist * 1000) ~/ 1}м';
    }else {
      return '${dist.toStringAsFixed(1)}км';
    }
  }
}