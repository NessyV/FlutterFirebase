import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:t8a/features/app/splash_screen/splash_screen.dart';
import 'package:t8a/features/user_auth/presentation/login_page.dart';
import 'package:t8a/features/user_auth/presentation/pages/home_page.dart';
import 'package:t8a/features/user_auth/presentation/pages/sign_up_page.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyDcITE4EmH5Pib-duU_vmgtdZgy7v5qzBA", appId: "1:732293892691:web:69fe1b5e656704bb5e94a6", messagingSenderId: "732293892691", projectId: "flutter-firebase-fe354"));
  }
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
