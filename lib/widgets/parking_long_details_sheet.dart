import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'available_spaces_icon.dart';

class ParkingLongDetailsSheet extends StatelessWidget {
  Parking parking;
  Position position;

  ParkingLongDetailsSheet({required this.parking, required this.position});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff757575),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Container(
                    width: 60,
                    height: 2,
                    color: colorGrayDark,
                  ),
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
                flex: 4,
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: parking.numberOfFreeSpaces == 0
                                      ? colorRed
                                      : colorGreen,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: AvailableSpacesIcon(
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
                                        ? '${parking.numberOfFreeSpaces} слободни местo'
                                        : '${parking.numberOfFreeSpaces} слободни места',
                                style: font14Regular.copyWith(
                                    color: parking.numberOfFreeSpaces == 0
                                        ? colorRed
                                        : colorGreen)),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          Text(parking.workingHours.isEmpty ? '/' : 'Пон-Пет',
                              style: font14Bold.copyWith(color: colorBlueDark)),
                          Text(
                            parking.workingHours.isEmpty
                                ? '/'
                                : '${parking.workingHours[0].timeFrom.substring(0, 5)}-${parking.workingHours[0].timeTo.substring(0, 5)}',
                            style: font14Bold.copyWith(color: colorBlueDark),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                              OpenHoursHelper.isOpen(parking)
                                  ? 'Моментално отворен'
                                  : 'Моментално затворен',
                              style: font10Regular.copyWith(
                                  color: OpenHoursHelper.isOpen(parking)
                                      ? colorGreen
                                      : colorRed)),
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
