import 'package:squick/models/parking.dart';
import 'package:squick/modules/ticket_information/model/payment_status.dart';
import 'package:squick/modules/ticket_information/model/ticket_info.dart';
import 'package:squick/models/working_hours.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:squick/modules/past_transactions/model/transaction.dart';

class ParseUtils {
  static parseParkingData(dynamic parkingData) {
    List<Parking> parkings = [];

    for (dynamic parking in parkingData) {
      List<WorkingHours> parkingWorkingHours = [];
      for (dynamic workingHour in parking["workingHours"]) {
        WorkingHours pWorkingHour = WorkingHours(
            id: workingHour["id"],
            timeFrom: workingHour["timeFrom"],
            timeTo: workingHour["timeTo"],
            dayOfWeek: workingHour["dayOfWeek"]);
        parkingWorkingHours.add(pWorkingHour);
      }

      parkings.add(Parking(
          id: parking["id"],
          name: parking["name"],
          locationAddress: parking["locationAddress"],
          longitude: parking["longitude"],
          latitude: parking["latitude"],
          hourlyPrice: parking["hourlyPrice"],
          monthlyPrice: parking["monthlyPrice"],
          yearlyPrice: parking["yearlyPrice"],
          capacity: parking["capacity"],
          numberOfFreeSpaces: parking["numberOfFreeSpaces"],
          imageUrlSmall: parking["imageUrlSmall"],
          imageUrlMedium: parking["imageUrlMedium"],
          imageUrlLarge: parking["imageUrlLarge"],
          workingHours: parkingWorkingHours));
    }

    return parkings;
  }

  static parseTicketInfo(dynamic ticketInfo, String ticketValue, bool needEnter) {
    List<WorkingHours> parkingWorkingHours = [];

    for (dynamic workingHour in ticketInfo["parking"]["workingHours"]) {
      WorkingHours pWorkingHour = WorkingHours(
          id: workingHour["id"],
          timeFrom: workingHour["timeFrom"],
          timeTo: workingHour["timeTo"],
          dayOfWeek: workingHour["dayOfWeek"]);
      parkingWorkingHours.add(pWorkingHour);
    }

    Parking parking = Parking(
        id: ticketInfo["parking"]["id"],
        name: ticketInfo["parking"]["name"],
        locationAddress: ticketInfo["parking"]["locationAddress"],
        longitude: ticketInfo["parking"]["longitude"],
        latitude: ticketInfo["parking"]["latitude"],
        hourlyPrice: ticketInfo["parking"]["hourlyPrice"],
        monthlyPrice: ticketInfo["parking"]["monthlyPrice"],
        yearlyPrice: ticketInfo["parking"]["yearlyPrice"],
        capacity: ticketInfo["parking"]["capacity"],
        numberOfFreeSpaces: ticketInfo["parking"]["numberOfFreeSpaces"],
        imageUrlSmall: ticketInfo["parking"]["imageUrlSmall"],
        imageUrlMedium: ticketInfo["parking"]["imageUrlMedium"],
        imageUrlLarge: ticketInfo["parking"]["imageUrlLarge"],
        workingHours: parkingWorkingHours);

    DateTime entered, exited;

    if (needEnter) {
      entered = DateFormat("dd.MM.yyyy HH:mm:ss").parse(ticketInfo["entered"]);
      exited = DateFormat("dd.MM.yyyy HH:mm:ss").parse(ticketInfo["exited"]);
    } else {
      entered = DateTime.now();
      exited = DateTime.now();
    }

    return TicketInfo(
        id: ticketInfo["id"],
        ticketValue: ticketValue,
        parking: parking,
        entered: entered,
        exited: exited,
        price: ticketInfo["price"]);
  }

  static String parseDateToStr(DateTime d) {
    return sprintf("%02i.%02i.%4i", [d.day, d.month, d.year]);
  }

  static String parseTimeToStr(DateTime d) {
    return sprintf("%02i:%02i", [d.hour, d.minute]);
  }

  static int getDifferenceInSeconds(DateTime d1, DateTime d2) {
    return d2.difference(d1).inSeconds;
  }

  static String parseDifferenceToString(DateTime d1, DateTime d2) {
    int difference = getDifferenceInSeconds(d1, d2);

    int hour = difference ~/ 3600;
    int sec = difference % 60;
    int min = (difference ~/ 60) % 60;

    if (hour == 0 && min == 0) {
      return sprintf("%2iсекунди", [sec]);
    } else if (hour == 0) {
      return sprintf("%2iминути", [min]);
    } else {
      return sprintf("%iчаса %02iмин", [hour, min]);
    }
  }

  static List<SingleTransaction> parseTransactionData(dynamic transactionsData) {
    List<SingleTransaction> transactions = [];

    for (dynamic transaction in transactionsData['content']) {
      SingleTransaction newTransaction = SingleTransaction(
        id: transaction['id'],
        userId: transaction['userId'],
        ticket: ParseUtils.parseTicketInfo(transaction['ticket'], transaction['ticket']['value'].toString(), false),
        price: transaction['price'],
        paymentStatus: transaction['paymentStatus'] == 'SUCCESSFULL' ? PaymentStatus.SUCCESSFUL : PaymentStatus.UNSUCCESSFUL
      );

      transactions.add(newTransaction);
    }

    return transactions;
  }
}
