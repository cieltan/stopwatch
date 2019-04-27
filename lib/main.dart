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
        home: Scaffold(body: MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController mapController;
  List<Marker> locations = [];
  dynamic deviceLocation;
  // StreamSubscription<Position> streamSubscription;
  bool trackLocation = false;
  static const LatLng _center = const LatLng(40.7049444, -74.0091771);
  @override
  initState() {
    //TODO: implement initState
    super.initState;
    checkGps();
    //  use locateUser method to find LatLng of user
    _locateUser();
    // locations.add(Marker(
    //     markerId: MarkerId('myMarker'),
    //     draggable: false,
    //     onTap: () {
    //       print('Marker Tapped');
    //     },
    //     position: LatLng(40.7049444, -74.0091771)));
  }

  checkGps() async {
    var geoLocator = Geolocator();
    var status = await geoLocator.checkGeolocationPermissionStatus();
    if (status == GeolocationStatus.granted) {
      print("Success: Geolocation successful");
    } else {
      print("Failed");
    }
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
          position: LatLng(result.latitude, result.longitude)));
    });
    return result;
  }

  build(context) {
    return Stack(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              mapType: MapType.terrain,
              markers: Set.from(locations)))
    ]);
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
