import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdi/mdi.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/widgets/parking_long_details_sheet.dart';

class ParkingWidget extends StatelessWidget {

  double height;
  Parking parking;
  Position position;


  ParkingWidget({required this.height, required this.parking, required this.position});

  void _showModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
            height: 0.80*height,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ParkingLongDetailsSheet(parking: parking, position: position,)
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.18 * height,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          )
      ),
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
                          image: NetworkImage(parking.imageUrl),
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
                            )
                        ),
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
                                child: const Icon(CupertinoIcons.compass, color: Colors.white, size: 15),
                              ),
                            ),
                            Text(
                                parking.distance,
                                style: font10Regular.copyWith(color: colorBlueDark)
                            ),
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    const SizedBox(height: 10.0),
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
                                //TODO: OPTIONALLY CHANGE ICON FOR TICKET
                                child: const Icon(Mdi.ticket, color: colorOrange, size: 15),
                              ),
                            ),
                            Text(
                                '${parking.hourlyPrice}ден/час',
                                style: font10Regular.copyWith(color: colorBlueDark)
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0,),
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
                                child: Icon(parking.numberOfFreeSpaces == 0 ? Icons.close : Mdi.parking, color: Colors.white, size: 15),
                              ),
                            ),
                            Text(
                                parking.numberOfFreeSpaces == 0 ? 'Нема слободни места' : (parking.numberOfFreeSpaces % 10 == 1 && parking.numberOfFreeSpaces != 11) ? '${parking.numberOfFreeSpaces} слободни местo' : '${parking.numberOfFreeSpaces} слободни места',
                                style: font10Regular.copyWith(color: parking.numberOfFreeSpaces == 0 ? colorRed : colorGreen)
                            ),
                          ],
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
