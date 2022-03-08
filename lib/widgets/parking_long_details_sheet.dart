import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/models/working_hours.dart';
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'available_spaces_icon.dart';

class ParkingLongDetailsSheet extends StatelessWidget {
  Parking parking;
  Position position;

  ParkingLongDetailsSheet({required this.parking, required this.position});


  String resolveWorkingHours() {
    String day = OpenHoursHelper.mapDayToString(DateTime.now().weekday);

    for (WorkingHours hours in parking.workingHours) {
      if (hours.dayOfWeek == day) {
        return hours.timeFrom.substring(0, 5) + " - " + hours.timeTo.substring(0, 5) + " (Денес)";
      }
    }
    return "Не работи (Денес)";
  }

  List<Widget> _getWorkingHoursList() {
    List<Widget> ret = [];

    for (WorkingHours hours in parking.workingHours) {
      String day = OpenHoursHelper.mapDayToMacedonianDay(hours.dayOfWeek);
      String working = hours.timeFrom.substring(0, 5) + " - " + hours.timeTo.substring(0, 5);

      ret.add(
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 const Padding(
                   padding: EdgeInsets.only(right: 2.0),
                   child: Icon(Icons.timer, color: colorBlueDark),
                 ),
                 Text(day + ": ", style: font16Medium.copyWith(color: colorBlueDark),),
               ],
              ),
              Text(working, style: font16Regular.copyWith(color: colorBlueDark),)
            ],
          ),
        )
      );
    }

    if (ret.isEmpty) {
      ret.add(const Text("Нема податоци"));
    }

    return ret;
  }

  Future<void> _showDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),
        title: Center(
            child: Text('Работно Време',
              style: font18Bold.copyWith(color: colorBlueDark),
            ),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: _getWorkingHoursList()
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(21.0),
            child: SquickButton(
              buttonText: "Затвори",
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {

    bool isOpen = OpenHoursHelper.isOpen(parking);

    return Container(
        color: const Color(0xff757575),
        child: Container(
          padding: kModalSheetsPadding,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: 60,
                  height: 2,
                  color: colorGrayDark,
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(parking.imageUrlLarge),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parking.name,
                      style: font20Bold.copyWith(color: colorBlueDark),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      parking.locationAddress,
                      style:
                          font12Regular.copyWith(color: colorBlueDarkLightest),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: isOpen ? 4 : 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Icon(IconlyBold.ticket,
                                    color: colorOrange, size: 20),
                              ),
                            ),
                            Text('${parking.hourlyPrice}ден/час',
                                style: font14Regular.copyWith(
                                    color: colorBlueDark)),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        if (isOpen) Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (parking.numberOfFreeSpaces == 0)
                                      ? colorRed
                                      : colorGreen,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: AvailableSpacesIcon(
                                  isOpen: isOpen,
                                  numberOfFreeSpaces:
                                      parking.numberOfFreeSpaces,
                                  size: 20,
                                ),
                              ),
                            ),
                            Text(
                                parking.numberOfFreeSpaces == 0
                                    ? 'Нема слободни места'
                                    : (parking.numberOfFreeSpaces % 10 == 1 &&
                                            parking.numberOfFreeSpaces != 11)
                                        ? '${parking.numberOfFreeSpaces} слободно место'
                                        : '${parking.numberOfFreeSpaces} слободни места',
                                style: font14Medium.copyWith(
                                    color: (parking.numberOfFreeSpaces == 0)
                                        ? colorRed
                                        : colorGreen)),
                          ],
                        ),
                        if (isOpen) const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: colorBlueDark,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Icon(
                                  Icons.workspaces_rounded,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Вкупно ${parking.capacity} паркинг места',
                              style:
                                  font14Regular.copyWith(color: colorBlueDark),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorBlueLight,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Icon(
                                  IconlyLight.discovery,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            Text('${parking.distance} оддалеченост',
                                style: font14Regular.copyWith(
                                    color: colorBlueDark)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Работно време',
                            style: font14Regular.copyWith(
                                color: colorBlueDarkLightest),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showDialog(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(resolveWorkingHours(),
                                    style: font14Bold.copyWith(color: colorBlueDark)),
                                const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: colorBlueDarkLightest,
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: OpenHoursHelper.isOpen(parking) ? colorGreen : colorRed,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                              child: Center(
                                child: Text(
                                  OpenHoursHelper.isOpen(parking) ? "отворен" : "затворен",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ценовник',
                      style:
                          font14Regular.copyWith(color: colorBlueDarkLightest),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Час',
                          style: font16Bold.copyWith(color: colorBlueDark),
                        ),
                        Text(
                          (parking.hourlyPrice % 10 == 1 &&
                                  parking.hourlyPrice != 11)
                              ? '${parking.hourlyPrice} денар'
                              : '${parking.hourlyPrice} денари',
                          style: font16Medium.copyWith(color: colorBlueDark),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Месечно',
                          style: font16Bold.copyWith(color: colorBlueDark),
                        ),
                        Text(
                          (parking.monthlyPrice % 10 == 1 &&
                                  parking.monthlyPrice != 11)
                              ? '${parking.monthlyPrice} денар'
                              : '${parking.monthlyPrice} денари',
                          style: font16Medium.copyWith(color: colorBlueDark),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Годишно',
                          style: font16Bold.copyWith(color: colorBlueDark),
                        ),
                        Text(
                          (parking.yearlyPrice % 10 == 1 &&
                                  parking.yearlyPrice != 11)
                              ? '${parking.yearlyPrice} денар'
                              : '${parking.yearlyPrice} денари',
                          style: font16Medium.copyWith(color: colorBlueDark),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: SquickButton(
                  buttonText: 'Насоки',
                  backgroundColor: colorBlueDark,
                  textColor: Colors.white,
                  onTap: () async {
                    final url =
                        'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${parking.latitude},${parking.longitude}&travelmode=driving&dir_action=navigate';
                    await launch(url);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
