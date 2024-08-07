import 'package:flutter/material.dart';
import 'track.dart'; // Assurez-vous que ce fichier est correctement importé et contient la classe MyApp
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);// Attendez la fin de l'initialisation
  runApp(AdminInterface());
}

class AdminInterface extends StatelessWidget {
  Future<void> _addUser() async {
    CollectionReference state = FirebaseFirestore.instance.collection('state');

    try {
      await state.add({
        'status': 'start',
      });
      print("User added successfully!");
    } catch (error) {
      print("Failed to add user: $error");
    }
  }

  Future<void> _startRide(BuildContext context) async {
    _addUser();
    // Naviguez vers MyApp
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp1()),
    );
   
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Admin Interface'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _startRide(context); // Passez le contexte à la fonction
            },
            child: Text('Start Ride'),
          ),
        ),
      ),
    );
  }
}
