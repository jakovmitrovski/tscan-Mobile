import 'package:flutter/material.dart';
import 'package:squick/models/ticket_info.dart';

class TicketInformation extends StatefulWidget {
  static const String id = "/ticket_information";

  @override
  _TicketInformationState createState() => _TicketInformationState();
}

class _TicketInformationState extends State<TicketInformation> {

  @override
  Widget build(BuildContext context) {

    final ticket = ModalRoute.of(context)!.settings.arguments as TicketInfo;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("TICKET INFORMATION SCREEN"),
          Text(ticket.ticketValue),
          Text(ticket.parking.id.toString()),
          Text(ticket.entered),
          Text(ticket.exited),
        ],
      )
    );
  }
}
