import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codesleuth/firebase_options.dart';
import 'package:codesleuth/mainscreens/splashscreen.dart';
import 'package:codesleuth/themes/darkTheme.dart';
import 'package:codesleuth/themes/lightTheme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Notification Initialization
  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(channelGroupKey: "channelgroupkey", channelKey: "channelkey", channelName: "channelname", channelDescription: "channeldescription", playSound: true, enableLights: true, enableVibration: true)
    ],
    channelGroups: [
      NotificationChannelGroup(channelGroupKey: "channelgroupkey", channelGroupName: "channelgroupname")
    ]
  );
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(!isAllowedToSendNotification){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  if(kDebugMode){
    print(isAllowedToSendNotification);
  }


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MyApp(),
  //   )
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const splashScreen(),
    );
  }
}