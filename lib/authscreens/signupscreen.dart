import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesleuth/themes/customColors.dart';
import 'package:codesleuth/utility/customtoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class signupScreen extends StatefulWidget {
  const signupScreen({super.key});

  @override
  State<signupScreen> createState() => _signupScreenState();
}

class _signupScreenState extends State<signupScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Top Blue Box
            Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              decoration: BoxDecoration(
                color: customBlueColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(screenWidth * 0.1), bottomRight: Radius.circular(screenWidth * 0.1))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let's code together",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.08,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    "please fill the details for future reference",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.03,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02,),

            // Signup Form
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Name
                  SizedBox(
                    width: screenWidth * 0.85,
                    child: Form(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: const Icon(Icons.person_2_outlined)
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),

                  // Email
                  SizedBox(
                    width: screenWidth * 0.85,
                    child: Form(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined)
                        ),
                        validator: (value){
                          if(value != null && !EmailValidator.validate(value)){
                            return 'please enter valid email address';
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02,),

                  // Password
                  SizedBox(
                    width: screenWidth * 0.85,
                    child: Form(
                      child: TextFormField(
                        obscureText: _obscureText,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),

                          ),
                          prefixIcon: const Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            onPressed: (){
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        ),
                        validator: (value){
                          if(value != null && value.length<7){
                            return 'min. length 7';
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.75, 50),
                      backgroundColor: customBlueColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                    onPressed: (){register();}, 
                    child: Text(
                      "Register",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white
                      ),
                    )
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() async{
    String userEmail = _emailController.text.trim();
    String userPassword = _passwordController.text.trim();
    String userName = _nameController.text.trim();

    final _auth = FirebaseAuth.instance;

    if(userEmail.isEmpty || userPassword.isEmpty || userName.isEmpty){
      showToast(context: context, title: "Error", message: "Please fill all details", type: "error");
    }

    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

      saveDetails(userName, userEmail);
      showToast(context: context, title: 'Success', message: "Account Created Successfully", type: "success");

      Navigator.pop(context);
    } catch(e){
      if(e is FirebaseAuthException){
        if(e.code == 'email-already-in-use'){
          showToast(context: context, title: "Warning", message: "Email already in use", type: "warning");
        }
        else{
          if(kDebugMode){
            print(e);
          }
        }
      }
      if(kDebugMode){
        print(e);
      }
    }
  }

  Future<void> saveDetails(String name, String email) async{
    await FirebaseFirestore.instance.collection("users").doc(email).set({
      'name': name,
      'email': email,
      'codechef': "",
      'leetcode': "",
      'codeforces': "",
    });
  }
}