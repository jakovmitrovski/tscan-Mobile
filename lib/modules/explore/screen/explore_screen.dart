import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/filter_data_model.dart';
import 'package:squick/models/maps_provider.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/modules/map/screen/map_screen.dart';
import 'package:squick/utils/helpers/location.dart';
import 'package:squick/widgets/filter_popup_screen.dart';
import 'package:squick/widgets/parking_widget.dart';
import 'package:squick/widgets/search_bar.dart';

class ExploreScreen extends StatefulWidget {
  static const String id = "/explore";

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Widget? screen;
  String? selected;
  late MapsProvider mapsProvider;
  late FilterDataModel filter;
  Position? _currentPosition;
  String? keyword;
  late double height;

  _getCurrentPosition() async {
    Position p = await LocationHelper().getCurrentLocation();
    setState(() {
      _currentPosition = p;
    });
  }

  @override
  void initState() {
    screen = const MapScreen();
    selected = "map";
    super.initState();
    _getCurrentPosition();
  }

  List<Widget> getParkingList(List<Parking> parkings) {
    List<Widget> ret = [];
    for (int i=0; i<parkings.length; i++) {
      Parking parking = parkings[i];
      Widget parkingWidget = ParkingWidget(height: height, parking: parking, position: _currentPosition!,);
      ret.add(parkingWidget);
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {

    mapsProvider = Provider.of<MapsProvider>(context);
    filter = Provider.of<FilterDataModel>(context);
    height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    if (_currentPosition == null) {
      return const SafeArea(child: SpinKitDoubleBounce(
        color: colorBlueLight,
        size: 100.0,
      )
      );
    }

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: width,
            //TODO: CHANGE THIS WITH GRADIENT
            color: colorBlueLightest,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.7 * width,
                    child: Text(
                      'Пронајди паркинг брзо и лесно',
                      style: font24Bold.copyWith(color: Colors.white)
                      ,),
                  ),
                  SearchBar(
                      width: width,
                      onSearchBarTap: () {

                      },
                      onSearch: (value) {
                        setState(() {
                          keyword = value;
                        });

                      },
                      onFilterPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Container(
                              height: 0.60*height,
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: FilterPopup(onTap: (price, openNow, freeSpaces) {
                                filter.changeAllValues(price, openNow, freeSpaces);
                                Navigator.pop(context);
                              }),
                            )
                        );
                      }
                  )
                ]
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: colorBlueLightest,
            child: Container(
              decoration: const BoxDecoration(
                  color: colorGray,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Паркинзи во близина',
                      style: font12Regular.copyWith(color: colorBlueDark),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child: FutureBuilder(
                          future: mapsProvider.getParkingsFromApi(filter.getValue('price'), filter.getValue('openNow'), filter.getValue('freeSpaces'), _currentPosition!, keyword: keyword),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.connectionState == ConnectionState.done) {
                              return ListView(
                                children: getParkingList(snapshot.data as List<Parking>),
                              );
                            }else {
                              return const SpinKitDoubleBounce(
                                color: colorBlueLight,
                                size: 100.0,
                              );
                            }
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
