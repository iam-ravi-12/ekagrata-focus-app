// import 'package:ekagrata/Screen/graph/home_page_graph.dart';
import 'package:ekagrata_app/app/appWithIcon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_charts/flutter_charts.dart';

import '../app/gameappWithIcon.dart';
import '../graph/home_page_graph.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ffbe0b
      backgroundColor: Color(0xFFffbe0b).withOpacity(0.7),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 60, left: 10, right: 10),
          // padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        child: Text(
                          "${FirebaseAuth.instance.currentUser?.displayName![0].toUpperCase()}",
                          style: TextStyle(fontSize: 40),
                        ),
                        radius: 35,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Text(
                              "${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase()}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      LinearPercentIndicator(
                        backgroundColor: Colors.black45,
                        animation: true,
                        animationDuration: 2000,
                        lineHeight: 20,
                        width: MediaQuery.of(context).size.width / 2.4,
                        percent: 0.6,
                        barRadius: Radius.circular(20),
                        linearGradient:
                            LinearGradient(colors: [Colors.red, Colors.blue]),
                      ),
                      Text("Daily Progress:"),
                      LinearPercentIndicator(
                        backgroundColor: Colors.black45,
                        animation: true,
                        animationDuration: 2000,
                        lineHeight: 20,
                        width: MediaQuery.of(context).size.width / 2.4,
                        percent: 0.35,
                        barRadius: Radius.circular(20),
                        linearGradient:
                            LinearGradient(colors: [Colors.red, Colors.blue]),
                      ),
                      Text("Weekly Progress:"),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black38,
                ),
                child: Column(
                  children: [
                    HomePageGraph(),
                    Row(
                      children: [
                        Text("Total usage: 4h"),
                        Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text("More"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gaming App",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => AppWithIcon());
                    },
                    child: Text("All Apps"),
                  ),
                ],
              ),

              Container(
                height: 670,
                child: GameAppWithIcon(),
              )
              // Container(
              //   child: Text("All App"),
              // ),
              // Container(child: GameAppUsageData()),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:ekagrata_app/app/gameappWithIcon.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

// import '../app/appWithIcon.dart';
// import '../graph/home_page_graph.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Container(
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     child: Text(
//                       "${FirebaseAuth.instance.currentUser?.displayName?.characters}",
//                     ),
//                   ),
//                   SizedBox(width: 10),
//                   Column(
//                     children: [
//                       Text(
//                         "Hello,",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.2,
//                         child: Text(
//                           "${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase()}",
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       LinearPercentIndicator(
//                         backgroundColor: Colors.black45,
//                         animation: true,
//                         animationDuration: 2000,
//                         lineHeight: 20,
//                         width: MediaQuery.of(context).size.width / 2.4,
//                         percent: 0.8,
//                         barRadius: Radius.circular(20),
//                         linearGradient:
//                             LinearGradient(colors: [Colors.red, Colors.blue]),
//                       ),
//                       Text("Daily Progress:"),
//                       LinearPercentIndicator(
//                         backgroundColor: Colors.black45,
//                         animation: true,
//                         animationDuration: 2000,
//                         lineHeight: 20,
//                         width: MediaQuery.of(context).size.width / 2.4,
//                         percent: 0.4,
//                         barRadius: Radius.circular(20),
//                         linearGradient:
//                             LinearGradient(colors: [Colors.red, Colors.blue]),
//                       ),
//                       Text("Weekly Progress:"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             //
//             Container(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               margin: EdgeInsets.symmetric(vertical: 10),
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: Colors.grey),
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.black38,
//               ),
//               child: Column(
//                 children: [
//                   HomePageGraph(),
//                   Row(
//                     children: [
//                       Text("Total usage: 4h"),
//                       Spacer(),
//                       TextButton(
//                         onPressed: () {},
//                         child: Text("More"),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Get.to(() => AppWithIcon());
//               },
//               child: Text("Tap Me"),
//             ),

//             Container(child: GameAppUsageData())
//           ],
//         ),
//       ),
//     );
//   }
// }
