import 'package:ekagrata_app/pages/splashPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFffbe0b).withOpacity(0.7),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            child: Text(
              "${FirebaseAuth.instance.currentUser?.displayName![0].toUpperCase()}",
              style: TextStyle(fontSize: 60),
            ),
            radius: 50,
          ),
          SizedBox(height: 10),
          Text(
            "${FirebaseAuth.instance.currentUser?.displayName?.toUpperCase()}",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                TextButton(
                  // style: ButtonStyle(textStyle: ),
                  onPressed: () {},
                  child: Text("Profile"),
                ),
                Divider(
                  thickness: 1, // Customize thickness as needed
                  color: Colors.black, // Customize color as needed
                  indent: 10, // Optional: Add an indent from the left
                  endIndent: 10, // Optional: Add an indent from the right
                ),
                TextButton(
                  // style: ButtonStyle(textStyle: ),
                  onPressed: () {},
                  child: Text("Privacy Policy"),
                ),
                Divider(
                  thickness: 1, // Customize thickness as needed
                  color: Colors.black, // Customize color as needed
                  indent: 10, // Optional: Add an indent from the left
                  endIndent: 10, // Optional: Add an indent from the right
                ),
                TextButton(
                  // style: ButtonStyle(textStyle: ),
                  onPressed: () {},
                  child: Text("Terms & Conditions"),
                ),
                Divider(
                  thickness: 1, // Customize thickness as needed
                  color: Colors.black, // Customize color as needed
                  indent: 10, // Optional: Add an indent from the left
                  endIndent: 10, // Optional: Add an indent from the right
                ),
                TextButton(
                  // style: ButtonStyle(textStyle: ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(() => SplashPage());
                  },
                  child: Text("Log Out"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
