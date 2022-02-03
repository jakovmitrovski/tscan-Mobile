import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/src/provider.dart';
import 'package:squick/constants/api_constants.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/filter_data_model.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/models/maps_provider.dart';
import 'package:squick/utils/helpers/distance.dart';
import 'package:squick/utils/helpers/location.dart';
import 'package:squick/utils/helpers/networking.dart';
import 'package:squick/utils/helpers/parse_utils.dart';
import 'package:squick/widgets/filter_popup_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:squick/widgets/parking_details_sheet.dart';

class MapScreen extends StatefulWidget {
  static const String id = "/map";

  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  late String _mapStyle;
  late GoogleMapController mapController;
  Position? _currentPosition;
  List<Parking> _parkings = [];
  int selectedParking = -1;
  String? keyword;
  late BitmapDescriptor freeSpacesAvailablePin;
  late BitmapDescriptor freeSpacesUnavailablePin;
  late BitmapDescriptor selectedPin;
  bool shouldLoad = true;

  void loadFreeSpacesAvailablePin() async {
    freeSpacesAvailablePin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 8.5),
        'assets/images/free_spaces_car.png');
  }

  void loadFreeSpacesUnavailablePin() async {
    freeSpacesUnavailablePin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/no_free_spaces_car.png');
  }

  void loadSelectedPin() async {
    selectedPin = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/selected_pin_car.png');
  }


  void updateCamera(Position position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  _updateCurrentPosition() async {
    Position p = await LocationHelper().getCurrentLocation();
    setState(() {
      _currentPosition = p;
    });
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });
    _updateCurrentPosition();
    loadFreeSpacesAvailablePin();
    loadFreeSpacesUnavailablePin();
    loadSelectedPin();

  }

  BitmapDescriptor resolveIcon(Parking parking) {
    if (selectedParking == parking.id) return selectedPin;
    return parking.numberOfFreeSpaces == 0 ? freeSpacesUnavailablePin : freeSpacesAvailablePin;
  }

  Set<Marker> getMarkers(List<Parking> parkings) {
    Set<Marker> markers = {};
    _parkings = parkings;

    for (int i = 0; i < parkings.length; i++) {
      Parking parking = parkings[i];
      final marker = Marker(
          markerId: MarkerId(parking.id.toString()),
          position: LatLng(parking.latitude, parking.longitude),
          infoWindow: InfoWindow(
            title: "Растојание",
            snippet: parking.distance,
          ),
          icon: resolveIcon(parking),
          onTap: () {
            setState(() {
              // if (shouldLoad) selectedParking = parking.id;

              if (selectedParking != parking.id) {
                selectedParking = parking.id;
              } else {
                selectedParking = -1;
              }
              shouldLoad = false;
            });
            if (selectedParking != -1) {
              showBottomSheet(
                  context: context,
                  builder: (context) =>
                      Container(
                        height: 0.30 * MediaQuery
                            .of(context)
                            .size
                            .height,
                        padding: EdgeInsets.only(bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                        child: ParkingDetailsSheet(), //TODO: ADD PROVIDER THAT WILL LISTEN FOR THE FILTER VALUES.
                      )
              );
            }
          }
      );

      markers.add(marker);
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var mapsProvider = Provider.of<MapsProvider>(context);
    var filter = Provider.of<FilterDataModel>(context);

    if (_currentPosition == null) {
      return SafeArea(child: const SpinKitDoubleBounce(
        color: colorBlueLight,
        size: 100.0,
      )
      );
    }

    return SafeArea(
      child: Container(
              width: width,
              height: height,
              child: Stack(
                  children: [
                    shouldLoad ? FutureBuilder(
                        future: mapsProvider.getParkingsFromApi(filter.getValue('price'), filter.getValue('openNow'), filter.getValue('freeSpaces'), _currentPosition!, keyword: keyword),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData &&
                          snapshot.data != null &&
                          snapshot.connectionState == ConnectionState.done) {
                            return GoogleMap(
                              // padding: EdgeInsets.only(bottom: 100),
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                                mapController.setMapStyle(_mapStyle);
                              },
                              initialCameraPosition: CameraPosition(
                                  target: _currentPosition == null
                                      ? kCenterLocation
                                      : LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude),
                                  zoom: 14.0
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomGesturesEnabled: true,
                              zoomControlsEnabled: false,
                              mapType: MapType.normal,
                              markers: getMarkers(snapshot.data as List<Parking>),
                          );
                        }else {
                          return const SpinKitDoubleBounce(
                            color: colorBlueLight,
                            size: 100.0,
                          );
                        }
                      }
                    ) : GoogleMap(
                          // padding: EdgeInsets.only(bottom: 100),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            mapController.setMapStyle(_mapStyle);
                          },
                          initialCameraPosition: CameraPosition(
                            target: _currentPosition == null ? kCenterLocation : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            zoom: 14.0
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          markers: getMarkers(_parkings),
                     ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        margin: const EdgeInsets.only(top: 20.0),
                        width: 0.85 * width,
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                  IconlyLight.search,
                                  color: colorGrayDark
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: TextField(
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      keyword = value;
                                      shouldLoad = true;
                                    });
                                  }else {
                                    setState(() {
                                      keyword = null;
                                    });
                                  }
                                },
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                    hintText: "Пребарај паркинг"),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: colorBlueLight,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: IconButton(
                                      icon: Icon(IconlyLight.filter),
                                      color: Colors.white,
                                      onPressed: () {
                                        shouldLoad = true;
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) => Container(
                                              height: 0.60*height,
                                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                              child: FilterPopup(), //TODO: ADD PROVIDER THAT WILL LISTEN FOR THE FILTER VALUES.
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: width / 6,
                            width: width / 6,
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              backgroundColor: Colors.white,
                              heroTag: 'recenter',
                              onPressed: () async {
                                updateCamera(await LocationHelper().getCurrentLocation());
                              },
                              child: Icon(
                                Icons.my_location,
                                size: width / 18,
                                color: colorBlueLight,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xFFECEDF1))),
                            ),
                          ),
                          // selectedParking != -1 ? Container(
                          //   height: height / 5,
                          //   width: width,
                          //   color: Colors.green
                          // ) : Container()
                        ],
                      ),
                    ),
                  ]
              ),
            )
    );
  }
}
