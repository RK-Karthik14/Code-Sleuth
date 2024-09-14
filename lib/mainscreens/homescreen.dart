import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:codesleuth/mainscreens/components/dashboard.dart';
import 'package:codesleuth/mainscreens/components/handles.dart';
import 'package:codesleuth/themes/customColors.dart';
import 'package:codesleuth/utility/notificationhelper.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  int index = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: AwesomeHelper.onActionReceivedMethod,
      onDismissActionReceivedMethod: AwesomeHelper.onDismissActionReceivedMethod,
      onNotificationCreatedMethod: AwesomeHelper.onNotificationCreatedMethod,
      onNotificationDisplayedMethod: AwesomeHelper.onNotificationDisplayedMethod
    );
  }
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // bottomNavigationBar: CurvedNavigationBar(
      //   height: (screenHeight > 900 ? 75 : screenHeight * 0.07),
      //   index: index,
      //   onTap: (selectedIndex){
      //     setState(() {
      //       index = selectedIndex;
      //     });
      //   },
      //   letIndexChange: (index)=> true,
      //   animationDuration: const Duration(milliseconds: 500),
      //   backgroundColor: Theme.of(context).colorScheme.background,
      //   color: customBlueColor,
      //   items: [
      //     Icon(
      //       Icons.person_2_outlined,
      //       size: screenWidth * 0.07,
      //       color: Colors.white,
      //     ),
      //     Icon(
      //       Icons.home_outlined,
      //       size: screenWidth * 0.07,
      //       color: Colors.white,
      //     ),
      //   ],
      // ),
      bottomNavigationBar: NavigationBar(
        height: (screenHeight > 900 ? 80 : screenHeight * 0.07),
        elevation: 0,
        selectedIndex: index,
        onDestinationSelected: (selectedIndex){
          setState(() {
            index = selectedIndex;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_2_outlined), label: 'Profile'),
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        ],
      ),
      body: SingleChildScrollView(
        child: _buildContent(screenWidth, screenHeight, context),
      ),
    );
  }

  Widget _buildContent(double screenWidth, double screenHeight, BuildContext context){
    switch(index){
      case 0:
        return handlesPage();
      case 1:
        return dashboard();
      default:
        return Center(
          child: Text(
            "Index",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
    }
  }
}