import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Carte.dart';

class UserInterface extends StatefulWidget {
  @override
  _UserInterfaceState createState() => _UserInterfaceState();
}

class _UserInterfaceState extends State<UserInterface> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('rides').doc('currentRide').snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data()!['startRide'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Interface'),
      ),
      body: Center(
        child: Text('Waiting for ride to start...'),
      ),
    );
  }
}
