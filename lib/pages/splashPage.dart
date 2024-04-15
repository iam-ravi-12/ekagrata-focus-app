
import 'package:ekagrata_app/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icon/icon 1.png",
            width: 200,
          ),
          SizedBox(height: 50),
          Text("Welcome"),
          SizedBox(height: 10),
          Text("to"),
          SizedBox(height: 10),
          Text("EKaGRaTA"),
          SizedBox(height: 10),
          Text("Gain Control over you time and life."),
          SizedBox(height: 30),
          ElevatedButton(
            style: ButtonStyle(
                elevation: MaterialStatePropertyAll(8),
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.outline)),
            onPressed: () {
              Get.to(() => LoginForm());
            },
            child: Text(
              "GET STARTED",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      )),
    );
  }
}
