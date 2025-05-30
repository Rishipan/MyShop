// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/auth/register_page.dart';
import '../pages/home_page.dart';
import '../utils/my_button.dart';
import '../utils/my_method.dart';
import '../utils/my_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Define userName variable
  late String userName;

  MyMethods myMethods = MyMethods();
  checkNetwork() {
    myMethods.checkConnectivity(context);

    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailController.text.contains('@')) {
      myMethods.displaySnackBar(
          "Please enter a valid email", Colors.yellow, context);
    } else if (passwordController.text.trim().length < 6) {
      myMethods.displaySnackBar(
          "Makesure your password atleast contain 6 characters",
          Colors.yellow,
          context);
    } else {
      // sign up user
      signInUser();
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  signInUser() async {
    // Show loading dialog first
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            const SpinKitCircle(color: Colors.black));

    try {
      // Attempt to sign in with email and password
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Extract user object
      final User? userFirebase = userCredential.user;

      if (userFirebase != null) {
        // Access user details from Firestore
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        try {
          DocumentSnapshot userDoc =
              await firestore.collection('users').doc(userFirebase.uid).get();

          // Close the loading dialog first
          if (mounted) {
            Navigator.pop(context);
          }

          if (userDoc.exists) {
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;

            if (userData["blockStatus"] == "no") {
              // Successful login, proceed to home screen
              userName = userData["shop_name"];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => const HomePage()),
              );
            } else {
              // Account is blocked, sign out and show message
              FirebaseAuth.instance.signOut();
              myMethods.displaySnackBar(
                  "Your account is blocked. Contact admin: rishianrp@gmail.com",
                  Colors.red,
                  context);
            }
          } else {
            // User record does not exist in Firestore
            FirebaseAuth.instance.signOut();
            myMethods.displaySnackBar(
                "Your record does not exist as a User.", Colors.red, context);
          }
        } catch (e) {
          // Handle any errors during the Firestore lookup
          if (mounted) {
            Navigator.pop(context);
          } // Close the loading dialog
          myMethods.displaySnackBar(
              "Error accessing user data: ${e.toString()}",
              Colors.red,
              context);
        }
      }
    } catch (e) {
      // Close dialog and show error
      if (mounted) {
        Navigator.pop(context);
      }
      String errorMessage = "An error occurred. Please try again.";
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Wrong password provided. Please try again.";
        }
      }
      if (mounted) {
        myMethods.displaySnackBar(errorMessage, Colors.red, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    Size screenSize = MediaQuery.of(context).size;
    double len = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        elevation: 4,
      ),
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: len / 15,
              ),

              Icon(
                Icons.shopify_rounded,
                size: (len / 4),
                // color: Colors.green,
              ),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),

              SizedBox(
                height: len / 20,
              ),

              // Username
              MyTextField(
                controller: emailController,
                labelText: 'Email',
                obscureText: false,
                textinputtype: TextInputType.emailAddress,
              ),

              SizedBox(
                height: len / 40,
              ),

              MyTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                textinputtype: TextInputType.visiblePassword,
              ),

              SizedBox(
                height: len / 60,
              ),

              // forgot password?
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('This feature is unavailable at this time')));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: len / 40,
              ),

              // sign in button
              MyButton(
                text: 'Login',
                onTap: checkNetwork,
                color: Colors.green.shade900,
              ),

              SizedBox(
                height: len / 40,
              ),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Text(
                      'Register Now',
                      style: TextStyle(
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: len / 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
