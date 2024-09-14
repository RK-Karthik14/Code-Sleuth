import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codesleuth/themes/customColors.dart';
import 'package:codesleuth/utility/customtoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class handlesPage extends StatefulWidget {
  const handlesPage({super.key});

  @override
  State<handlesPage> createState() => _handlesPageState();
}

class _handlesPageState extends State<handlesPage> {

  final TextEditingController _codechefController = TextEditingController();
  final TextEditingController _codeforcesController = TextEditingController();
  final TextEditingController _leetcodeController = TextEditingController();

  String logowithname = "assets/images/logowithname.png";
  String logowithamewhite = "assets/images/logowithnamewhite.png";
  String codechefpng = "assets/images/codechef.png";
  String leetcodepng = "assets/images/leetcode.png";
  String codeforcespng = "assets/images/codeforces.png";

  String email = "";
  String? username;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus().whenComplete(() async{
      getUserName();
    });
    _loadHandle();
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
                  "Update your handles ${username}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.05,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "please fill all the handles",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: screenWidth * 0.02,
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),
        
          SizedBox(height: screenHeight * 0.01,),

          //Form
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Image
                Container(
                  width: 200,
                  height: 200,
                  child: Image.asset(isDarkMode ? logowithamewhite : logowithname),
                ),
              
                // Codechef
                SizedBox(
                  width: screenWidth * 0.75,
                  child: Form(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _codechefController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Codechef",
                        hintText: "Enter codechef handle",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(codechefpng, width: 10,),
                        )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02,),

                // Leetcode
                SizedBox(
                  width: screenWidth * 0.75,
                  child: Form(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _leetcodeController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Leetcode",
                        hintText: "Enter leetcode handle",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(leetcodepng, width: 10,),
                        )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02,),

                // Codeforces
                SizedBox(
                  width: screenWidth * 0.75,
                  child: Form(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _codeforcesController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Codeforces",
                        hintText: "Enter codeforces handle",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(codeforcespng, width: 10,),
                        )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02,),
              
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.75, 50),
                    backgroundColor: customBlueColor,
                    elevation: 1,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                  ),
                  onPressed: (){_updateDetails();}, 
                  child: Text(
                    "Update",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateDetails() async{
    String codechefHandle = _codechefController.text.trim();
    String leetcodeHandle = _leetcodeController.text.trim();
    String codeforcesHandle = _codeforcesController.text.trim();

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('codechef', codechefHandle);
    await sharedPreferences.setString('leetcode', leetcodeHandle);
    await sharedPreferences.setString('codeforces', codeforcesHandle);

    await FirebaseFirestore.instance.collection("users").doc(email).update({
      'codechef': codechefHandle,
      'codeforces': codeforcesHandle,
      'leetcode': leetcodeHandle,
    });

    showToast(context: context, title: "Success", message: 'Handles Updated successfully', type: "success");
    setState(() {
      _codechefController.text = codechefHandle;
      _leetcodeController.text = leetcodeHandle;
      _codeforcesController.text = codeforcesHandle;
    });

  }

  Future<void> _loadHandle() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _codechefController.text = sharedPreferences.getString('codechef') ?? '';
      _leetcodeController.text = sharedPreferences.getString('leetcode') ?? '';
      _codeforcesController.text = sharedPreferences.getString('codeforces') ?? '';
    });
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

  Future<void> getUserName() async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(email).get();

    if(doc.exists){
      setState(() {
        username = doc['name'];
      });
    }
  }
}