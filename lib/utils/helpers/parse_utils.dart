import 'package:squick/models/parking.dart';
import 'package:squick/models/ticket_info.dart';
import 'package:squick/models/working_hours.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

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

    DateTime entered = DateFormat("dd.MM.yyyy HH:mm:ss").parse(ticketInfo["entered"]);
    DateTime exited = DateFormat("dd.MM.yyyy HH:mm:ss").parse(ticketInfo["exited"]);

    return TicketInfo(ticketValue: ticketValue, parking: parking, entered: entered, exited: exited, price: ticketInfo["price"]);
  }

  static String parseDateToStr(DateTime d) {
    return sprintf("%02i.%02i.%4i", [d.day, d.month, d.year]);
  }

  static String parseTimeToStr(DateTime d) {
    return sprintf("%02i:%02i", [d.hour, d.minute]);
  }

  static int getDifferenceInSeconds (DateTime d1, DateTime d2) {
    return d2.difference(d1).inSeconds;
  }

  static String parseDifferenceToString (DateTime d1, DateTime d2) {

    int difference = getDifferenceInSeconds(d1, d2);

    int hour = difference ~/ 3600;
    int sec = difference % 60;
    int min = (difference ~/ 60) % 60 ;

    if (hour == 0 && min == 0) {
      return sprintf("%2iсекунди", [sec]);
    }else if (hour == 0) {
      return sprintf("%2iминути", [min]);
    }else {
      return sprintf("%iчаса %02iмин", [hour, min]);
    }
  }
}