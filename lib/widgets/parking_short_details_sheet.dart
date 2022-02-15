import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/available_spaces_icon.dart';
import 'package:squick/widgets/parking_long_details_sheet.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdi/mdi.dart';

class ParkingShortDetailsSheet extends StatelessWidget {
  Parking parking;
  Position position;
  late double height;

  ParkingShortDetailsSheet({required this.parking, required this.position});

  showModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
            height: 0.85 * height,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child:
                ParkingLongDetailsSheet(parking: parking, position: position)));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xFFf5f5f5),
      child: Listener(
        onPointerMove: (moveEvent) {
          if (moveEvent.delta.dy < -10) {
            showModalSheet(context);
          }
        },
        child: GestureDetector(
          onTap: () {
            showModalSheet(context);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0))),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                width: 60,
                height: 2,
                color: colorGrayDark,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                parking.name,
                                style:
                                    font18Bold.copyWith(color: colorBlueDark),
                              ),
                              Text('${parking.hourlyPrice} ден.',
                                  style:
                                      font18Bold.copyWith(color: colorBlueDark))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                parking.locationAddress,
                                style: font12Regular.copyWith(
                                    color: colorGrayDark),
                              ),
                              Text('/ час',
                                  style: font12Light.copyWith(
                                      color: colorBlueDark))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: parking.numberOfFreeSpaces == 0
                                            ? colorRed
                                            : colorGreen,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: AvailableSpacesIcon(
                                        numberOfFreeSpaces:
                                            parking.numberOfFreeSpaces,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Text(
                                      parking.numberOfFreeSpaces == 0
                                          ? 'Нема слободни места'
                                          : (parking.numberOfFreeSpaces % 10 ==
                                                      1 &&
                                                  parking.numberOfFreeSpaces !=
                                                      11)
                                              ? '${parking.numberOfFreeSpaces} слободно местo'
                                              : '${parking.numberOfFreeSpaces} слободни места',
                                      style: font12Regular.copyWith(
                                          color: parking.numberOfFreeSpaces == 0
                                              ? colorRed
                                              : colorGreen)),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorBlueLight,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: const Icon(
                                        IconlyLight.discovery,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  Text('${parking.distance} оддалеченост',
                                      style: font12Regular.copyWith(
                                          color: colorBlueDark)),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: colorBlueDarkLight,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Icon(
                                    IconlyLight.time_circle,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                  OpenHoursHelper.isOpen(parking)
                                      ? 'Моментално отворед'
                                      : 'Моментално затворен',
                                  style: font10Regular.copyWith(
                                      color: OpenHoursHelper.isOpen(parking)
                                          ? colorGreen
                                          : colorRed)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
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
            ]),
          ),
        ),
      ),
    );
  }
}
