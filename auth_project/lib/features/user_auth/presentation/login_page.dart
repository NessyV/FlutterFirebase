import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t8a/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:t8a/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:t8a/features/user_auth/presentation/widget/form_container_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body:Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(height: 10,),
                          FormContainerWidget(
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: _signIn,
                child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color:  Colors.blue,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                ),
              ),
              SizedBox(height: 5,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(" Dont Have an Account ?"),
                SizedBox(width: 15,),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignUpPage()),(route)=>false);
                  },
                  child: Text("Register", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                )
              ],)
            ],
          ),
      ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User Logged In");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      print("Error Occurred");
    }
  }
}
