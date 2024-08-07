import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'track.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance
      .useFirestoreEmulator('localhost', 8080, sslEnabled: false);
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User interface"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('rides')
              .doc('currentRide')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              MaterialPageRoute(builder: (context) => MyApp1());
            }

            var rideData = snapshot.data!.data() as Map<String, dynamic>;
            var status = rideData['status'];

            if (status == 'started') {
              return Center(child: Text('Ride Started!'));
            } else {
              return Center(child: Text('Waiting for ride to start...'));
            }
          }),
    );
  }
}
