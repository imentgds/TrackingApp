import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminScreen extends StatefulWidget {
  @override
  MyHomePage createState() => MyHomePage();
}

class MyHomePage extends State<AdminScreen> {
  final String mapTilerToken = 'xQrnBPgGdnZ4sLxwXa46';
  List<Marker> _markers= [];
  final MapController _mapController = MapController();
  DatabaseReference ref = FirebaseDatabase.instance.ref("Positions");
  StreamSubscription<Position>? positionStream ;
  bool trackingStarted = false;
  bool button = true;


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(appBar: AppBar(
        title: Text('Tracking App'),
      ),
      body : Center(
        child: MapView(),
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: () {
          
          setState(() {
            if(button)
            getCurrentLocation();
            else dispose();
            button= !button;
          });
        },
        child: Icon(trackingStarted ? Icons.stop : Icons.play_arrow),
      ),)
      
    );
  }

Widget MapView(){
  return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(36.8065 , 10.1815), initialZoom: 10.0,
          onMapReady: () {
              _mapController.move(LatLng(36.8098, 10.1115),14.0);
          },
          ),
           
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerToken',
            additionalOptions: {
              'key': mapTilerToken,
            },
          ),MarkerLayer(markers: _markers),

        ],
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
      ref.update({
        "status": "on",
        "latitude": position.latitude,
        "longitude":position.longitude
      });
      //_mapController.move(LatLng(position.latitude, position.longitude),15.0);
      positionStream = Geolocator.getPositionStream(locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),).listen(
          (Position? position) {
          _markers.clear();
          _markers.add(Marker(
            point: LatLng(position!.latitude, position.longitude),
            child: Image.asset('assets/bus.png',
            height: 200.0,
            width: 200.0),
          ));
           ref.update({
            "latitude": position.latitude,
            "longitude":position.longitude
          });
          setState(() {
           // _mapController.move(LatLng(position.latitude, position.longitude), 11.0);
          });
          });   
         }
    }

  @override
  void initState() {
    super.initState();
}
  @override
  void dispose() {
    ref.update({
        "status": "off",
        "available" : "true"
      });
    positionStream!.cancel();
    super.dispose();
  }
}
