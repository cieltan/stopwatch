import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  GoogleMapController myController;
  static const LatLng _center = const LatLng(40.7049444, -74.0091771);
  @override
  build(context) {
    return Stack(children: <Widget>[
      GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid)
    ]);
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      myController = controller;
    });
  }
}
