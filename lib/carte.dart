import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapTiler Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String mapTilerToken = 'xQrnBPgGdnZ4sLxwXa46';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MapTiler Example'),
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
}