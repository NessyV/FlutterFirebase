import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(
        Duration(seconds: 5),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget.child!), (route) => false);
    }
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "Welcome To Waste Tracker",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold, fontSize: 16,
              ),
            ),
            SizedBox(height: 15,),
            Container(
              width: 200,
              child:
              LinearProgressIndicator(color: Colors.blue,),
            ),
          ],
        ),
      ),
    );
  }
}