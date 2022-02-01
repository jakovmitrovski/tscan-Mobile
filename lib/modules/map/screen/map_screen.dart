import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squick/constants/app_constants.dart';
import 'package:squick/utils/helpers/location.dart';
import 'package:squick/widgets/filter_popup_screen.dart';
import 'package:squick/widgets/squick_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  void updateCamera(Position position) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
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
    _updateCurrentPosition();
    rootBundle.loadString('assets/map/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        width: width,
        height: height,
        child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  mapController.setMapStyle(_mapStyle);
                },
                initialCameraPosition: CameraPosition(
                  target: _currentPosition == null? kCenterLocation : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  zoom: 15.0
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
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
                            //TODO: SEND API REQUEST WITH QUERY = VALUE
                            print("ALLALALALALALALALAL");
                            print("ALLALALALALALALALAL");
                            print("ALLALALALALALALALAL");
                            print("ALLALALALALALALALAL");
                            print("ALLALALALALALALALAL");
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
                alignment: Alignment.bottomRight,
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
                        side: BorderSide(color: Color(0xFFECEDF1))),
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}
