import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:t8a/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:t8a/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:t8a/features/user_auth/presentation/widget/form_container_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../global/common/toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool _isSignin = false ;
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      body:Container(
        child: Center(
          child: Container(
            width: 500,
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
                    controller: _emailController,
                    isPasswordField: false,
                  ),
                  SizedBox(height: 10,),
                              FormContainerWidget(
                    hintText: "Password",
                    controller: _passwordController,
                    isPasswordField: true,
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: _signIn,
                    child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color:  Colors.green,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: _isSignin ? CircularProgressIndicator(color: Colors.white,): Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
                    ),
                  ),
                  SizedBox(height: 5,),
                  GestureDetector(
                    onTap: _signInWithGoogle,
                    child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color:  Colors.redAccent,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.google),
                          SizedBox(width: 5,),
                          Text("Sign in with Gooogle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ))
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" Dont Have an Account ?"),
                    SizedBox(width: 15,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> SignUpPage()),(route)=>false);
                      },
                      child: Text("Register", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                    )
                  ],)
                ],
              ),
                    ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSignin = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSignin = false;
    });

    if (user != null) {
      showToast(message: "User is successfully signed in");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showToast(message: "some error occurred");
      // print("Email addresses ${email}");
    }
  }
  _signInWithGoogle()async{
    final GoogleSignIn _googleSignIn = GoogleSignIn(clientId: '732293892691-otnu251i8fr29t3csdkck4p7334gqa2f.apps.googleusercontent.com');

    try{
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if(account != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await account.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, "/home");
      }
    }catch(e){
      showToast(message: "Error $e");
    }
  }
}
