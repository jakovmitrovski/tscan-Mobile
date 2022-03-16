import 'package:geolocator/geolocator.dart';
import 'package:squick/models/exceptions/location_services_permission_denied_exception.dart';
import 'package:squick/models/exceptions/location_services_off_exception.dart';
import 'package:squick/models/exceptions/location_services_permission_denied_forever_exception.dart';


class LocationHelper {

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServicesOffException();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationServicesPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServicesPermissionDeniedForeverOffException();
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

}