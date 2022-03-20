import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:squick/utils/helpers/open_hours.dart';
import 'package:squick/widgets/filter_popup_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:squick/widgets/parking_short_details_sheet.dart';
import 'package:squick/widgets/search_bar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late MapsProvider mapsProvider;
  PersistentBottomSheetController? bottomSheetController;

  void loadFreeSpacesAvailablePin() async {
    freeSpacesAvailablePin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
        Platform.isAndroid ? 'assets/images/free_spaces_car.png' : 'assets/images/free_spaces_car_ios.png');
  }

  void loadFreeSpacesUnavailablePin() async {
    freeSpacesUnavailablePin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
    Platform.isAndroid ? 'assets/images/no_free_spaces_car.png' : 'assets/images/no_free_spaces_car_ios.png');
  }

  void loadSelectedPin() async {
    selectedPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5),
    Platform.isAndroid ? 'assets/images/selected_pin_car.png' : 'assets/images/selected_pin_car_ios.png');
  }

  void updateCamera(Position? position) {

    if (position == null) return;

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14.0,
        ),
      ),
    );
  }

  _updateCurrentPosition(BuildContext context) async {
    try {
      await mapsProvider.updateCurrentPosition();
      _currentPosition = await mapsProvider.getCurrentPosition();
    } on LocationServicesOffException catch(e) {
      AlertHelper.showAlert(context,
          title: e.toString(),
          description: 'Ве молиме вклучети ги истите во подесувања на телефонот и одново вклучете ја апликацијата за да работи соодветно!',
          buttonText: 'Отвори подесувања',
          onTap: () async {
            await AppSettings.openAppSettings();
            exit(1);
          }
      );
    } on LocationServicesPermissionDeniedException catch(e) {
      AlertHelper.showAlert(context,
          title: e.toString(),
          description: 'Ве молиме дадете и локациски пермисии на TScan и одново вклучете ја апликацијата за да работи соодветно!',
          buttonText: 'Отвори подесувања',
          onTap: () async {
            await AppSettings.openAppSettings();
            exit(1);
          }
      );
    } on LocationServicesPermissionDeniedForeverOffException catch(e) {
      AlertHelper.showAlert(context,
          title: e.toString(),
          description: 'За TScan да работи соодветно, потребно е одново да ја инсталирате апликацијата.',
          buttonText: 'Затвори ја TScan',
          onTap: () {
            exit(1);
          }
      );
    }
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });
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

  Parking? getParkingById(int id) {
    for (int i = 0; i < _parkings.length; i++) {
      if (_parkings[i].id == id) return _parkings[i];
    }
    return null;
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
            mapsProvider.updateShouldLoad(false);
          });

      markers.add(marker);
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    mapsProvider = Provider.of<MapsProvider>(context);
    var filter = Provider.of<FilterDataModel>(context);

    selectedParkingProvider = Provider.of<SelectedParkingProvider>(context);

    if (_currentPosition == null) {
      _updateCurrentPosition(context);
      return kLoader;
    }

    return SizedBox(
      width: width,
      height: height,
      child: Stack(children: [
    mapsProvider.shouldLoad
        ? FutureBuilder(
            future: mapsProvider.getParkingsFromApi(
                context,
                filter.getValue('price'),
                filter.getValue('openNow'),
                filter.getValue('freeSpaces'),
                _currentPosition!,
                keyword: filter.getValue('keyword')),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.connectionState == ConnectionState.done) {
                return GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                    mapController.setMapStyle(_mapStyle);
                  },
                  initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
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
                return kLoader;
              }
            })
        : GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController.setMapStyle(_mapStyle);
            },
            initialCameraPosition: CameraPosition(
                target: selectedParkingProvider.selected == -1 ? LatLng(_currentPosition!.latitude,
                    _currentPosition!.longitude) : LatLng(getParkingById(selectedParkingProvider.selected)!.latitude, getParkingById(selectedParkingProvider.selected)!.longitude),
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
        initialText: filter.getValue('keyword'),
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
            filter.change('keyword', value);
            mapsProvider.updateShouldLoad(true);
          } else {
            filter.change('keyword', null);
          }
        },
        onFilterPressed: () {

          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => Container(
                    height: 0.60.sh,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: FilterPopup(
                        onTap: (price, openNow, freeSpaces) {
                          if (selectedParkingProvider.selected != -1 &&
                              bottomSheetController != null) {
                            bottomSheetController!.close();
                            selectedParkingProvider.updateValue(-1);
                          }
                          mapsProvider.updateShouldLoad(true);
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
            updateCamera(await mapsProvider.getCurrentPosition());
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
    );
  }
}
