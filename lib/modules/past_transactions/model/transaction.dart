import 'package:squick/modules/ticket_information/model/payment_status.dart';
import 'package:squick/modules/ticket_information/model/ticket_info.dart';

class SingleTransaction {
  int id;
  String userId;
  TicketInfo ticket;
  int price;
  PaymentStatus paymentStatus;

  SingleTransaction({required this.id,
      required this.userId,
      required this.ticket,
      required this.price,
      required this.paymentStatus});
}