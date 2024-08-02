import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<MyApp> {
  final String mapTilerToken = 'xQrnBPgGdnZ4sLxwXa46';
  List<Marker> markers= [];
  StreamSubscription<Position>? positionStream ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking App'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(36.8065 , 10.1815), initialZoom: 10.0, ),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerToken',
            additionalOptions: {
              'key': mapTilerToken,
            },
          ),
        ],
      ),
    );
  }


  getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission permission;
    late MapController _mapController = MapController();
    

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
  }
  
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    if (permission == LocationPermission.whileInUse){
      positionStream = Geolocator.getPositionStream().listen(
          (Position? position) {
          markers.add(Marker(
            point: LatLng(position!.latitude, position.longitude),
            child: MyApp()
          ));
          setState(() {
            _mapController.move(LatLng(position.latitude, position.longitude), 11.0);
          });
          });   
         }
    }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    positionStream!.cancel();
    super.dispose();
  }
}
