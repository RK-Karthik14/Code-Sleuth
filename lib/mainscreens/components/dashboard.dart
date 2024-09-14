import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesleuth/themes/customColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class dashboard extends StatefulWidget {
  const dashboard({super.key});

  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {

  String email = "";
  bool _showPlatformInfo = false;
  String platformName = "";

  String codechefhandle = "";
  String codechefCurrentRating = "***";
  String codechefHighestRating = "***";
  String codechefStars = "***";
  String codechefGlobalRank = "***";
  String codechefLocalRank = "***";
  String codecehfLatestContest = "***";

  String leetcodehandle = "";
  String leetcodeRanking = "***";
  String leetcodeTQ = "***";
  String leetcodeSC = "***";
  String leetcodeAR = "***";
  String leetcodeCP = "";

  String codeforceshandle = "";
  String codeforcesRating = "***";
  String codeforcesHR ="***";
  String codeforcesTS = "***";
  String codeforcesLV = "***";
  String? username;

  String codechefpng = "assets/images/codechef.png";
  String codechefpngwhite = "assets/images/codechefwhite.png";
  String leetcodepng = "assets/images/leetcode.png";
  String leetcodewhite = "assets/images/leetcodewhite.png";
  String codeforcespng = "assets/images/codeforces.png";
  String codeforceswhite = "assets/images/codeforceswhite.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus().whenComplete(() async{
      getHandles();
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [

          // Top Blue Box
          Container(
            width: screenWidth,
            height: screenHeight * 0.3,
            padding: EdgeInsets.only(left: screenWidth * 0.03),
            decoration: BoxDecoration(
              color: customBlueColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(screenWidth * 0.05), bottomRight: Radius.circular(screenWidth * 0.05))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Show the power of coding ${username}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Let's begin from scratch again",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: screenWidth * 0.02,
                    color: Colors.white,
                  ),
                ),
                Text(getFormatteDate(), style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.blue[200]
                ),)
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.02,),
        
          // Condition for info specific or not
          _showPlatformInfo ? platformSpecificContainer(screenWidth, screenHeight, isDarkMode, platformName) :
          Container(
            padding: EdgeInsets.all(20),
            width: screenWidth,
            height: screenHeight * 0.55,
            child: Column(
              children: [

                // Leetcode & Codechef
                Row(
                  children: [

                    // Codechef
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                _showPlatformInfo = true;
                                platformName = "codechef";
                              });
                            },
                            child: platformContainer(screenWidth, screenHeight, (isDarkMode? codechefpngwhite : codechefpng), "Rating", codechefCurrentRating, isDarkMode),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: screenWidth * 0.02,),
                    // Leetcode
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                _showPlatformInfo = true;
                                platformName = "leetcode";
                              });
                            },
                            child: platformContainer(screenWidth, screenHeight, (isDarkMode? leetcodewhite : leetcodepng), "Rank", leetcodeRanking, isDarkMode),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05,),
                //Codeforces
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            _showPlatformInfo = true;
                            platformName = "codeforces";
                          });
                        },
                        child: platformContainer(screenWidth, screenHeight, (isDarkMode? codeforceswhite : codeforcespng), "Rating", codeforcesRating, isDarkMode),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Container platformSpecificContainer(double screenWidth, double screenHeight, bool isDarkMode, String platformName){
    return Container(
      width: screenWidth,
      height: screenHeight * 0.55,
      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    _showPlatformInfo = false;
                  });
                }, 
                icon: Icon(Icons.arrow_back_ios_new_outlined),
              ),
              Text(
                "Analysis",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: screenWidth * 0.03
                ),
              ),
            ],
          ),
        
          Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.5,
            decoration: BoxDecoration(
              color: (isDarkMode ? Colors.black : Colors.blue[200]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: (isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2)), spreadRadius: 5, blurRadius: 7, offset: Offset(0,3))
              ],
            ),
            child: _buildplatformSpecificContainer(platformName, isDarkMode, screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildplatformSpecificContainer(String platformName, bool isDarkMode, double screenWidth){
    switch(platformName){
      case "codechef":
        return codechefInfoContainer(isDarkMode, screenWidth);
      case "leetcode":
        return leetcodeInfoContainer(isDarkMode, screenWidth);
      case "codeforces":
        return codeforcesInfoContainer(isDarkMode, screenWidth);
      default:
        return Container();
    }
  }

  Container codechefInfoContainer(bool isDarkMode, double screenWidth){
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          // Image Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset(isDarkMode ? codechefpngwhite : codechefpng),
              ),
              Text(
                "CodeChef",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),

          // Details Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Row(
                children: [
                  Text(
                    "Handle:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefhandle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor, 
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rating(P):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefCurrentRating,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rating(H):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefHighestRating,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Stars:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefStars,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rank(G):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefGlobalRank,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rank(L):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codechefLocalRank,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Last Contest:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codecehfLatestContest,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container leetcodeInfoContainer(bool isDarkMode, double screenWidth){
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          // Image Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset(isDarkMode ? leetcodewhite : leetcodepng),
              ),
              Text(
                "Leetcode",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),

          // Details Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Row(
                children: [
                  Text(
                    "Handle:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodehandle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Ranking:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodeRanking,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Total Questions:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodeTQ,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Total Solved:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodeSC,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Acceptance Rate:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodeAR,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Contribution Points:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    leetcodeCP,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ],
      ),
    );
  }
  
  Container codeforcesInfoContainer(bool isDarkMode, double screenWidth){
    return Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          // Image Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Image.asset(isDarkMode ? codeforceswhite : codeforcespng),
              ),
              Text(
                "Codeforces",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),

          // Details Row
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Row(
                children: [
                  Text(
                    "Handle:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codeforceshandle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rating(C):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codeforcesRating,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rating(H):  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codeforcesHR,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Total Solved:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codeforcesTS,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Last Visit:  ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: screenWidth * 0.02,
                    ),
                  ),
                  Text(
                    codeforcesLV,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isDarkMode ? Colors.blue[200] : customBackgroundColor,
                      fontSize: screenWidth * 0.03
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ],
      ),
    );
  }

  Container platformContainer(double screenWidth, double screenHeight, String image, String lableName, String lableValue, bool isDarkMode){
    return Container(
      width: (screenWidth / 2) - 40,
      height: (screenHeight / 4) - 40,
      decoration: BoxDecoration(
        color: (isDarkMode ? Colors.black : Colors.blue[200]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: (isDarkMode? Colors.white.withOpacity(0.2): Colors.black.withOpacity(0.2)), spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3))
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Image
          Container(
            width: (screenWidth / 4) - 80,
            height: (screenWidth / 4) - 80,
            child: Image.asset(image),
          ),

          // Label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                lableName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(width: 5,),

              Text(
                lableValue,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDarkMode ? Colors.blue[200] : Colors.white
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getFormatteDate(){
    DateTime now = DateTime.now();

    String day = DateFormat('dd').format(now);
    String weekday = DateFormat('EEE').format(now);
    String year = DateFormat('yyyy').format(now);

    return "$day, $weekday, $year";
  }

  Future getStatus() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var userEmail = sharedPreferences.getString("email");

    if(userEmail != null){
      setState(() {
        email = userEmail;
      });
    }
  }

  Future<void> getHandles() async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(email).get();

    if(doc.exists){
      setState(() {
        codechefhandle = doc['codechef'];
        codeforceshandle = doc['codeforces'];
        leetcodehandle = doc['leetcode'];
        username = doc['name'];
      });
    }

    if(codechefhandle != ""){
      _fetchCodechefInfo();
    }

    if(leetcodehandle != ""){
      _fetchLeetcodeInfo();
    }

    if(codeforceshandle != ""){
      _fetchCodeforcesInfo();
    }
  }

  Future<void> _fetchCodechefInfo() async{
    try{
      final response = await http.get(
        Uri.parse('https://codechef-api-one.vercel.app/$codechefhandle')
      );

      if(response.statusCode == 200){
        final userData = jsonDecode(response.body);
        setState(() {
          codechefCurrentRating = userData['currentRating'].toString();
          codechefHighestRating = userData['highestRating'].toString();
          codechefStars = userData['stars'].toString();
          codechefGlobalRank = userData['globalRank'].toString();
          codechefLocalRank = userData['countryRank'].toString();
          codecehfLatestContest = userData['lastContest'].toString(); 
        });
      }

    } catch(e){
      if(kDebugMode){
        print(e);
      }
    }
  }

  Future<void> _fetchLeetcodeInfo() async{
    try{
      final response = await http.get(
        Uri.parse('https://leetcode-stats-api.herokuapp.com/$leetcodehandle')
      );

      if(response.statusCode == 200){
        final userData = jsonDecode(response.body);
        setState(() {
          leetcodeRanking = userData['ranking'].toString();
          leetcodeTQ = userData['totalQuestions'].toString();
          leetcodeSC = userData['totalSolved'].toString();
          leetcodeAR = userData['acceptanceRate'].toString();
          leetcodeCP = userData['contributionPoints'].toString();
        });
      }
    } catch(e){
      if(kDebugMode){
        print(e);
      }
    }
  }

  Future<void> _fetchCodeforcesInfo() async{
    try{
      final response = await http.get(
        Uri.parse('https://codeforces-api-zeta.vercel.app/$codeforceshandle')
      );

      if(response.statusCode == 200){
        final userData = jsonDecode(response.body);
        setState(() {
          codeforcesRating = userData['curr_rating'].toString();
          codeforcesHR = userData['max_rating'].toString();
          codeforcesTS = userData['tot_probs'].toString();
          codeforcesLV = userData['last_visit'].toString();
        });
      }
    } catch(e){
      if(kDebugMode){
        print(e);
      }
    }
  }
}