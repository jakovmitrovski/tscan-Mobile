import 'package:squick/models/working_hours.dart';

class Parking {

  int id;
  String name;
  String locationAddress;
  double longitude;
  double latitude;
  int hourlyPrice;
  int monthlyPrice;
  int yearlyPrice;
  int capacity;
  int numberOfFreeSpaces;
  String imageUrl;
  List<WorkingHours> workingHours;
  String distance = "";

  Parking({
      required this.id,
      required this.name,
      required this.locationAddress,
      required this.longitude,
      required this.latitude,
      required this.hourlyPrice,
      required this.monthlyPrice,
      required this.yearlyPrice,
      required this.capacity,
      required this.numberOfFreeSpaces,
      required this.imageUrl,
      required this.workingHours}
      );
}