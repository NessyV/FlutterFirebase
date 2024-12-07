import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          children: [Text("Welcome", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                      child: Text("Log Out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
              ),
            )],
        ),
      )
    );
  }
}