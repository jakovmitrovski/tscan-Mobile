import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  topRight: Radius.circular(20.0)
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 60, height: 2, color: colorGrayDark,),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                      'Тука треба детали, копчето насоки работи',
                      textAlign: TextAlign.center,
                      style: font20Medium
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Цена', style: font14Medium,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('20ден', style: font10Light.copyWith(
                            color: colorGrayDark),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Моментално отворено', style: font14Medium
                            .copyWith(color: colorBlueDark)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Слободни места', style: font14Medium.copyWith(
                            color: colorBlueDark)),
                      ],
                    ),
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
                    final url = 'https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${parking.latitude},${parking.longitude}&travelmode=driving&dir_action=navigate';
                    await launch(url);
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
