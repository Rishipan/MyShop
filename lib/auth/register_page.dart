// ignore_for_file: use_build_context_synchronously, body_might_complete_normally_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../pages/home_page.dart';
import '../utils/my_button.dart';
import '../utils/my_text_field.dart';
import '../utils/my_method.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controller
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  MyMethods myMethods = MyMethods();

  checkNetwork() {
    myMethods.checkConnectivity(context);
    registerFormValidation();
  }

  registerFormValidation() {
    if (userNameController.text.trim().length < 3) {
      myMethods.displaySnackBar(
          "Your name must be at least 4 or more characters..",
          Colors.orange,
          context);
    } else if (phoneController.text.trim().length != 10) {
      myMethods.displaySnackBar(
          "Please enter a valid number", Colors.orange, context);
    } else if (!emailController.text.contains('@')) {
      myMethods.displaySnackBar(
          "Please enter a valid email", Colors.orange, context);
    } else if (passwordController.text.trim().length < 6) {
      myMethods.displaySnackBar(
          "Make sure your password contains at least 6 characters",
          Colors.orange,
          context);
    } else if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      myMethods.displaySnackBar(
          "Your password does not match with your confirm password",
          Colors.red,
          context);
    } else {
      // Check if the email or phone already exists in Firestore
      checkIfUserExistsInFirestore();
    }
  }

  // Check if the email or phone already exists in Firestore
  checkIfUserExistsInFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Query Firestore to see if the email or phone exists
      QuerySnapshot emailQuery = await firestore
          .collection('users')
          .where('email', isEqualTo: emailController.text.trim())
          .get();

      QuerySnapshot phoneQuery = await firestore
          .collection('users')
          .where('phone', isEqualTo: phoneController.text.trim())
          .get();

      if (emailQuery.docs.isNotEmpty) {
        // Email already exists
        myMethods.displaySnackBar(
            "This email is already registered.", Colors.orange, context);
      } else if (phoneQuery.docs.isNotEmpty) {
        // Phone already exists
        myMethods.displaySnackBar(
            "This phone number is already registered.", Colors.orange, context);
      } else {
        // No existing user found, proceed with registration
        registerUser();
      }
    } catch (e) {
      myMethods.displaySnackBar("Error: ${e.toString()}", Colors.red, context);
    }
  }

  registerUser() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const SpinKitCircle(
              color: Colors.black,
            ));

    try {
      final User? userFirebase = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
              .catchError((errorMsg) {
        Navigator.pop(context);
        myMethods.displaySnackBar(errorMsg.toString(), Colors.red, context);
      }))
          .user;

      if (!context.mounted) return;
      Navigator.pop(context);

      // After registration, check if the account is blocked (check Firestore for blockStatus)
      checkUserBlockStatus(userFirebase);
    } catch (e) {
      Navigator.pop(context);
      myMethods.displaySnackBar("Error: ${e.toString()}", Colors.red, context);
    }
  }

  // Check if the user is blocked by fetching their block status from Firestore
  checkUserBlockStatus(User? user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Check if the user already exists in Firestore by their UID
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        if (userData['blockStatus'] == 'yes') {
          myMethods.displaySnackBar(
              "Your account is blocked. Please contact support.",
              Colors.red,
              context);
        } else {
          // Proceed with saving the user data if the account is not blocked
          saveUserDataToFirestore(user);
        }
      } else {
        // If the user does not exist in Firestore, save their data
        saveUserDataToFirestore(user);
      }
    } catch (e) {
      myMethods.displaySnackBar("Error: ${e.toString()}", Colors.red, context);
    }
  }

  // Save user data to Firestore
  saveUserDataToFirestore(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('users').doc(user.uid).set({
        'shop_name': userNameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'id': user.uid,
        'blockStatus': 'no',
      });

      // After saving to Firestore, navigate to the HomeScreen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      myMethods.displaySnackBar(
          "Error while saving data: ${e.toString()}", Colors.red, context);
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
          'Register',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        elevation: 4,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: len / 40),
              const Icon(
                Icons.account_circle_outlined,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: len / 40),
              Text(
                'Let\'s become part of our family!',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: len / 40),
              MyTextField(
                controller: userNameController,
                labelText: 'Shop Name',
                obscureText: false,
                textinputtype: TextInputType.multiline,
              ),
              SizedBox(height: len / 40),
              MyTextField(
                controller: phoneController,
                labelText: 'Phone No.',
                obscureText: false,
                textinputtype: TextInputType.number,
              ),
              SizedBox(height: len / 40),
              MyTextField(
                controller: emailController,
                labelText: 'Email ID',
                obscureText: false,
                textinputtype: TextInputType.emailAddress,
              ),
              SizedBox(height: len / 40),
              MyTextField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
                textinputtype: TextInputType.visiblePassword,
              ),
              SizedBox(height: len / 40),
              MyTextField(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: false,
                textinputtype: TextInputType.visiblePassword,
              ),
              SizedBox(height: len / 60),
              SizedBox(height: len / 40),
              MyButton(
                text: 'Register',
                onTap: checkNetwork,
                color: Colors.green.shade900,
              ),
              SizedBox(height: len / 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: len / 40),
            ],
          ),
        ),
      )),
    );
  }
}
