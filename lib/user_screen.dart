import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class UserScreen extends StatefulWidget {
  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<UserScreen> {
  bool trackingStarted = false ;
  final String mapTilerToken = 'xQrnBPgGdnZ4sLxwXa46';
  List<Marker> _markers= [];
  DatabaseReference loc = FirebaseDatabase.instance.ref("Location");
  StreamSubscription<Position>? positionStream ;
  List<LatLng> routePoints = [];
  double distanceLeft = 0.0;
  String unit= "m";

  //LatLng userPosition = LatLng(36.8065 , 10.1815); // New York
  //LatLng destinationPosition = LatLng(34.0522, -118.2437); // Los Angeles
  DatabaseReference starCountRef =FirebaseDatabase.instance.ref('Positions');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trackingStarted ? 'The bus is coming ' : 'Not this time'),
      ),
      body: Center(
        child: trackingStarted ? buildMapView() : buildMessage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            /** 
            trackingStarted= !trackingStarted;
            _markers.clear();
            getCurrentLocation();
            */
            refresh();
            
          });
        },
        child: Icon(Icons.refresh),
      ),
      
    );
  }

  Widget buildMessage() {
    return Text(
      'The admin hasn\'t launched the tracking.',
      style: TextStyle(fontSize: 18),
    );
  }

  Widget buildMapView() {
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(36.8065 , 10.1815), initialZoom: 14.0),
        children: [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=$mapTilerToken',
            additionalOptions: {
              'key': mapTilerToken,
            },
          ),MarkerLayer(markers: _markers),

        
      
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints,
              strokeWidth:5.0,
              color: Color.fromARGB(255, 52, 116, 168),
            ),
          ],
        ),
        if (trackingStarted) buildDistanceWidget(),
        ]
    );
  }
  
  
    Widget buildDistanceWidget() {
      if(distanceLeft>=1000.0){distanceLeft = distanceLeft/1000; 
      unit="Km";
      }
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Distance left: ${distanceLeft.toStringAsFixed(2)} $unit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  getCurrentLocation() async{
    bool serviceEnabled;
    LocationPermission permission;
    DatabaseReference ref = FirebaseDatabase.instance.ref("Positions");
    

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
      Position pos= await Geolocator.getCurrentPosition();
      String userPosition = '${pos.longitude},${pos.latitude}';
      _markers.add(Marker(
            point: LatLng(pos.latitude, pos.longitude),
            child: 
            Icon(
              Icons.location_on,             
              color: Color.fromARGB(255, 223, 32, 32),
              size: 30,
            )
            ),
            );
            print(_markers);
    
        starCountRef.onValue.listen((DatabaseEvent event) {
            final data = event.snapshot.value;
            if (data != null && data is Map) {
              double latitude = data['latitude'];
              double longitude = data['longitude'];
              String adminPosition = '$longitude,$latitude';
              fetchRoute(userPosition, adminPosition);
              _markers.add(Marker(
              point: LatLng(latitude, longitude),
              child: Image.asset('assets/bus.png',height: 400.0,width: 400.0),
              ));

              double distance = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            latitude,
            longitude,
          );

          setState(() {
            distanceLeft = distance;
            //_markers.clear();
          });
             } 
            else {
              print('No valid data found');
            }
        });
        print("deeeeeeeeeeeeeeeeeeeeeee");
        print(_markers);

         }
    }

  Future<void> fetchRoute(String startingPoint, String destinationPoint)async {
    const apiKey = '5b3ce3597851110001cf6248a51972c62d9141988ed99aa0c049e709';
    final url ='https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=$destinationPoint&end=$startingPoint';
    final response = await http.get(Uri.parse(url));
    print(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];

      setState(() {
        routePoints = coordinates
            .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      throw Exception('Failed to load route');
    }
  }

void refresh(){
  setState(() {
    initState();
  });
}
@override
  void initState() {
    starCountRef.child("status").onValue.listen((DatabaseEvent event) {
            final data = event.snapshot.value;
            if (data != null && data == 'on') {
              setState(() {
                trackingStarted = true;
                getCurrentLocation();
              });
            } else {

              setState(() {
                trackingStarted = false;
              });
    }});
    print(trackingStarted);
    super.initState();
    _markers.clear();
    
}
}
