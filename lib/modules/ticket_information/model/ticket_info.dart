import 'package:squick/models/parking.dart';

class TicketInfo {
  int id;
  String ticketValue;
  Parking parking;
  DateTime entered;
  DateTime exited;
  int price;

  TicketInfo({
    required this.id,
    required this.ticketValue,
    required this.parking,
    required this.entered,
    required this.exited,
    required this.price});
}