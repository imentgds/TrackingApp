import 'package:flutter/material.dart';
import 'package:maptiler1/user_screen.dart';
import 'package:maptiler1/admin_home.dart';
import 'test_maptiler.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminHome()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 30, 50), // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text(
               'Admin',
              style: TextStyle(
                fontSize: 20, // Font size
              ),),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 30, 50), // Background color
                foregroundColor: Colors.white, // Text color
              ),
              child: Text('User' ,style: TextStyle(
                fontSize: 20, // Font size
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
