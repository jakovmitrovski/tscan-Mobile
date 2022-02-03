import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/widgets/parking_long_details_sheet.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mdi/mdi.dart';


class ParkingShortDetailsSheet extends StatelessWidget {

  Parking parking;
  Position position;

  ParkingShortDetailsSheet({required this.parking, required this.position});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Container(
      color: const Color(0xFFf5f5f5),
      child: Listener(
        onPointerMove: (moveEvent) {
          if(moveEvent.delta.dy < -10) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Container(
                    height: 0.80*height,
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ParkingLongDetailsSheet(parking: parking, position: position)
                )
            );
          }

        },
        child: GestureDetector(
          onTap: () {
            print("tapped");
            //TODO: NOT SURE WHETHER TO ADD THE MODAL SHEET HERE TOO.
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)
                )
            ),
            child: Column(
                children: [
                  Container(margin: EdgeInsets.only(bottom: 5), width: 60, height: 2, color: colorGrayDark,),
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
                                    style: font18Bold.copyWith(color: colorBlueDark),
                                  ),
                                  Text(
                                      '${parking.hourlyPrice} ден.',
                                      style: font18Bold.copyWith(color: colorBlueDark)
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    parking.locationAddress,
                                    style: font12Regular.copyWith(color: colorGrayDark),
                                  ),
                                  Text(
                                      '/ час',
                                      style: font12Light.copyWith(color: colorBlueDark)
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: parking.numberOfFreeSpaces == 0 ? colorRed : colorGreen,
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      //TODO: OPTIONALLY CHANGE ICON FOR PARKING
                                      child: Icon(parking.numberOfFreeSpaces == 0 ? Icons.close : Mdi.parking, color: Colors.white, size: 20),
                                    ),
                                  ),
                                  Text(
                                      parking.numberOfFreeSpaces == 0 ? 'Нема слободни места' : (parking.numberOfFreeSpaces % 10 == 1 && parking.numberOfFreeSpaces != 11) ? '${parking.numberOfFreeSpaces} слободни местo' : '${parking.numberOfFreeSpaces} слободни места',
                                      style: font12Regular.copyWith(color: parking.numberOfFreeSpaces == 0 ? colorRed : colorGreen)
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: colorBlueLight,
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                      child: Icon(CupertinoIcons.compass, color: Colors.white, size: 20),
                                    ),
                                  ),
                                  Text(
                                      '${parking.distance} оддалеченост',
                                      style: font12Regular.copyWith(color: colorBlueDark)
                                  ),
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
                        final url = 'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${parking.latitude},${parking.longitude}&travelmode=driving&dir_action=navigate';
                        await launch(url);
                      },
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
