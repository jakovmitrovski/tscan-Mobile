import 'package:squick/models/parking.dart';

class TicketInfo {
  String ticketValue;
  Parking parking;
  DateTime entered;
  DateTime exited;
  int price;

  TicketInfo({
    required this.ticketValue,
    required this.parking,
    required this.entered,
    required this.exited,
    required this.price});
}