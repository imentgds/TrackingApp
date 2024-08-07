import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
runApp(MyApp1());
}


class MyApp1 extends StatefulWidget {
  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<MyApp1> {
  final String mapTilerToken = 'xQrnBPgGdnZ4sLxwXa46';
  List<Marker> _markers= [];
  late MapController _mapController = MapController();

  StreamSubscription<Position>? positionStream ;


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(appBar: AppBar(
        title: Text('Tracking App'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(36.8065 , 10.1815), initialZoom: 10.0),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerToken',
            additionalOptions: {
              'key': mapTilerToken,
            },
          ),MarkerLayer(markers: _markers),

        ],
      ),)
      
    );
  }


  getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission permission;
    

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      //yekhdemch l alert dialog tw
      return AlertDialog(
              title: Text("Location Unavailable"),
              content: Text("Activate ur location first"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );  
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
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    if (permission == LocationPermission.whileInUse){
      Position position= await Geolocator.getCurrentPosition();
      print(position.latitude);
      //_mapController.move(LatLng(position.latitude, position.longitude),15.0);
      positionStream = Geolocator.getPositionStream().listen(
          (Position? position) {
          _markers.clear();
          _markers.add(Marker(
            point: LatLng(position!.latitude, position.longitude),
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            )
          ));
          setState(() {
            _mapController.move(LatLng(position.latitude, position.longitude), 11.0);
          });
          });   
         }
    }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
}
  @override
  void dispose() {
    positionStream!.cancel();
    super.dispose();
  }
}
