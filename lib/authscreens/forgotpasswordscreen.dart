import 'package:codesleuth/themes/customColors.dart';
import 'package:codesleuth/utility/customtoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top blue box
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
                    "Forgot Password?",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.08,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    "please enter your registered email",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.03,
                      color: Colors.white
                    ),
                  )
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02,),
            // Login Form
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Email
                  SizedBox(
                    width: screenWidth * 0.85 ,
                    child: Form(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          prefixIcon: const Icon(Icons.email_outlined)
                        ),
                        validator: (value){
                          if(value!=null && !EmailValidator.validate(value)){
                            return 'please enter valid email address';
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02,),
                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.75, 50),
                      backgroundColor: customBlueColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                    onPressed: (){sendLink();}, 
                    child: Text(
                      "Send Link",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          ],
        ),
      ),
    );
  }

  Future<void> sendLink() async{

    String emailAddress = _emailController.text.trim();

    if(emailAddress.isEmpty){
      showToast(context: context, title: "Error", message: "Please fill all details", type: "error");
      return;
    }
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      showToast(context: context, title: "Success", message: "Password reset link sent", type: "success");
    }on FirebaseAuthException catch(e){
      showToast(context: context, title: "Error", message: "Email not found in records", type: "error");
    }
  }
}