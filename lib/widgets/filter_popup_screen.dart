import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/widgets/squick_button.dart';

class FilterPopup extends StatefulWidget {
  const FilterPopup({Key? key}) : super(key: key);

  @override
  _FilterPopupState createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {

  double price = 250;
  bool openNow = false;
  bool freeSpaces = false;

  bool changed() {
    return price != 250 || openNow || freeSpaces;
  }

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
                    'Филтер',
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
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colorBlueLight,
                          inactiveTrackColor: colorGrayDark,
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
                          overlayColor: colorBlueLightest,
                          thumbColor: colorBlueLight
                      ),
                      child: Slider(
                        value: price,
                        onChanged: (double newValue){
                          setState(() {
                            price = newValue;
                          });
                        },
                        min: 20.0,
                        max: 250.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('20ден', style: font10Light.copyWith(color: colorGrayDark),),
                        Text('250ден', style: font10Light.copyWith(color: colorGrayDark),)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Моментално отворено', style: font14Medium.copyWith(color: colorBlueDark)),
                        Switch(
                          value: openNow,
                          onChanged: (bool value) {
                            setState(() {
                              openNow = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: colorBlueDark,
                        ),

                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Слободни места', style: font14Medium.copyWith(color: colorBlueDark)),
                        Switch(
                          value: freeSpaces,
                          onChanged: (bool value) {
                            setState(() {
                              freeSpaces = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: colorBlueDark,
                        ),

                      ],
                    ),
                  ],
                ),
              ),
              SquickButton(
                buttonText: 'Филтрирај',
                onTap: () {
                  print('filterrr');
                  Navigator.pop(context);
                },
              ),
              changed()? TextButton(
                  onPressed: () {
                    setState(() {
                      price = 250;
                      openNow = false;
                      freeSpaces = false;
                    });
                  },
                  child: Text('Исчисти филтер', style: font12Regular.copyWith(color: colorBlueDark),)
              ) : Container()
            ],
          ),
        )
    );
  }
}


