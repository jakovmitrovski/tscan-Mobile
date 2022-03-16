import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/parking_long_details_sheet.dart';
import 'available_spaces_icon.dart';

class ParkingWidget extends StatelessWidget {
  double height;
  Parking parking;
  Position position;

  ParkingWidget(
      {required this.height, required this.parking, required this.position});

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
            height: 0.87 * height,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ParkingLongDetailsSheet(
              parking: parking,
              position: position,
            )));
  }

  @override
  Widget build(BuildContext context) {

    bool isOpen = OpenHoursHelper.isOpen(parking);

    return Container(
      height: 0.165 * height,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )),
      child: InkWell(
        onTap: () {
          _showModalSheet(context);
        },
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(parking.imageUrlMedium),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        width: 60,
                        height: 20,
                        decoration: const BoxDecoration(
                            color: colorGrayTransparent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorBlueLight,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Icon(IconlyLight.discovery,
                                    color: Colors.white, size: 15),
                              ),
                            ),
                            Text(parking.distance,
                                style: font10Regular.copyWith(
                                    color: colorBlueDark)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parking.name,
                          style: font16Bold.copyWith(color: colorBlueDark),
                        ),
                        Text(
                          parking.locationAddress,
                          style: font10Regular.copyWith(color: colorGrayDark),
                        ),
                      ],
                    ),
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
                                    color: colorOrange, size: 15),
                              ),
                            ),
                            Text('${parking.hourlyPrice}ден/час',
                                style: font10Regular.copyWith(
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
                                  color: (parking.numberOfFreeSpaces == 0 || !isOpen)
                                      ? colorRed
                                      : colorGreen,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: AvailableSpacesIcon(
                                  isOpen: isOpen,
                                  numberOfFreeSpaces:
                                      parking.numberOfFreeSpaces,
                                  size: 15,
                                ),
                              ),
                            ),
                            Text(
                                !isOpen? 'Моментално затворен' :
                                parking.numberOfFreeSpaces == 0
                                    ? 'Нема слободни места'
                                    : (parking.numberOfFreeSpaces % 10 == 1 &&
                                            parking.numberOfFreeSpaces != 11)
                                        ? '${parking.numberOfFreeSpaces} слободно место'
                                        : '${parking.numberOfFreeSpaces} слободни места',
                                style: font10Regular.copyWith(
                                    color: (parking.numberOfFreeSpaces == 0 || !isOpen)
                                        ? colorRed
                                        : colorGreen)),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
