import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codesleuth/authscreens/forgotpasswordscreen.dart';
import 'package:codesleuth/authscreens/signupscreen.dart';
import 'package:codesleuth/mainscreens/homescreen.dart';
import 'package:codesleuth/themes/customColors.dart';
import 'package:codesleuth/utility/customtoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {

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

            // Top blue Box
            Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              padding: EdgeInsets.only(left: screenWidth * 0.05),
              decoration: BoxDecoration(
                color: customBlueColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(screenWidth * 0.1), bottomRight: Radius.circular(screenWidth*0.1))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome back!",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.08,
                      color: Colors.white
                    ),
                  ),
                  Text(
                    "please login with your credentials",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.03,
                      color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
          
            SizedBox(height: screenHeight * 0.02,),

            // Login form
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  //Email
                  SizedBox(
                    width: screenWidth * 0.85,
                    child: Form(
                      child: TextFormField(
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (value){
                          if(value != null && !EmailValidator.validate(value)){
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
                      ),
                    ),
                  ),
                
                  SizedBox(height: screenHeight * 0.01,),

                  //Forgot Password
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const forgotPassword()));
                      },
                      child: Text(
                        "Forgot Password",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: customeLightBlueColor
                        ),
                      ),
                    ),
                  ),
                
                  SizedBox(height: screenHeight * 0.01,),

                  //Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.75, 50),
                      backgroundColor: customBlueColor,
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ),
                    onPressed: (){login();}, 
                    child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white
                      ),
                    )
                  ),
                
                  SizedBox(height: screenHeight * 0.01,),

                  // Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const signupScreen()));
                        }, 
                        child: Text(
                          "Register Now!",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                            color: customeLightBlueColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() async{
    String userEmail = _emailController.text.trim();
    String userPassword = _passwordController.text.trim();

    if(userEmail.isEmpty || userPassword.isEmpty){
      showToast(context: context, title: "Error", message: "Please fill all fields", type: "error");
      return;
    }

    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: userEmail, password: userPassword);

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('email', userEmail);
      subscribeTopic();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const homeScreen()));
    } catch(e){
      if(e is FirebaseAuthException){
        if(e.code == 'invalid-credential'){
          showToast(context: context, title: "Warning", message: "User not found", type: "warning");
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

  Future<void> subscribeTopic() async{
    await FirebaseMessaging.instance.subscribeToTopic("notify").then((value){
      if(kDebugMode){
        print("Subscribed to topic");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      if(kDebugMode){
        print(message.notification?.title.toString());
        print(message.notification?.body.toString());
      }
      AwesomeNotifications().createNotification(content: NotificationContent(id: 1, channelKey: "channelkey", title: message.notification?.title, body: message.notification?.body));
    });
  }
}