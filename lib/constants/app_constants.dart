import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:squick/utils/helpers/utils.dart';

// BLUE
const Color colorBlue = Color(0xff149AC3);
const Color colorBlueLight = Color(0xff5DABC2);
const Color colorBlueLightest = Color(0xff99E1F7);
// DARK BLUE
const Color colorBlueDark = Color(0xff001F3E);
const Color colorBlueDarkLight = Color(0xff2C4054);
const colorBlueDarkLightest = Color(0xff678098);
// ORANGE
const Color colorOrange = Color(0xffF9921F);
const Color colorOrangeLight = Color(0xffF8B56B);
const Color colorOrangeLightest = Color(0xffFED6A8);
// GREEN
const Color colorGreen = Color(0xff15BF3B);
// RED
const Color colorRed = Color(0xffE32216);
// GRAY
const Color colorGray = Color(0xffF7F7F7);
const Color colorGrayDark = Color(0xffC4C4C4);

const Color colorGrayTransparent = Color.fromRGBO(220, 220, 220, 0.7);

const creditCardLabelStyle = TextStyle(
  fontFamily: 'Roboto',
  fontWeight: FontWeight.w400,
  fontSize: 14.0,
  color: colorGrayDark,
);

const LatLng kCenterLocation = LatLng(41.98374140000001, 21.4369859);

// TEXT CONSTANTS
// FONT 36
TextStyle font36Black =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w900);
TextStyle font36Bold =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w700);
TextStyle font36Medium =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w500);
TextStyle font36Regular =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w400);
TextStyle font36Light =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w300);
TextStyle font36Thin =
    Utils.getFont(fontSize: 36.0, fontWeight: FontWeight.w100);
// FONT 32
TextStyle font32Black =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w900);
TextStyle font32Bold =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w700);
TextStyle font32Medium =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w500);
TextStyle font32Regular =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w400);
TextStyle font32Light =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w300);
TextStyle font32Thin =
    Utils.getFont(fontSize: 32.0, fontWeight: FontWeight.w100);
// FONT 30
TextStyle font30Black =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w900);
TextStyle font30Bold =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w700);
TextStyle font30Medium =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w500);
TextStyle font30Regular =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w400);
TextStyle font30Light =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w300);
TextStyle font30Thin =
    Utils.getFont(fontSize: 30.0, fontWeight: FontWeight.w100);
// FONT 24
TextStyle font24Black =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w900);
TextStyle font24Bold =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w700);
TextStyle font24Medium =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w500);
TextStyle font24Regular =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w400);
TextStyle font24Light =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w300);
TextStyle font24Thin =
    Utils.getFont(fontSize: 24.0, fontWeight: FontWeight.w100);
// FONT 22
TextStyle font22Black =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w900);
TextStyle font22Bold =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w700);
TextStyle font22Medium =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w500);
TextStyle font22Regular =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w400);
TextStyle font22Light =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w300);
TextStyle font22Thin =
    Utils.getFont(fontSize: 22.0, fontWeight: FontWeight.w100);
// FONT 20
TextStyle font20Black =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w900);
TextStyle font20Bold =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w700);
TextStyle font20Medium =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w500);
TextStyle font20Regular =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w400);
TextStyle font20Light =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w300);
TextStyle font20Thin =
    Utils.getFont(fontSize: 20.0, fontWeight: FontWeight.w100);
// FONT 18
TextStyle font18Black =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w900);
TextStyle font18Bold =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w700);
TextStyle font18Medium =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w500);
TextStyle font18Regular =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w400);
TextStyle font18Light =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w300);
TextStyle font18Thin =
    Utils.getFont(fontSize: 18.0, fontWeight: FontWeight.w100);
// FONT 16
TextStyle font16Black =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w900);
TextStyle font16Bold =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w700);
TextStyle font16Medium =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w500);
TextStyle font16Regular =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w400);
TextStyle font16Light =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w300);
TextStyle font16Thin =
    Utils.getFont(fontSize: 16.0, fontWeight: FontWeight.w100);
// FONT 14
TextStyle font14Black =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w900);
TextStyle font14Bold =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w700);
TextStyle font14Medium =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w500);
TextStyle font14Regular =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w400);
TextStyle font14Light =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w300);
TextStyle font14Thin =
    Utils.getFont(fontSize: 14.0, fontWeight: FontWeight.w100);
// FONT 12
TextStyle font12Black =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w900);
TextStyle font12Bold =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w700);
TextStyle font12Medium =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w500);
TextStyle font12Regular =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w400);
TextStyle font12Light =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w300);
TextStyle font12Thin =
    Utils.getFont(fontSize: 12.0, fontWeight: FontWeight.w100);
// FONT 10.0
TextStyle font10Black =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w900);
TextStyle font10Bold =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w700);
TextStyle font10Medium =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w500);
TextStyle font10Regular =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w400);
TextStyle font10Light =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w300);
TextStyle font10Thin =
    Utils.getFont(fontSize: 10.0, fontWeight: FontWeight.w100);

const kCreditCardTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Riveruta',
  fontWeight: FontWeight.w500,
  fontSize: 17.0,
  letterSpacing: 2,
);

const kMaxNumberOfCreditCards = 4;

const kModalSheetsPadding = EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 25.0);

const kLoaderCentered = const Center(
                        child: SpinKitDoubleBounce(
                            color: colorBlueLight,
                            size: 100.0,
                        ),
                    );

const kLoader = const  SpinKitDoubleBounce(
                            color: colorBlueLight,
                            size: 100.0,
                        );