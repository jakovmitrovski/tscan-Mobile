import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/models/exceptions/location_services_off_exception.dart';
import 'package:squick/models/exceptions/location_services_permission_denied_exception.dart';
import 'package:squick/models/exceptions/location_services_permission_denied_forever_exception.dart';
import 'package:squick/models/filter_data_model.dart';
import 'package:squick/models/parking.dart';
import 'package:squick/models/maps_provider.dart';
import 'package:squick/models/selected_parking_provider.dart';
import 'package:squick/utils/helpers/alert.dart';
import 'package:squick/utils/helpers/location.dart';
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/filter_popup_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:squick/widgets/parking_short_details_sheet.dart';
import 'package:squick/widgets/search_bar.dart';

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
  late SelectedParkingProvider selectedParkingProvider;
  PersistentBottomSheetController? bottomSheetController;

  void loadFreeSpacesAvailablePin() async {
    freeSpacesAvailablePin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/free_spaces_car.png');
  }

  void loadFreeSpacesUnavailablePin() async {
    freeSpacesUnavailablePin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/no_free_spaces_car.png');
  }

  void loadSelectedPin() async {
    selectedPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
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
    try {
      Position p = await LocationHelper().getCurrentLocation();
      setState(() {
        _currentPosition = p;
      });
    } on LocationServicesOffException catch(e) {
      AlertHelper.showAlert(context, e.toString(), 'Ве молиме вклучети ги истите во подесувања на телефонот.');
    } on LocationServicesPermissionDeniedException catch(e) {
      AlertHelper.showAlert(context, e.toString(), 'Ве молиме дадете и локациски пермисии на TScan за да работи соодветно');
    } on LocationServicesPermissionDeniedForeverOffException catch(e) {
      AlertHelper.showAlert(context, e.toString(), 'За TScan да работи соодветно, потребно е одново да ја инсталирате апликацијата.');
    }
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

  BitmapDescriptor resolveIcon(Parking parking, bool isOpen) {
    if (selectedParkingProvider.selected == parking.id) return selectedPin;

    return (parking.numberOfFreeSpaces == 0 || !isOpen)
        ? freeSpacesUnavailablePin
        : freeSpacesAvailablePin;
  }

  Set<Marker> getMarkers(List<Parking> parkings) {
    Set<Marker> markers = {};
    _parkings = parkings;

    for (int i = 0; i < parkings.length; i++) {
      Parking parking = parkings[i];
      bool isOpen = OpenHoursHelper.isOpen(parking);
      final marker = Marker(
          markerId: MarkerId(parking.id.toString()),
          position: LatLng(parking.latitude, parking.longitude),
          icon: resolveIcon(parking, isOpen),
          onTap: () {
            if (selectedParkingProvider.selected != parking.id) {
              selectedParkingProvider.updateValue(parking.id);

              bottomSheetController = showBottomSheet(
                  context: context,
                  builder: (context) => Container(
                        height: 0.30 * MediaQuery.of(context).size.height,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ParkingShortDetailsSheet(
                            parking: parking, position: _currentPosition!),
                      ));
              bottomSheetController!.closed
                  .whenComplete(() => selectedParkingProvider.updateValue(-1));
            }

            setState(() {
              shouldLoad = false;
            });
          });

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
    selectedParkingProvider = Provider.of<SelectedParkingProvider>(context);

    if (_currentPosition == null) {
      return const SafeArea(
          child: SpinKitDoubleBounce(
        color: colorBlueLight,
        size: 100.0,
      ));
    }

    return SafeArea(
        child: SizedBox(
      width: width,
      height: height,
      child: Stack(children: [
        shouldLoad
            ? FutureBuilder(
                future: mapsProvider.getParkingsFromApi(
                    context,
                    filter.getValue('price'),
                    filter.getValue('openNow'),
                    filter.getValue('freeSpaces'),
                    _currentPosition!,
                    keyword: keyword),
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
                          zoom: 14.0),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      mapType: MapType.normal,
                      markers: getMarkers(snapshot.data as List<Parking>),
                    );
                  } else {
                    return const SpinKitDoubleBounce(
                      color: colorBlueLight,
                      size: 100.0,
                    );
                  }
                })
            : GoogleMap(
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
                    zoom: 14.0),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                mapType: MapType.normal,
                markers: getMarkers(_parkings),
              ),
        Align(
          alignment: Alignment.topCenter,
          child: SearchBar(
            width: width,
            onSearchBarTap: () {
              if (selectedParkingProvider.selected != -1 &&
                  bottomSheetController != null) {
                bottomSheetController!.close();
                selectedParkingProvider.updateValue(-1);
              }
            },
            onSearch: (value) {
              if (selectedParkingProvider.selected != -1 &&
                  bottomSheetController != null) {
                bottomSheetController!.close();
                selectedParkingProvider.updateValue(-1);
              }
              if (value.isNotEmpty) {
                setState(() {
                  keyword = value;
                  shouldLoad = true;
                });
              } else {
                setState(() {
                  keyword = null;
                });
              }
            },
            onFilterPressed: () {
              shouldLoad = true;
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Container(
                        height: 0.60 * height,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: FilterPopup(onTap: (price, openNow, freeSpaces) {
                          if (selectedParkingProvider.selected != -1 &&
                              bottomSheetController != null) {
                            bottomSheetController!.close();
                            selectedParkingProvider.updateValue(-1);
                          }
                          filter.changeAllValues(price, openNow, freeSpaces);
                          Navigator.pop(context);
                        }),
                      ));
            },
          ),
        ),
        Align(
          alignment: selectedParkingProvider.selected == -1
              ? Alignment.bottomRight
              : Alignment.centerRight,
          child: Container(
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
                  side: const BorderSide(color: Color(0xFFECEDF1))),
            ),
          ),
        ),
      ]),
    ));
  }
}
