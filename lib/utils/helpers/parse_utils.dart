import 'package:squick/models/parking.dart';
import 'package:squick/models/ticket_info.dart';
import 'package:squick/models/working_hours.dart';

class ParseUtils {
  static parseTicketInfo(dynamic ticketInfo, String ticketValue) {
    List<WorkingHours> parkingWorkingHours = [];

    for(dynamic workingHour in ticketInfo["parking"]["workingHours"]) {
      WorkingHours pWorkingHour = WorkingHours(id: workingHour["id"], timeFrom: workingHour["timeFrom"], timeTo: workingHour["timeTo"], dayOfWeek: workingHour["dayOfWeek"]);
      parkingWorkingHours.add(pWorkingHour);
    }

    Parking parking = Parking(id: ticketInfo["parking"]["id"],
        name: ticketInfo["parking"]["name"],
        locationAddress: ticketInfo["parking"]["locationAddress"],
        longitude: ticketInfo["parking"]["longitude"],
        latitude: ticketInfo["parking"]["latitude"],
        hourlyPrice: ticketInfo["parking"]["hourlyPrice"],
        monthlyPrice: ticketInfo["parking"]["monthlyPrice"],
        yearlyPrice: ticketInfo["parking"]["yearlyPrice"],
        capacity: ticketInfo["parking"]["capacity"],
        numberOfFreeSpaces: ticketInfo["parking"]["numberOfFreeSpaces"],
        imageUrl: ticketInfo["parking"]["imageUrl"],
        workingHours: parkingWorkingHours);

    //TODO: FIX THIS WHEN BACKEND DECIDES TO WORK AS IT SHOULD
    // DateTime entered = DateTime.parse(ticketInfo["entered"]);
    // DateTime exited = DateTime.parse(ticketInfo["exited"]);

    String entered = ticketInfo["entered"];
    String exited = ticketInfo["exited"];

    return TicketInfo(ticketValue: ticketValue, parking: parking, entered: entered, exited: exited, price: ticketInfo["price"]);
  }
}