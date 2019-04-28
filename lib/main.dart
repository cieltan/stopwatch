import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'StopWatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(body: FireMap()));
  }
}

class FireMap extends StatefulWidget {
  @override
  State createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  List<Marker> locations = [];
  var geoLocator = Geolocator();
  String searchAddr;
  bool trackLocation = false;
  static const LatLng _center = const LatLng(40.7049444, -74.0091771);
  @override
  initState() {
    //TODO: implement initState
    super.initState;
    checkGps();
    //  use locateUser method to find LatLng of user
    _locateUser();
  }

  checkGps() async {
    var status = await geoLocator.checkGeolocationPermissionStatus();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    if (status == GeolocationStatus.granted) {
      print("Success: Geolocation successful");
    } else {
      print("Failed");
    }
    StreamSubscription<Position> positionStream = geoLocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());
    });
  }

  Future<Position> _locateUser() async {
    var result = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      locations.add(Marker(
          markerId: MarkerId('myMarker'),
          draggable: false,
          onTap: () {
            print('Marker Tapped');
          },
          infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: '${result.latitude}, ${result.longitude}'),
          position: LatLng(result.latitude, result.longitude)));
    });
    return result;
  }

  build(context) {
    return Stack(alignment: Alignment.bottomCenter, children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              markers: Set.from(locations))),
      Positioned(
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter Address',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                      suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: searchandNavigate,
                          iconSize: 30.0)),
                  onChanged: (val) {
                    setState(() {
                      searchAddr = val;
                    });
                  }))),
      Positioned(
          bottom: 50.0,
          left: 10.0,
          child: FlatButton(
              child: Icon(Icons.pin_drop, color: Colors.white),
              color: Colors.blue,
              onPressed: _addMarker))
    ]);
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 16.0)));
    });
  }

  _addMarker() {}

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
