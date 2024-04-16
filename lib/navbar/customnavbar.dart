import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../pages/focusPage.dart';
import '../pages/homePage.dart';
import '../pages/settingPage.dart';

class CustomNavBar extends StatefulWidget {
  // static String routeName = "/custombottomnavbar";
  const CustomNavBar({
    Key? key,
    // required this.selectedMenu,
  }) : super(key: key);
  // final MenuState selectedMenu;
  @override
  CustomNavBarState createState() => CustomNavBarState();
}

var currentIndex = 0;

class CustomNavBarState extends State<CustomNavBar> {
  static var appUsageWithIcons;

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("Alert"),
                content: Text("Do you want to Exit"),
                actions: [
                  CupertinoDialogAction(
                    child: Text(
                      "No",
                      style: TextStyle(
                        // color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(
                      "Exit",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: page[currentIndex],

        //bottom nav bar

        bottomNavigationBar: CurvedNavigationBar(
          onTap: (index) {
            setState(
              () {
                currentIndex = index;
              },
            );
          },
          backgroundColor: Colors.transparent,
          color: Theme.of(context).colorScheme.primary,
          buttonBackgroundColor: Theme.of(context).colorScheme.primary,
          height: 50,
          items: <Widget>[
            Icon(IconlyBold.home,
                color: (currentIndex == 0)
                    ? Theme.of(context).colorScheme.background
                    : Colors.white),
            Icon(IconlyBold.time_circle,
                color: (currentIndex == 1)
                    ? Theme.of(context).colorScheme.background
                    : Colors.white),
            Icon(
              IconlyBold.setting,
              color: (currentIndex == 2)
                  ? Theme.of(context).colorScheme.background
                  : Colors.white,
            ),
          ],
          index: currentIndex,
        ),
      ),
    );
  }

  List<String> listOfStrings = [
    'Home',
    'Teams',
    'Profiles',
  ];

  List page = [
    HomePage(),
    FocusPage(),
    SettingPage(),
  ];
}
