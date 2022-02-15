import 'package:intl/intl.dart';
import 'package:squick/models/parking.dart';

class OpenHoursHelper {
  static String mapDayToString(int day) {
    switch (day) {
      case 7:
        return "SUNDAY";
      case 1:
        return "MONDAY";
      case 2:
        return "TUESDAY";
      case 3:
        return "WEDNESDAY";
      case 4:
        return "THURSDAY";
      case 5:
        return "FRIDAY";
      case 6:
        return "SATURDAY";
      default:
        return "";
    }
  }

  static bool isOpen(Parking parking) {
    bool flag = false;
    var parser = DateFormat('hh:mm:ss');

    parking.workingHours.forEach((element) {
      var timeFrom = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        parser.parse(element.timeFrom).hour,
        parser.parse(element.timeFrom).minute,
        parser.parse(element.timeFrom).second,
      );

      var timeTo = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          parser.parse(element.timeTo).hour,
          parser.parse(element.timeTo).minute,
          parser.parse(element.timeTo).second);



      var presentDay = mapDayToString(DateTime.now().weekday);

      if (presentDay == element.dayOfWeek &&
          DateTime.now().isBefore(timeTo) &&
          DateTime.now().isAfter(timeFrom)) {
        flag = true;
      }
    });
    return flag;
  }
}
