import 'package:flutter/material.dart';

class AdminInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Interface'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Action à effectuer lors de l'appui sur le bouton "Start Ride"
          },
          child: Text('Start Ride'),
        ),
      ),
    );
  }
}
