import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maptiler1/admin_screen.dart';
import 'package:maptiler1/test.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => Driver_Home();
}

class Driver_Home extends State<AdminHome> {
  var isButtonEnabled;
  final ref = FirebaseDatabase.instance.ref("Positions");

  @override
  void initState() {
    getStatus();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context)  {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('Driver Home page'),
            centerTitle: true,

          ),

          drawer: MyDrawer(onProfileTap: goTracking, onSignOut: signOut),

          body: Form(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(105, 60, 20, 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[ 

                  CircleAvatar(
                    backgroundImage: AssetImage('assets/driver.png'),
                    radius: 80,
                  ),

                  SizedBox(height: 60,),

                  ElevatedButton(
                    onPressed: 
                       isButtonEnabled ? ()async {
                        disableButton();
                        goTracking();
                      }: null,
                    
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        minimumSize: Size(200, 50)
                    ),


                    child: Text(isButtonEnabled ? 'Start the drive' : 'The bus is used', style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                  ),


                ],
              ),
            ),
          ),
        );
      }
  void signOut() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Register()));
  }   
  void goTracking() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdminScreen()));
  }   
  void disableButton(){
    ref.update({
      "available" : "false"
    });
  } 
  void getStatus() async{
    final snapshot = await ref.child('available').get();
    print ("heyyyyyyyyyyyyyyyyyyyyyyyyy");
    print(snapshot.value);
    setState((){
    if (snapshot.value == 'true'){isButtonEnabled== true;print("Enabledddddddddddddddddddddd");}else{isButtonEnabled = false;print("dddddddddddddddddddddddddddddddddddddddddd");}

    });

  }
}
class MyDrawer extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onSignOut;

  MyDrawer({required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drivers options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Start Tracking'),
            onTap: onProfileTap,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
